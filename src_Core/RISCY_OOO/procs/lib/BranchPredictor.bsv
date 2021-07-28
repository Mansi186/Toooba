package BranchPredictor;

// ================================================================
// Import packages

import ConfigReg :: * ;
import GetPut :: * ;
import Vector :: * ;
import FIFOF :: * ;
import SpecialFIFOs :: * ;
import DReg :: * ;
import Fifos :: * ;
import Ehr  :: *;
import Types::*;

// ================================================================
// Interface definition

interface DecodeIfc;
    method ActionValue#(Bool) putDecodeInst(Bool branch, Addr pc, Bit#(2) instsize ,  Maybe#(Addr) next_pc);
endinterface

interface RenameIfc;
    method Action putRenameInst(InstId instId, Addr pc);
endinterface

interface ExecuteIfc;
    method ActionValue#(Bool) putExecutedInst(InstId instId, Bool taken, Addr next_pc, Bool exception);
endinterface

interface CommitIfc;
    method ActionValue#(Bool) putCommittedInst(InstId instId, Bool committed, Addr next_pc);
endinterface


interface BranchPredictorIfc;

    method ActionValue#(DataIF) getIFData();

    interface Vector#(SupSize, DecodeIfc) decode;

    interface Vector#(SupSize, RenameIfc) rename;

    interface Vector#(SupSize, ExecuteIfc) execute;

    interface Vector#(SupSize, CommitIfc) commit;

endinterface

// ================================================================
// Typedefs

//typedef Bit#(6) Addr;

typedef Bit#(5) InstId;

typedef struct {
    Addr pc;
    Bit#(4) seg_cnt; //segment count
} DataIF deriving(Bits, Eq, FShow);

typedef struct {
    Addr pc;
    Bit#(2) instsize;
    Addr nextpc;
} PcData deriving(Bits, Eq, FShow);

typedef struct {
    Addr pc;
    Addr nextpc;
} PcNextPc deriving(Bits, Eq, FShow);

typedef struct {
    InstId instId;
    Addr nextpc;
} NextPcData deriving(Bits, Eq, FShow);

typedef 2 SupSize;

typedef 32 MemSize;

// ================================================================
// Module 

module mkBranchPredictor(BranchPredictorIfc);
   
    Reg#(DataIF) regDataIF <- mkReg(DataIF {pc : 64'b000000, seg_cnt : 4'b0100});

    Reg#(Maybe#(Addr)) regnpc <- mkDReg(Invalid);

    FIFOF#(Addr) npc_fifo <- mkUGFIFOF;
    FIFOF#(Addr) npc_fifo_rename <- mkUGFIFOF;

    FIFOF#(DataIF) pc_fifo <- mkSizedFIFOF(16);  //sup fifo needed?

    Ehr#(SupSize, DataIF)   pc_reg  <- mkEhr(DataIF {pc : ? , seg_cnt : 0});

    Ehr#(SupSize, Bool)    deq_pcfifo  <- mkEhr(False);
    Ehr#(SupSize, Bool)    npcfifo  <- mkEhr(False);

    Vector#(SupSize, PulseWire) pcdeqwire <- replicateM(mkPulseWire);

    Vector#(SupSize, PulseWire) rename_deq <- replicateM(mkPulseWire);
  
    Vector#(SupSize, PulseWire) d_flush <- replicateM(mkPulseWire);
    Vector#(SupSize, PulseWire) e_flush <- replicateM(mkPulseWire);
    Vector#(SupSize, PulseWire) c_flush <- replicateM(mkPulseWire);

    Vector#(SupSize, RWire#(NextPcData)) data_rename <- replicateM(mkRWire());
    Vector#(SupSize, RWire#(NextPcData)) data_execute <- replicateM(mkRWire());

    Vector#(SupSize, DecodeIfc) decode_ = newVector();
    Vector#(SupSize, RenameIfc) rename_ = newVector();
    Vector#(SupSize, ExecuteIfc) execute_ = newVector();
    Vector#(SupSize, CommitIfc) commit_ = newVector();

    Vector#(SupSize, RWire#(Addr)) d_nextpc <- replicateM(mkRWire);
    Vector#(SupSize, RWire#(Addr)) e_nextpc <- replicateM(mkRWire);
    Vector#(SupSize, RWire#(Addr)) c_nextpc <- replicateM(mkRWire);

    Vector#(MemSize, Reg#(Addr)) e_mem <- replicateM(mkRegU);
    Vector#(MemSize, Reg#(Addr)) c_mem <- replicateM(mkRegU);

    //Vector#(SupSize, Reg#(PcNextPc)) decode_npc <- replicateM(mkRegU);
    SupFifo#(SupSize, 8, PcNextPc) decode_npc <- mkSupFifo;

    Bool cond = False;  //condition to flush
       
    for (Integer i=0; i< valueOf(SupSize); i=i+1) begin
        cond = cond || d_flush[i] || e_flush[i] || c_flush[i];
    end
    
//---------------rules----------------

    rule executemem;
        Bool flush = False;
        for (Integer i=0; i< valueOf(SupSize); i=i+1) begin
            flush = flush || e_flush[i] || c_flush[i];
        end

        if(flush) begin
            Vector#(MemSize, Addr) e_vec = newVector();
            writeVReg(e_mem,e_vec);
        end

        else begin 
            Vector#(MemSize, Addr) e_vec = readVReg(e_mem);
            for(Integer i=0; i<valueOf(SupSize); i=i+1) begin
                if(data_rename[i].wget() matches tagged Valid .d) begin
                    e_vec[d.instId] = d.nextpc;
                end
            end
            writeVReg(e_mem,e_vec);
        end
            
        
        
    endrule
//clear if e_flush or c_flush

    rule commitmem;
        Bool flush = False;
        for (Integer i=0; i< valueOf(SupSize); i=i+1) begin
            flush = flush || c_flush[i];
        end

        if(flush) begin
            Vector#(MemSize, Addr) c_vec = newVector();
            writeVReg(c_mem,c_vec);
            decode_npc.clear;
        end

        else begin 
            Vector#(MemSize, Addr) c_vec = readVReg(c_mem);
            for(Integer i=0; i<valueOf(SupSize); i=i+1) begin
                if(data_execute[i].wget() matches tagged Valid .d) begin
                    c_vec[d.instId] = d.nextpc;
                end
            end
            writeVReg(c_mem,c_vec);
        end
    endrule
//clear if c_flush

    rule npcupdate;
        
        if(cond) begin
            pc_fifo.clear;
            $display("pc cleared");

            Integer i=0;
            while (i< valueOf(SupSize)) begin
                if(d_nextpc[i].wget() matches tagged Valid .npc) begin
                    //regnpc.wset(npc);
                    //regnpc <= Valid (npc);
                    //if(npc_fifo.notFull) 
                    npc_fifo.enq(npc);
                    i = valueOf(SupSize);
                end
                else if(e_nextpc[i].wget() matches tagged Valid .npc) begin
                    npc_fifo.enq(npc);
                    npc_fifo_rename.enq(npc);
                    i = valueOf(SupSize);
                end
                else if(c_nextpc[i].wget() matches tagged Valid .npc) begin
                    npc_fifo.enq(npc);
                    npc_fifo_rename.enq(npc);
                    i = valueOf(SupSize);
                end
                else i = i + 1;
            end
            
        end
        else if(rename_deq[0] || rename_deq[1])
            npc_fifo_rename.clear;

    endrule

    rule pcfifodeq;
        if(pcdeqwire[valueOf(SupSize)-1])  begin//had to send wires to deq
        //if(deq_pcfifo[1])  //valueOf(SupSize)-1  
            pc_fifo.deq;
            $display("deq pcfifo", pc_fifo.first().pc);
        end

    endrule

    //------------interfaces & methods----------------

    for(Integer i=0; i< valueOf(SupSize); i=i+1) begin
        decode_[i] = interface DecodeIfc;
            method ActionValue#(Bool) putDecodeInst(Bool branch, Addr pc, Bit#(2) instsize , Maybe#(Addr) m_next_pc); 
                //if next_pc==valid, flush  //store branchtype, next_pc
                Bool flush = False;
                Bool npcdeq = False;

                Bool did_deq = (i!=0)?deq_pcfifo[i]:False;
                Bool did_npc = (i!=0)?npcfifo[i]:False;

                DataIF next_pc = pc_reg[i];

                //$display("*sc* ",instId , next_pc.seg_cnt);
               
                if(npc_fifo_rename.notEmpty && !did_npc) begin
                    next_pc.pc = npc_fifo_rename.first + 2*extend(instsize); //npc_fifo_rename.first == pc?
                    next_pc.seg_cnt = 4 - 2*extend(instsize); 
                    //$display("*pc* ", npc_fifo_rename.first+ 2* extend(instsize));
                    rename_deq[i].send;
                    did_npc = True;
                end

                else if (next_pc.seg_cnt==0) begin  
                    if(!did_deq) begin
                        next_pc.pc = pc_fifo.first().pc;
                        next_pc.seg_cnt = pc_fifo.first().seg_cnt - extend(instsize);
                        did_deq = True;
                        //$display("if",instId , next_pc.pc);
                    end
                end

                else begin
                    //next_pc.pc = next_pc.pc + 2;
                    //next_pc.seg_cnt = next_pc.seg_cnt - 1;
                    next_pc.pc = next_pc.pc + 2* extend(instsize);        
                    next_pc.seg_cnt = next_pc.seg_cnt - extend(instsize);
                    //$display("else",instId , next_pc.pc);
                end



                if (branch) begin   //read pc first from fifo...if pc==pcfirst  
                    if(m_next_pc matches tagged Valid .npc &&& npc != next_pc.pc) begin 
                        next_pc.pc = npc;
                        next_pc.seg_cnt = 4 - extend(instsize);  //0?  
                        d_nextpc[i].wset(npc);
                        flush = True;
                        d_flush[i].send;
                        did_deq = True;
                    end
                end

                //data_rename[i].wset(NextPcData { instId : instId , nextpc : next_pc.pc});
                $display("decode npc", next_pc.pc);

                //decode_npc[i] <= (PcNextPc { pc : pc , nextpc : next_pc.pc});
                decode_npc.enqS[i].enq(PcNextPc { pc : pc , nextpc : next_pc.pc });
            
                
                deq_pcfifo[i] <= did_deq;
                npcfifo[i] <= did_npc;
                pc_reg[i] <= next_pc;
                //$display("did_deq ]", did_deq);
                if(did_deq)
                    pcdeqwire[i].send;

                return flush;
            endmethod
        endinterface;
    end

    for(Integer i=0; i< valueOf(SupSize); i=i+1) begin
        rename_[i] = interface RenameIfc;
            method Action putRenameInst(InstId instId, Addr pc); 
                //if next_pc==valid, flush  //store branchtype, next_pc
  

                data_rename[i].wset(NextPcData { instId : instId , nextpc : decode_npc.deqS[i].first().nextpc});
                $display("id, npc",instId , decode_npc.deqS[i].first().nextpc);
                decode_npc.deqS[i].deq;
                
                //data_rename[i].wset(NextPcData { instId : instId , nextpc : pc + 2});
            endmethod
        endinterface;
    end

    for(Integer i=0; i< valueOf(SupSize); i=i+1) begin
        execute_[i] = interface ExecuteIfc;
            method ActionValue#(Bool) putExecutedInst(InstId instId, Bool taken, Addr m_next_pc, Bool exception);
                //if nextpcpredicted!=nextpc, flush (OoO)
                Bool flush = False;
                Addr next_pc = e_mem[instId];
                
                if (m_next_pc != next_pc) begin
                    $display("id, mnpc, npc", instId, m_next_pc, next_pc);
                    next_pc = m_next_pc;
                    e_nextpc[i].wset(m_next_pc);                  
                    flush = True;
                    e_flush[i].send;
                end
                data_execute[i].wset(NextPcData { instId : instId , nextpc : next_pc});
                return flush;
            endmethod
        endinterface;
    end

    for(Integer i=0; i< valueOf(SupSize); i=i+1) begin
        commit_[i] = interface CommitIfc;
            method ActionValue#(Bool) putCommittedInst(InstId instId, Bool committed, Addr m_next_pc);
                //if nextpcpredicted!=nextpc, flush 
                Bool flush = False;
                let npc = c_mem[instId];
                if (m_next_pc != npc) begin
                    c_nextpc[i].wset(m_next_pc);
                    flush = True;
                    c_flush[i].send;
                end
                return flush;
            endmethod
        endinterface;
    end


    interface decode = decode_;
    interface rename = rename_;
    interface execute = execute_;
    interface commit = commit_;


    method ActionValue#(DataIF) getIFData();
        //perform bpred here, generate nextpc
        
        DataIF temp = regDataIF;

        if(npc_fifo.notEmpty) begin
            temp.pc = npc_fifo.first;  //should not be enqueued as the nextpc, is the current pc
            //$display("*npcfifo*",npc_fifo.first);
            npc_fifo.deq;
        end

        else begin
            temp.pc = regDataIF.pc + 8;
            pc_fifo.enq(temp); 
        end

        //temp.seg_cnt = regDataIF.seg_cnt;
        //pc_fifo.enq(temp); 

        regDataIF <= temp;  
        
        return temp;

    endmethod

endmodule

endpackage


//separate out decode and rename
//decode - Bool branch, Addr pc, Bit#(2) instsize , Maybe#(Addr) m_next_pc
//rename - InstId instId