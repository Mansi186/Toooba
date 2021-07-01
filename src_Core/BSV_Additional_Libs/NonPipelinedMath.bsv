////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020 Bluespec, Inc. All rights reserved.
// With modifications by Colin Rothwell, University of Cambridge
//
// SPDX-License-Identifier: BSD-3-Clause
//
////////////////////////////////////////////////////////////////////////////////
//  Filename      : NonPipelinedMath.bsv
//  Description   : Non-pipelined versions of modules in the Math library,
//                  which can also be used with the FloatingPoint library.
////////////////////////////////////////////////////////////////////////////////

package NonPipelinedMath;

import ClientServer ::*;
import FIFO ::*;
import FIFOF ::*;
import GetPut ::*;
import StmtFSM ::*;
import Vector ::*;

export mkNonPipelinedDivider;
export mkNonPipelinedSignedDivider;
export mkNonPipelinedSquareRooter;

typedef struct {
   Int#(TAdd#(1,n)) d;
   Int#(TAdd#(1,TAdd#(n,n))) r;
   Int#(TAdd#(1,n)) q;
} DivState#(numeric type n) deriving(Bits, Eq, FShow);

// non-restoring divider
// n+3 cycle latency
module mkNonPipelinedDivider
        #(Integer s)
        (Server#(Tuple2#(UInt#(m),UInt#(n)),
                 Tuple2#(UInt#(n),UInt#(n))))
   provisos(
      Add#(n, n, m),
      Alias#(UInt#(TAdd#(TLog#(n),1)), countT)
      );

   Reg#(DivState#(n)) fReg <- mkRegU;
   Reg#(Bool) rg_busy <- mkReg(False);
   Reg#(countT) rg_count <- mkReg(0);

   function zeroExtendLSB(d) =
      unpack(reverseBits(extend(reverseBits(pack(d)))));

   function Bool done(countT cmp) = (cmp >= fromInteger(valueOf(n)));

   rule work (rg_busy && !done(rg_count));
      DivState#(n) f = fReg;
      Int#(TAdd#(1,m)) bigd = zeroExtendLSB(f.d);
      countT count = rg_count;
      for (Integer j = 0; j < s; j = j + 1) begin
        if (!done(count)) begin
           if (f.r >= 0) begin
               f.q = (f.q << 1) | 1;
               f.r = (f.r << 1) - bigd;
            end
            else begin
               f.q = (f.q << 1);
               f.r = (f.r << 1) + bigd;
            end
            count = count + 1;
         end
      end
      fReg <= f;
      rg_count <= count;
   endrule

   interface Put request;
      method Action put(Tuple2#(UInt#(m),UInt#(n)) x) if (!rg_busy);
         match {.num, .den} = x;
         fReg <= DivState{d: unpack({1'b0,pack(den)}),
                          q: 0,
                          r: unpack({1'b0,pack(num)})
                         };
         rg_busy <= True;
      endmethod
   endinterface
   interface Get response;
      method ActionValue#(Tuple2#(UInt#(n),UInt#(n))) get if (rg_busy && done(rg_count));
         DivState#(n) f = fReg;
         f.q = f.q + (-(~f.q));
         if (f.r < 0) begin
             f.q = f.q - 1;
             f.r = f.r + zeroExtendLSB(f.d);
         end
         UInt#(TAdd#(1,n)) qq = unpack(pack(f.q));
         UInt#(TAdd#(1,n)) rr = unpack(truncateLSB(pack(f.r)));
         rg_busy <= False;
         rg_count <= 0;
         return(tuple2(truncate(qq),truncate(rr)));
      endmethod
   endinterface
endmodule

module mkNonPipelinedSignedDivider#(Integer s)(Server#(Tuple2#(Int#(m),Int#(n)),Tuple2#(Int#(n),Int#(n))))
   provisos(Add#(n, n, m));

   Server#(Tuple2#(UInt#(m),UInt#(n)),Tuple2#(UInt#(n),UInt#(n))) div <- mkNonPipelinedDivider(s);
   FIFO#(Tuple2#(Bool,Bool)) fSign <- mkFIFO;

   interface Put request;
      method Action put(Tuple2#(Int#(m),Int#(n)) x);
         match {.a, .b} = x;
         UInt#(m) au = unpack(pack(abs(a)));
         UInt#(n) bu = unpack(pack(abs(b)));
         div.request.put(tuple2(au,bu));

         Bool asign = msb(a) != msb(b);
         Bool bsign = msb(a) == 1;
         fSign.enq(tuple2(asign,bsign));
      endmethod
   endinterface

   interface Get response;
      method ActionValue#(Tuple2#(Int#(n),Int#(n))) get;
         match {.au, .bu} <- div.response.get;
         match {.asign, .bsign} <- toGet(fSign).get;

         Int#(n) a = unpack(pack(au));
         Int#(n) b = unpack(pack(bu));

         a = asign ? -a : a;
         b = bsign ? -b : b;

         return(tuple2(a,b));
      endmethod
   endinterface
endmodule

module mkNonPipelinedSquareRooter#(Integer n)(Server#(UInt#(m),Tuple2#(UInt#(m),Bool)))
   provisos(
      // per request of bsc
      Add#(a__, 2, m),
      Log#(TAdd#(1, m), TLog#(TAdd#(m, 1)))
      );

   FIFO#(UInt#(m)) fRequest <- mkLFIFO;
   FIFO#(Tuple2#(UInt#(m),Bool)) fResponse <- mkLFIFO;

   FIFO#(Tuple4#(Maybe#(Bit#(m)),Bit#(m),Bit#(m),Bit#(m))) fFirst <- mkLFIFO;

   Reg#(Bool) busy <- mkReg(False);
   // This is an overestimate of size: can't divide by n
   Reg#(UInt#(TLog#(TAdd#(TDiv#(m, 2), 1)))) count <- mkReg(?);
   Reg#(Tuple4#(Maybe#(Bit#(m)),Bit#(m),Bit#(m),Bit#(m))) workspace <- mkReg(?);

   rule start (!busy);
      let op <- toGet(fRequest).get;
      let s = pack(op);
      Bit#(m) r = 0;
      Bit#(m) b = reverseBits(extend(2'b10));

      let s0 = countZerosMSB(s);
      let b0 = countZerosMSB(b);
      if (s0 > 0) begin
         let shift = (s0 - b0);
         if ((shift & 1) == 1)
            shift = shift + 1;
         b = b >> shift;
      end

      workspace <= tuple4(tagged Invalid,s,r,b);
      busy <= True;
      count <= 0;
   endrule

   let running = (count < fromInteger((valueOf(m) / 2) / n + 1));

   rule work (busy && running);
     count <= count + 1;
     Maybe#(Bit#(m)) res = tpl_1(workspace);
     Bit#(m) s = tpl_2(workspace);
     Bit#(m) r = tpl_3(workspace);
     Bit#(m) b = tpl_4(workspace);

     for (Integer j = 0; j < n; j = j + 1) begin
        if ((count + fromInteger(j)) <= (fromInteger(valueOf(m)/2))) begin
           if (res matches tagged Invalid) begin
              if (b == 0) begin
                 res = tagged Valid r;
              end
              else begin
                 let sum = r + b;

                 if (s >= sum) begin
                    s = s - sum;
                    r = (r >> 1) + b;
                 end
                 else begin
                    r = r >> 1;
                 end

                 b = b >> 2;
              end
           end
        end
     end

     workspace <= tuple4(res,s,r,b);
  endrule

   rule finish (busy && !running);
      match {.res, .s, .r, .b} = workspace;

      fResponse.enq(tuple2(unpack(fromMaybe(0,res)),(s != 0)));
      busy <= False;
   endrule

   interface request = toPut(fRequest);
   interface response = toGet(fResponse);

endmodule

typedef 56 MBits;
typedef 112 NBits;

(*synthesize*)
module mkTb(Empty);
   //FIFOF#(Tuple4#(UInt#(64),UInt#(32),UInt#(32),UInt#(32))) fCheck <- mkLFIFOF;
   Server#(Tuple2#(UInt#(NBits),UInt#(MBits)),Tuple2#(UInt#(MBits),UInt#(MBits))) div <- mkNonPipelinedDivider(5);
   FIFOF#(Tuple4#(UInt#(NBits),UInt#(MBits),UInt#(MBits),UInt#(MBits))) fCheck <- mkSizedFIFOF(4);

   Server#(Tuple2#(Int#(NBits),Int#(MBits)),Tuple2#(Int#(MBits),Int#(MBits))) sdiv <- mkNonPipelinedSignedDivider(5);
   FIFOF#(Tuple4#(Int#(NBits),Int#(MBits),Int#(MBits),Int#(MBits))) fCheck_sdiv <- mkSizedFIFOF(4);

   function Action testDividePipe(Integer n, Integer d);
      action
         UInt#(NBits) ni = fromInteger(n);
         UInt#(MBits) di = fromInteger(d);
         UInt#(MBits) q = fromInteger(quot(n,d));
         UInt#(MBits) p = fromInteger(rem(n,d));
         div.request.put(tuple2(ni,di));
         fCheck.enq(tuple4(ni,di,q,p));
      endaction
   endfunction

   function Action testSignedDividePipe(Integer n, Integer d);
      action
         Int#(NBits) ni = fromInteger(n);
         Int#(MBits) di = fromInteger(d);
         Int#(MBits) q = fromInteger(quot(n,d));
         Int#(MBits) p = fromInteger(rem(n,d));
         sdiv.request.put(tuple2(ni,di));
         fCheck_sdiv.enq(tuple4(ni,di,q,p));
      endaction
   endfunction

   Stmt test =
   seq
      testDividePipe(1,2);
      testDividePipe(100,2);
      testDividePipe(100,3);
      testDividePipe(128,5);
      testDividePipe(219873982173,123812123);
      testDividePipe('hffff_ffff,'hfedc_ba98);
      testDividePipe(213,'hffff_ffff);
      testDividePipe(2022400,1578);

      testSignedDividePipe(128,5);
      testSignedDividePipe(128,-5);
      testSignedDividePipe(-128,5);
      testSignedDividePipe(-128,-5);

      while (fCheck.notEmpty || fCheck_sdiv.notEmpty)
	 noAction;
   endseq;

   rule check;
      match {.n, .d, .q, .p} <- toGet(fCheck).get;
      match {.qq, .pp} <- div.response.get;

      if (q != qq) begin
	 $display("quot(%d,%d) = %d (expected %d)", n, d, qq, q);
      end

      if (p != pp) begin
	 $display("rem(%d,%d) = %d (expected %d)", n, d, pp, p);
      end
   endrule

   rule check_sdiv;
      match {.n, .d, .q, .p} <- toGet(fCheck_sdiv).get;
      match {.qq, .pp} <- sdiv.response.get;

      if (q != qq) begin
	 $display("quot(%d,%d) = %d (expected %d)", n, d, qq, q);
      end

      if (p != pp) begin
	 $display("rem(%d,%d) = %d (expected %d)", n, d, pp, p);
      end
   endrule

   mkAutoFSM(test);

endmodule

endpackage
