//
// Generated by Bluespec Compiler, version 2019.05.beta2 (build a88bf40db, 2019-05-24)
//
// On Wed Jun 17 12:43:39 BST 2020
//
//
// Ports:
// Name                         I/O  size props
// RDY_request_put                O     1 reg
// response_get                   O    69 reg
// RDY_response_get               O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// request_put                    I    67
// EN_request_put                 I     1
// EN_response_get                I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkXilinxFpSqrtSim(CLK,
			 RST_N,

			 request_put,
			 EN_request_put,
			 RDY_request_put,

			 EN_response_get,
			 response_get,
			 RDY_response_get);
  input  CLK;
  input  RST_N;

  // action method request_put
  input  [66 : 0] request_put;
  input  EN_request_put;
  output RDY_request_put;

  // actionvalue method response_get
  input  EN_response_get;
  output [68 : 0] response_get;
  output RDY_response_get;

  // signals for module outputs
  wire [68 : 0] response_get;
  wire RDY_request_put, RDY_response_get;

  // ports of submodule fpSqrt
  wire [63 : 0] fpSqrt$A, fpSqrt$RES;

  // ports of submodule respQ
  wire [68 : 0] respQ$D_IN, respQ$D_OUT;
  wire respQ$CLR, respQ$DEQ, respQ$EMPTY_N, respQ$ENQ, respQ$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_request_put,
       CAN_FIRE_response_get,
       WILL_FIRE_request_put,
       WILL_FIRE_response_get;

  // action method request_put
  assign RDY_request_put = respQ$FULL_N ;
  assign CAN_FIRE_request_put = respQ$FULL_N ;
  assign WILL_FIRE_request_put = EN_request_put ;

  // actionvalue method response_get
  assign response_get = respQ$D_OUT ;
  assign RDY_response_get = respQ$EMPTY_N ;
  assign CAN_FIRE_response_get = respQ$EMPTY_N ;
  assign WILL_FIRE_response_get = EN_response_get ;

  // submodule fpSqrt
  fp_sqrt_sim fpSqrt(.A(fpSqrt$A), .RES(fpSqrt$RES));

  // submodule respQ
  FIFO2 #(.width(32'd69), .guarded(32'd1)) respQ(.RST(RST_N),
						 .CLK(CLK),
						 .D_IN(respQ$D_IN),
						 .ENQ(respQ$ENQ),
						 .DEQ(respQ$DEQ),
						 .CLR(respQ$CLR),
						 .D_OUT(respQ$D_OUT),
						 .FULL_N(respQ$FULL_N),
						 .EMPTY_N(respQ$EMPTY_N));

  // submodule fpSqrt
  assign fpSqrt$A = request_put[66:3] ;

  // submodule respQ
  assign respQ$D_IN = { fpSqrt$RES, 5'd0 } ;
  assign respQ$ENQ = EN_request_put ;
  assign respQ$DEQ = EN_response_get ;
  assign respQ$CLR = 1'b0 ;
endmodule  // mkXilinxFpSqrtSim

