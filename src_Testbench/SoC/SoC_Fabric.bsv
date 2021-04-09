// Copyright (c) 2013-2019 Bluespec, Inc. All Rights Reserved

package SoC_Fabric;

// ================================================================
// Defines a SoC Fabric that is a specialization of AXI4_Lite_Fabric
// for this particular SoC.

// ================================================================
// Project imports

import AXI4_Types  :: *;
import AXI4_Fabric :: *;

import Fabric_Defs :: *;    // for Wd_Addr, Wd_Data, Wd_User
import SoC_Map     :: *;    // for Num_Managers, Num_Subordinates

// ================================================================
// Subordinate address decoder
// Identifies whether a given addr is legal and, if so, which  subordinate services it.

typedef Bit #(TLog #(Num_Subordinates))  Subordinate_Num;

// ================================================================
// Specialization of parameterized AXI4 fabric for this SoC.

typedef AXI4_Fabric_IFC #(Num_Managers,
			  Num_Subordinates,
			  Wd_Id,
			  Wd_Addr,
			  Wd_Data,
			  Wd_User)  Fabric_IFC;

// ----------------

(* synthesize *)
module mkFabric (Fabric_IFC);

   SoC_Map_IFC soc_map <- mkSoC_Map;

   function Tuple2 #(Bool, Subordinate_Num) fn_addr_to_subordinate_num  (Fabric_Addr addr);

      // Main Mem
      if (   (soc_map.m_mem0_controller_addr_base <= addr)
	  && (addr < soc_map.m_mem0_controller_addr_lim))
	 return tuple2 (True, fromInteger (mem0_controller_subordinate_num));

      // Boot ROM
      else if (   (soc_map.m_boot_rom_addr_base <= addr)
	  && (addr < soc_map.m_boot_rom_addr_lim))
	 return tuple2 (True, fromInteger (boot_rom_subordinate_num));

`ifdef Near_Mem_TCM
      // TCM
      else if (   (soc_map.m_tcm_addr_base <= addr)
	       && (addr < soc_map.m_tcm_addr_lim))
	 return tuple2 (True, fromInteger (tcm_back_door_subordinate_num));
`endif

      // UART
      else if (   (soc_map.m_uart0_addr_base <= addr)
	       && (addr < soc_map.m_uart0_addr_lim))
	 return tuple2 (True, fromInteger (uart0_subordinate_num));

`ifdef HTIF_MEMORY
      else if (   (soc_map.m_htif_addr_base <= addr)
	       && (addr < soc_map.m_htif_addr_lim))
	 return tuple2 (True, fromInteger (htif_subordinate_num));
`endif

`ifdef INCLUDE_ACCEL0
      // Accelerator 0
      else if (   (soc_map.m_accel0_addr_base <= addr)
	       && (addr < soc_map.m_accel0_addr_lim))
	 return tuple2 (True, fromInteger (accel0_subordinate_num));
`endif

      else
	 return tuple2 (False, ?);
   endfunction

   AXI4_Fabric_IFC #(Num_Managers, Num_Subordinates, Wd_Id, Wd_Addr, Wd_Data, Wd_User)
       fabric <- mkAXI4_Fabric (fn_addr_to_subordinate_num);

   return fabric;
endmodule

// ================================================================
// Specialization of parameterized AXI4 fabric for this SoC.

typedef AXI4_Fabric_IFC #(Num_Managers,
			  Num_Subordinates,
			  Wd_Id,
			  Wd_Addr,
			  Wd_Data,
			  Wd_User)  Fabric_AXI4_IFC;

// ----------------

(* synthesize *)
module mkFabric_AXI4 (Fabric_AXI4_IFC);

   SoC_Map_IFC soc_map <- mkSoC_Map;

   function Tuple2 #(Bool, Subordinate_Num) fn_addr_to_subordinate_num  (Fabric_Addr addr);

      // Main Mem
      if (   (soc_map.m_mem0_controller_addr_base <= addr)
	  && (addr < soc_map.m_mem0_controller_addr_lim))
	 return tuple2 (True, fromInteger (mem0_controller_subordinate_num));

      // Boot ROM
      else if (   (soc_map.m_boot_rom_addr_base <= addr)
	  && (addr < soc_map.m_boot_rom_addr_lim))
	 return tuple2 (True, fromInteger (boot_rom_subordinate_num));

`ifdef Near_Mem_TCM
      // TCM
      else if (   (soc_map.m_tcm_addr_base <= addr)
	       && (addr < soc_map.m_tcm_addr_lim))
	 return tuple2 (True, fromInteger (tcm_back_door_subordinate_num));
`endif

      // UART
      else if (   (soc_map.m_uart0_addr_base <= addr)
	       && (addr < soc_map.m_uart0_addr_lim))
	 return tuple2 (True, fromInteger (uart0_subordinate_num));

`ifdef HTIF_MEMORY
      else if (   (soc_map.m_htif_addr_base <= addr)
	       && (addr < soc_map.m_htif_addr_lim))
	 return tuple2 (True, fromInteger (htif_subordinate_num));
`endif

`ifdef INCLUDE_ACCEL0
      // Accelerator 0
      else if (   (soc_map.m_accel0_addr_base <= addr)
	       && (addr < soc_map.m_accel0_addr_lim))
	 return tuple2 (True, fromInteger (accel0_subordinate_num));
`endif

      else
	 return tuple2 (False, ?);
   endfunction

   AXI4_Fabric_IFC #(Num_Managers, Num_Subordinates, Wd_Id, Wd_Addr, Wd_Data, Wd_User)
       fabric <- mkAXI4_Fabric (fn_addr_to_subordinate_num);

   return fabric;
endmodule

// ================================================================

endpackage
