// Copyright (c) 2018-2020 Bluespec, Inc. All Rights Reserved.
//
//-
// RVFI_DII + CHERI modifications:
//     Copyright (c) 2020 Alexandre Joannou
//     Copyright (c) 2020 Peter Rugg
//     Copyright (c) 2020 Jonathan Woodruff
//     All rights reserved.
//
//     This software was developed by SRI International and the University of
//     Cambridge Computer Laboratory (Department of Computer Science and
//     Technology) under DARPA contract HR0011-18-C-0016 ("ECATS"), as part of the
//     DARPA SSITH research programme.
//
//     This work was supported by NCSC programme grant 4212611/RFA 15971 ("SafeBet").
//-

package CoreW;

// ================================================================
// This package is called 'CoreW' for 'Core Wrapper'
// and corresponds to 'Core' in Piccolo and Flute.
//
// Here in Toooba, we use the name 'CoreW' to avoid a name-clash with
// an inner module called 'Core' in MIT's RISCY-OOO.
//
// The specific correspondence with Piccolo/Flute structure is:
//    Piccolo/Flute    Toooba
//      mkCore         mkCoreW
//                     mkProc
//      mkCPU          mkCore


// This package defines:
//     Core_IFC
//     mkCore #(Core_IFC)
//
// mkCoreW instantiates:
//     - mkProc (the RISC-V CPU, a version of MIT's RISCY-OOO)
//     - mkPLIC_16_CoreNumX2_7
//     - mkTV_Encode          (Tandem-Verification logic, optional: INCLUDE_TANDEM_VERIF)
//     - mkDebug_Module       (RISC-V Debug Module, optional: INCLUDE_GDB_CONTROL)
// and connects them all up.

// ================================================================
// BSV library imports

import Vector       :: *;
import FIFO         :: *;
import FIFOF        :: *;
import GetPut       :: *;
import ClientServer :: *;
import Connectable  :: *;
import Clocks       :: *;

// ----------------
// BSV additional libs

import Cur_Cycle  :: *;
import GetPut_Aux :: *;
import Routable   :: *;
import AXI4       :: *;
import TagControllerAXI :: *;

// ================================================================
// Project imports

// ----------------
// From RISCY-ooo
import ProcTypes    :: *;

// ----------------
// From Toooba

// Main fabric
import Fabric_Defs  :: *;    // for Wd_Id, Wd_Addr, Wd_Data...
import SoC_Map      :: *;
import CCTypes      :: *;    // for EventsCache.

`ifdef INCLUDE_GDB_CONTROL
import Debug_Module  :: *;
`endif

import WindCoreInterface :: *;
import Proc_IFC          :: *;
import Proc              :: *;

import PLIC                :: *;
import PLIC_16_CoreNumX2_7 :: *;

`ifdef INCLUDE_TANDEM_VERIF
import TV_Info                   :: *;
import Trace_Data2               :: *;
import TV_Encode                 :: *;
import Trace_Data2_to_Trace_Data :: *;
`endif

// TV_Taps needed when both GDB_CONTROL and TANDEM_VERIF are present
`ifdef INCLUDE_GDB_CONTROL
`ifdef INCLUDE_TANDEM_VERIF
import TV_Taps  :: *;
`endif
`endif

import DM_CPU_Req_Rsp ::*;

// ================================================================
// The Core module

typedef WindCoreMid #( // AXI manager 0 port parameters
                       TAdd#(Wd_MId,1), Wd_Addr, Wd_Data, 0, 0, 0, 0, 0
                       // AXI manager 1 port parameters
                     , TAdd#(Wd_MId,1), Wd_Addr, Wd_Data, 0, 0, 0, 0, 0
                       // AXI subordinate 0 port parameters
                     , 0, 0, 0, 0, 0, 0, 0, 0
                       // Number of interrupt lines
                     , N_External_Interrupt_Sources) WindCoreMidIfc;

//(* synthesize *)
module mkCoreW (WindCoreMidIfc);
   Reset dfltRst <- exposeCurrentReset;
   Reset otherRst = ?;
   match {.fromDbgReset, .ifc} <- mkCoreResetHelper ( dfltRst
                                                    , reset_by otherRst );
   otherRst <- mkResetEither (dfltRst, fromDbgReset);
   return ifc;
endmodule

// The interface to this module is a convenience to avoid exposing the reset
// hacks to the nicer outer interface, and not have to use a large amount of
// reset_by to decouple the debug module from the rest...
module mkCoreResetHelper #(Reset toDbgReset)
                          (Tuple2#(Reset, WindCoreMidIfc));

   // ================================================================
   // Notes on 'reset'

   // This module's default reset (Verilog RST_N) is a
   // 'non-debug-module reset', or 'ndm-reset': it resets everything
   // in mkCoreW other than the optional RISC-V Debug Module (DM).

   // DM is reset ONLY by 'toDbgReset' (parameter of this module).
   // This is expected to be performed exactly once, on power-up.

   // Note: DM has an internal functionality that the DM spec calls
   //   'dm_reset'. This is not really an electrical reset, it is just
   //   a module initializer wholly within the DM to put it into a
   //   known state.  To be able to do a dm_reset, the DM has to be
   //   working already, at least to the point that it can field DMI
   //   requests from the external debugger asking the DM to proform a
   //   dm_reset.

   // DM can ask the environment to perform an 'ndm-reset', which the
   // environment does by asserting the default reset (RST_N).  At the
   // same time, the environment may also reset part or all of the
   // rest of the SoC.

   // DM can also individually reset each hart in mkCPU.
   // 'hart' = hardware thread = independent PC and fetch-and-execute pipeline.
   // mkCPU (instantiated in this module) has one or more harts.
   // This hart-reset logic is entirely within this module.

   // ================================================================
   // The CPU's (hart's) reset is the ``or'' of the default reset
   // (power-on reset) and the Debug Module's 'hart_reset' control.

   let ndm_reset <- exposeCurrentReset;

`ifdef INCLUDE_GDB_CONTROL
   let clk <- exposeCurrentClock;
   Bool    initial_reset_val   = False;
   Integer hart_reset_duration = 10;    // NOTE: assuming 10 cycle reset enough for hart
   Vector #(CoreNum, MakeResetIfc) dm_harts_reset_controller <- replicateM(mkReset(hart_reset_duration, initial_reset_val, clk));

   function Reset proj_new_rst (MakeResetIfc x) = x.new_rst;

   let all_harts_reset <- foldlM (mkResetEither, ndm_reset, map (proj_new_rst, dm_harts_reset_controller));
`else
   let all_harts_reset = ndm_reset;
`endif

   // ================================================================
   // STATE

   // System address map
   SoC_Map_IFC  soc_map  <- mkSoC_Map;

   // RISCY-OOO processor
   // TODO: could have separate resets for each core.
   Proc_IFC proc <- mkProc (reset_by all_harts_reset);

   // handle uncached interface
   let proc_uncached = extendIDFields (zeroMasterUserFields (proc.master1), 0);
   // Bridge for uncached expernal bus transactions.
   let uncached_mem_shim <- mkAXI4ShimFF(reset_by all_harts_reset);

   // handle cached interface
   // AXI4 tagController
   TagControllerAXI#(Wd_MId, Wd_Addr, Wd_Data) tagController <- mkTagControllerAXI(reset_by all_harts_reset); // TODO double check if reseting like this is good enough
   mkConnection(proc.master0, tagController.slave, reset_by all_harts_reset);
`ifdef PERFORMANCE_MONITORING
   rule report_tagController_events;
      Vector#(7, Bit#(1)) evts = tagController.events;
      EventsCache ce = unpack(0);
      ce.evt_ST = zeroExtend(evts[0]); // Unsure of mapping from EventsCacheCore to 7-bit vector.
      ce.evt_ST_MISS = zeroExtend(evts[1]);
      ce.evt_LD = zeroExtend(evts[2]);
      ce.evt_LD_MISS = zeroExtend(evts[3]);
      ce.evt_EVICT = zeroExtend(evts[4]);
      // SET_TAG_WRITE/READ aren't used in TagCache; tag table data is not tagged.
      proc.events_tgc(ce);
   endrule
`endif

   // PLIC (Platform-Level Interrupt Controller)
   PLIC_IFC_16_CoreNumX2_7  plic <- mkPLIC_16_CoreNumX2_7;

`ifdef INCLUDE_GDB_CONTROL
   // Debug Module
   Debug_Module_IFC  debug_module <- mkDebug_Module (reset_by toDbgReset);
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // The following are a superscalar-wide set of transformers from RISCY-OOO output Trace_Data2
   // to Trace_Data which is input to the TV encoder
   Vector #(SupSize, Trace_Data2_to_Trace_Data_IFC) v_td2_to_td <- replicateM (mkTrace_Data2_to_Trace_Data);

   // The TV encoder transforms Trace_Data structures from the CPU and DM
   // into encoded byte vectors for transmission to the Tandem Verifier
   TV_Encode_IFC tv_encode <- mkTV_Encode;
`endif

   // ================================================================
   // Hart-reset from DM

`ifdef INCLUDE_GDB_CONTROL
   Reg #(Bit #(8))  rg_harts_reset_delay <- mkReg (0);
   Reg #(Bit #(64)) rg_tohost_addr       <- mkReg (0);
   Reg #(Bit #(64)) rg_fromhost_addr     <- mkReg (0);

   for (Integer core = 0; core < valueOf(CoreNum); core = core + 1)
      rule rl_dm_harts_reset (rg_harts_reset_delay == 0);
	 let x <- debug_module.harts_reset_client[core].request.get;
	 dm_harts_reset_controller[core].assertReset;
	 rg_harts_reset_delay <= fromInteger (hart_reset_duration + 200);    // NOTE: heuristic

	 $display ("%0d: %m.rl_dm_harts_reset: asserting harts reset for %0d cycles",
                cur_cycle, hart_reset_duration);
   endrule

   rule rl_dm_harts_reset_wait (rg_harts_reset_delay != 0);
      if (rg_harts_reset_delay == 1) begin
         let pc = soc_map_struct.pc_reset_value;
         Bool is_running = True;
	 proc.start (is_running, pc, rg_tohost_addr, rg_fromhost_addr);
         // We reset all the harts, so we indicate this to the DM, even though it's possible only one hart was requested to reset
         for (Integer core = 0; core < valueOf(CoreNum); core = core + 1)
	    debug_module.harts_reset_client[core].response.put (is_running);
	 $display ("%0d: %m.rl_dm_harts_reset_wait: proc.start (pc %0h, tohostAddr %0h, fromhostAddr %0h",
                   cur_cycle, pc, rg_tohost_addr, rg_fromhost_addr);
      end
      rg_harts_reset_delay <= rg_harts_reset_delay - 1;
   endrule

`endif

`ifdef INCLUDE_GDB_CONTROL
   // ================================================================
   // Direct DM-to-CPU connections for run-control and other misc requests

   mkConnection (debug_module.harts_client_run_halt, proc.harts_run_halt_server);
   mkConnection (debug_module.harts_get_other_req,   proc.harts_put_other_req);
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // ================================================================
   // Direct CPU-to-TV connections for TV trace data

   for (Integer j = 0; j < valueOf (SupSize); j = j + 1) begin
      // CPU Trace_Data2 output streams to Trace_Data2_to_Trace_Data converters
      mkConnection (proc.v_to_TV [j], v_td2_to_td [j].in);
      // Trace_Data2_to_Trace_Data converters to TV encoder
      mkConnection (v_td2_to_td [j].out, tv_encode.v_cpu_in [j]);
   end
`endif

`ifdef INCLUDE_GDB_CONTROL
`ifdef INCLUDE_TANDEM_VERIF
   // ================================================================
   // BEGIN SECTION: DM and TV both present
   // We instantiate 'taps' into connections where DM writes CPU GPRs,
   // FPRs, CSRs, and main memory.  The tap outputs go the TV encoder,
   // to keep the tandem verifier in sync with DM updates to the CPU.

   // Create a tap for DM's memory-writes to the bus, and merge-in the trace data.
   DM_Mem_Tap_IFC dm_mem_tap <- mkDM_Mem_Tap;
   mkConnection (debug_module.master, dm_mem_tap.slave);
   let dm_master_local = dm_mem_tap.master;

   rule rl_merge_dm_mem_trace_data;
      let tmp <- dm_mem_tap.trace_data_out.get;
      tv_encode.dm_in.put (tmp);
   endrule

   // Create a tap for DM's GPR writes to the CPU, and merge-in the trace data.
   DM_GPR_Tap_IFC  dm_gpr_tap_ifc <- mkDM_GPR_Tap;
   mkConnection (debug_module.hart0_gpr_mem_client, dm_gpr_tap_ifc.server);
   mkConnection (dm_gpr_tap_ifc.client, proc.hart0_gpr_mem_server);

   rule rl_merge_dm_gpr_trace_data;
      let tmp <- dm_gpr_tap_ifc.trace_data_out.get;
      tv_encode.dm_in.put (tmp);
   endrule

`ifdef ISA_F_OR_D
   // Create a tap for DM's FPR writes to the CPU, and merge-in the trace data.
   DM_FPR_Tap_IFC  dm_fpr_tap_ifc <- mkDM_FPR_Tap;
   mkConnection (debug_module.hart0_fpr_mem_client, dm_fpr_tap_ifc.server);
   mkConnection (dm_fpr_tap_ifc.client, proc.hart0_fpr_mem_server);

   rule rl_merge_dm_fpr_trace_data;
      let tmp <- dm_fpr_tap_ifc.trace_data_out.get;
      tv_encode.dm_in.put (tmp);
   endrule
`endif
   // for ifdef ISA_F_OR_D

   // Create a tap for DM's CSR writes, and merge-in the trace data.
   DM_CSR_Tap_IFC  dm_csr_tap <- mkDM_CSR_Tap;
   mkConnection(debug_module.hart0_csr_mem_client, dm_csr_tap.server);
   mkConnection(dm_csr_tap.client, proc.hart0_csr_mem_server);

   rule rl_merge_dm_csr_trace_data;
      let tmp <- dm_csr_tap.trace_data_out.get;
      tv_encode.dm_in.put(tmp);
   endrule

`ifdef ISA_F_OR_D
   (* descending_urgency = "rl_merge_dm_fpr_trace_data, rl_merge_dm_gpr_trace_data" *)
`endif
   (* descending_urgency = "rl_merge_dm_gpr_trace_data, rl_merge_dm_csr_trace_data" *)
   (* descending_urgency = "rl_merge_dm_csr_trace_data, rl_merge_dm_mem_trace_data" *)
   rule rl_bogus_for_sched_attributes;
   endrule

   // END SECTION: DM and TV
   // ================================================================
`else    // of ifdef INCLUDE_TANDEM_VERIF
   // ================================================================
   // BEGIN SECTION: DM, no TV

   // Connect DM's GPR interface directly to CPU
   mkConnection (debug_module.harts_gpr_mem_client, proc.harts_gpr_mem_server);

`ifdef ISA_F_OR_D
   // Connect DM's FPR interface directly to CPU
   mkConnection (debug_module.harts_fpr_mem_client, proc.harts_fpr_mem_server);
`endif

   // Connect DM's CSR interface directly to CPU
   mkConnection (debug_module.harts_csr_mem_client, proc.harts_csr_mem_server);

   // DM's bus master is directly the bus master
   let dm_master_local = debug_module.master;

   // END SECTION: DM, no TV
   // ================================================================
`endif    // for ifdef INCLUDE_TANDEM_VERIF
   // ================================================================
`else    // for ifdef INCLUDE_GDB_CONTROL
   // ================================================================
   // BEGIN SECTION: no DM

   // No DM, so 'DM bus master' is AXI4 dummy
   let dm_master_local = culDeSac;

`ifdef INCLUDE_TANDEM_VERIF
   // TV, no DM: stub out the dm input to TV
   Get #(Trace_Data) gs = getstub;
   mkConnection (tv_encode.dm_in, gs);
`endif

`endif    // for ifdef INCLUDE_GDB_CONTROL


   // ================================================================
   // Connect the local 2x3 fabric

   // Masters on the local 2x3 fabric
   Vector#(Num_Masters_2x3, AXI4_Master #(Wd_MId_2x3, Wd_Addr, Wd_Data,
                                          Wd_AW_User, Wd_W_User, Wd_B_User,
                                          Wd_AR_User, Wd_R_User))
                                          master_vector = newVector;
   //let master_vector = newVector;
   master_vector[cpu_uncached_master_num]     = proc_uncached;
   master_vector[debug_module_sba_master_num] = dm_master_local;

   // Slaves on the local 2x3 fabric
   // default slave is forwarded out directly to the Core interface
   Vector#(Num_Slaves_2x3, AXI4_Slave #(Wd_SId_2x3, Wd_Addr, Wd_Data,
                                        Wd_AW_User, Wd_W_User, Wd_B_User,
                                        Wd_AR_User, Wd_R_User))
                                        slave_vector = newVector;
   //let slave_vector = newVector;
   slave_vector[default_slave_num] = uncached_mem_shim.slave;
   slave_vector[llc_slave_num]     = proc.debug_module_mem_server;
   slave_vector[plic_slave_num]    = zeroSlaveUserFields (plic.axi4_slave);

   function Vector#(Num_Slaves_2x3, Bool) route_2x3 (Bit#(Wd_Addr) addr);
      Vector#(Num_Slaves_2x3, Bool) res = replicate(False);
      if (inRange(soc_map.m_mem0_controller_addr_range, addr))
        res[llc_slave_num] = True;
      else if (inRange(soc_map.m_plic_addr_range, addr))
        res[plic_slave_num] = True;
      else
        res[default_slave_num] = True;
      //Bit #(24) topBits = truncateLSB(addr); //XXX TODO Tag controller masks to 40 bits
      //if (topBits != 0) res = replicate(False);
      return res;
   endfunction

   mkAXI4Bus (route_2x3, master_vector, slave_vector);

   // ================================================================
   // Connect external interrupt lines from PLIC to CPU

   rule rl_relay_external_interrupts;    // from PLIC
      Vector #(CoreNum, Bool) meips;
      Vector #(CoreNum, Bool) seips;

      for (Integer i = 0; i < valueof(CoreNum); i = i + 1) begin
	 meips [i] = plic.v_targets [2 * i].m_eip;
	 seips [i] = plic.v_targets [2 * i + 1].m_eip;
      end

      proc.m_external_interrupt_req (meips);
      proc.s_external_interrupt_req (seips);
   endrule

   // ================================================================
   // Connect external debug module interface

   let f_dbg_reqs <- mkFIFO1;
   let f_dbg_rsps <- mkFIFO1;

   rule rl_debug_module_req;
      case (f_dbg_reqs.first) matches
         tagged ReadReq {.rd_addr}: debug_module.dmi.read_addr (rd_addr);
         tagged WriteReq {.wr_addr, .wr_data}:
            debug_module.dmi.write (wr_addr, wr_data);
      endcase
      f_dbg_reqs.deq;
   endrule

   rule rl_debug_module_rsp;
      let x <- debug_module.dmi.read_data;
      f_dbg_rsps.enq (ReadRsp(x));
   endrule

   let fromDbgReset <- mkReset (0, False, clk);
   rule rl_debug_module_send_reset;
      let _ <- debug_module.ndm_reset_client.request.get;
      fromDbgReset.assertReset;
   endrule

   // ================================================================
   // Connect external interrupts to the PLIC and Proc

   Vector #(N_External_Interrupt_Sources, Reg #(Bool)) irq_reg
      <- replicateM (mkReg (False));
   Vector #(N_External_Interrupt_Sources, Put #(Bool)) irq_ifc;
   for (Integer i = 0; i < valueof (N_External_Interrupt_Sources); i = i + 1) begin
      irq_ifc [i] = interface Put;
         method put = writeReg (irq_reg[i]);
      endinterface;
      rule rl_connect_irq;
         plic.v_sources[i].m_interrupt_req (irq_reg[i]);
      endrule
   end

   let nmirq_reg <- mkReg (False);
   let nmirq_ifc = interface Put;
      method put = writeReg (nmirq_reg);
   endinterface;
   rule rl_connect_nmirq;
      // TODO: fixup; passing const False for now
      //proc.non_maskable_interrupt_req (False);
      proc.non_maskable_interrupt_req (nmirq_reg);
   endrule

   // ================================================================
   // Connect other control and status signals

   let f_ctrl_reqs <- mkFIFO1;
   let f_ctrl_rsps <- mkFIFO1;

   function do_release = action
      plic.set_addr_map (zeroExtend (soc_map.m_plic_addr_range.base),
                         zeroExtend (rangeTop(soc_map.m_plic_addr_range)));
      proc.start (True, soc_map_struct.pc_reset_value, 0, 0);
      //proc.set_verbosity (verbosity);
   endaction;

   rule rl_ctrl_req;
      case (f_ctrl_reqs.first) matches
         tagged ReleaseReq: do_release;
         tagged StatusReq: $display ("StatusReq not supported in Toooba");
      endcase
      f_ctrl_reqs.deq;
   endrule

   rule rl_ctrl_rsp;
      f_ctrl_rsps.enq (StatusRsp(?));
   endrule

   // ================================================================
   // INTERFACE

   let ifc = interface WindCoreMidIfc;
      // debug related signals
      // ---------------------
      interface debugModuleServer = toGPServer (f_dbg_reqs, f_dbg_rsps);

      // interrupt related signals
      // -------------------------
      interface irq = irq_ifc;
      interface nmirq = nmirq_ifc;

      // other control and status signals
      // --------------------------------
      interface controlStatusServer = toGPServer (f_ctrl_reqs, f_ctrl_rsps);

      // memory interfaces
      // -----------------
      // Cached master to Fabric master interface
      interface manager_0 = tagController.master;
      // Uncached master to Fabric master interface
      interface manager_1 =
         extendIDFields (zeroMasterUserFields (uncached_mem_shim.master), 0);
      // TODO:
      interface subordinate_0 = culDeSac;
   endinterface;

/*
`ifdef RVFI_DII
   interface Toooba_RVFI_DII_Server rvfi_dii_server = proc.rvfi_dii_server;
`endif

`ifdef INCLUDE_TANDEM_VERIF
   // ----------------------------------------------------------------
   // Optional TV interface

   interface Get tv_verifier_info_get;
      method ActionValue #(Info_CPU_to_Verifier) get();
         match { .n, .v } <- tv_encode.out.get;
         return (Info_CPU_to_Verifier { num_bytes: n, vec_bytes: v });
      endmethod
   endinterface
`endif
*/

   return tuple2 (fromDbgReset.new_rst, ifc);
endmodule: mkCoreResetHelper

// ================================================================
// 2x3 Fabric for this Core
// Masters: CPU DMem, Debug Module System Bus Access, External access

// ----------------
// Fabric port numbers for masters

Master_Num_2x3  cpu_uncached_master_num     = 0;
Master_Num_2x3  debug_module_sba_master_num = 1;

// ----------------
// Fabric port numbers for slaves

Slave_Num_2x3  default_slave_num = 0;    // for I/O, uncached memory, etc.
Slave_Num_2x3  plic_slave_num    = 1;    // PLIC mem-mapped registers
Slave_Num_2x3  llc_slave_num     = 2;    // Normal cached memory (connects to coherent Last-Level Cache)

// ================================================================

endpackage
