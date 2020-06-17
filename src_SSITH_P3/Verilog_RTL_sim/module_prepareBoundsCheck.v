//
// Generated by Bluespec Compiler, version 2019.05.beta2 (build a88bf40db, 2019-05-24)
//
// On Wed Jun 17 12:21:04 BST 2020
//
//
// Ports:
// Name                         I/O  size props
// prepareBoundsCheck             O   266
// prepareBoundsCheck_a           I   163
// prepareBoundsCheck_b           I   163
// prepareBoundsCheck_pcc         I   163
// prepareBoundsCheck_ddc         I   163
// prepareBoundsCheck_vaddr       I    64
// prepareBoundsCheck_size        I     5
// prepareBoundsCheck_toCheck     I    46
//
// Combinational paths from inputs to outputs:
//   (prepareBoundsCheck_a,
//    prepareBoundsCheck_b,
//    prepareBoundsCheck_pcc,
//    prepareBoundsCheck_ddc,
//    prepareBoundsCheck_vaddr,
//    prepareBoundsCheck_size,
//    prepareBoundsCheck_toCheck) -> prepareBoundsCheck
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

module module_prepareBoundsCheck(prepareBoundsCheck_a,
				 prepareBoundsCheck_b,
				 prepareBoundsCheck_pcc,
				 prepareBoundsCheck_ddc,
				 prepareBoundsCheck_vaddr,
				 prepareBoundsCheck_size,
				 prepareBoundsCheck_toCheck,
				 prepareBoundsCheck);
  // value method prepareBoundsCheck
  input  [162 : 0] prepareBoundsCheck_a;
  input  [162 : 0] prepareBoundsCheck_b;
  input  [162 : 0] prepareBoundsCheck_pcc;
  input  [162 : 0] prepareBoundsCheck_ddc;
  input  [63 : 0] prepareBoundsCheck_vaddr;
  input  [4 : 0] prepareBoundsCheck_size;
  input  [45 : 0] prepareBoundsCheck_toCheck;
  output [265 : 0] prepareBoundsCheck;

  // signals for module outputs
  wire [265 : 0] prepareBoundsCheck;

  // remaining internal signals
  reg [65 : 0] x__h926;
  reg [64 : 0] x__h1808;
  reg [63 : 0] x__h1617;
  reg [15 : 0] x__h693, x__h974;
  reg [13 : 0] IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d75;
  reg [5 : 0] CASE_prepareBoundsCheck_toCheck_BITS_20_TO_19__ETC__q6,
	      IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23;
  reg [1 : 0] x__h1457;
  wire [65 : 0] IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d69,
		addTop__h1821,
		addTop__h868,
		prepareBoundsCheck_a_BITS_161_TO_110_33_AND_45_ETC___d139,
		result__h1498,
		result__h2417,
		ret__h1825,
		ret__h872,
		x__h1818,
		x__h865;
  wire [63 : 0] addBase__h1669, addBase__h346, bot__h1672, x__h176;
  wire [51 : 0] mask__h1822, mask__h869;
  wire [49 : 0] mask__h1670,
		mask__h347,
		prepareBoundsCheck_a_BITS_159_TO_110_PLUS_SEXT_ETC__q2,
		x26_BITS_63_TO_14_PLUS_SEXT_x457_SL_IF_prepare_ETC__q5;
  wire [15 : 0] prepareBoundsCheck_a_BITS_1_TO_0_CONCAT_prepar_ETC__q3,
		prepareBoundsCheck_a_BITS_3_TO_2_CONCAT_prepar_ETC__q4;
  wire [1 : 0] prepareBoundsCheck_a_BITS_1_TO_0__q1;
  wire IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d90,
       prepareBoundsCheck_a_BITS_43_TO_38_6_ULT_51_32_ETC___d152,
       x__h1049,
       x__h1969;

  // value method prepareBoundsCheck
  assign prepareBoundsCheck =
	     { prepareBoundsCheck_toCheck[21],
	       x__h176,
	       x__h865[64:0],
	       CASE_prepareBoundsCheck_toCheck_BITS_20_TO_19__ETC__q6,
	       x__h1617,
	       x__h1808,
	       prepareBoundsCheck_toCheck[12] } ;

  // remaining internal signals
  assign IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d69 =
	     { x__h926[65:14] & mask__h869, 14'd0 } + addTop__h868 ;
  assign IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d90 =
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 <
	     6'd51 &&
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d69[64:63] -
	     { 1'd0, x__h1049 } >
	     2'd1 ;
  assign addBase__h1669 =
	     { {48{prepareBoundsCheck_a_BITS_1_TO_0_CONCAT_prepar_ETC__q3[15]}},
	       prepareBoundsCheck_a_BITS_1_TO_0_CONCAT_prepar_ETC__q3 } <<
	     prepareBoundsCheck_a[43:38] ;
  assign addBase__h346 =
	     { {48{x__h693[15]}}, x__h693 } <<
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 ;
  assign addTop__h1821 =
	     { {50{prepareBoundsCheck_a_BITS_3_TO_2_CONCAT_prepar_ETC__q4[15]}},
	       prepareBoundsCheck_a_BITS_3_TO_2_CONCAT_prepar_ETC__q4 } <<
	     prepareBoundsCheck_a[43:38] ;
  assign addTop__h868 =
	     { {50{x__h974[15]}}, x__h974 } <<
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 ;
  assign bot__h1672 =
	     { prepareBoundsCheck_a[159:110] & mask__h1670, 14'd0 } +
	     addBase__h1669 ;
  assign mask__h1670 = 50'h3FFFFFFFFFFFF << prepareBoundsCheck_a[43:38] ;
  assign mask__h1822 = 52'hFFFFFFFFFFFFF << prepareBoundsCheck_a[43:38] ;
  assign mask__h347 =
	     50'h3FFFFFFFFFFFF <<
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 ;
  assign mask__h869 =
	     52'hFFFFFFFFFFFFF <<
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 ;
  assign prepareBoundsCheck_a_BITS_159_TO_110_PLUS_SEXT_ETC__q2 =
	     prepareBoundsCheck_a[159:110] +
	     ({ {48{prepareBoundsCheck_a_BITS_1_TO_0__q1[1]}},
		prepareBoundsCheck_a_BITS_1_TO_0__q1 } <<
	      prepareBoundsCheck_a[43:38]) ;
  assign prepareBoundsCheck_a_BITS_161_TO_110_33_AND_45_ETC___d139 =
	     { prepareBoundsCheck_a[161:110] & mask__h1822, 14'd0 } +
	     addTop__h1821 ;
  assign prepareBoundsCheck_a_BITS_1_TO_0_CONCAT_prepar_ETC__q3 =
	     { prepareBoundsCheck_a[1:0], prepareBoundsCheck_a[23:10] } ;
  assign prepareBoundsCheck_a_BITS_1_TO_0__q1 = prepareBoundsCheck_a[1:0] ;
  assign prepareBoundsCheck_a_BITS_3_TO_2_CONCAT_prepar_ETC__q4 =
	     { prepareBoundsCheck_a[3:2], prepareBoundsCheck_a[37:24] } ;
  assign prepareBoundsCheck_a_BITS_43_TO_38_6_ULT_51_32_ETC___d152 =
	     prepareBoundsCheck_a[43:38] < 6'd51 &&
	     prepareBoundsCheck_a_BITS_161_TO_110_33_AND_45_ETC___d139[64:63] -
	     { 1'd0, x__h1969 } >
	     2'd1 ;
  assign result__h1498 =
	     { 1'd0,
	       ~IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d69[64],
	       IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d69[63:0] } ;
  assign result__h2417 =
	     { 1'd0,
	       ~prepareBoundsCheck_a_BITS_161_TO_110_33_AND_45_ETC___d139[64],
	       prepareBoundsCheck_a_BITS_161_TO_110_33_AND_45_ETC___d139[63:0] } ;
  assign ret__h1825 =
	     { 1'd0,
	       prepareBoundsCheck_a_BITS_161_TO_110_33_AND_45_ETC___d139[64:0] } ;
  assign ret__h872 =
	     { 1'd0,
	       IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d69[64:0] } ;
  assign x26_BITS_63_TO_14_PLUS_SEXT_x457_SL_IF_prepare_ETC__q5 =
	     x__h926[63:14] +
	     ({ {48{x__h1457[1]}}, x__h1457 } <<
	      IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23) ;
  assign x__h1049 =
	     (IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 ==
	      6'd50) ?
	       IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d75[13] :
	       x26_BITS_63_TO_14_PLUS_SEXT_x457_SL_IF_prepare_ETC__q5[49] ;
  assign x__h176 = { x__h926[63:14] & mask__h347, 14'd0 } + addBase__h346 ;
  assign x__h1818 =
	     prepareBoundsCheck_a_BITS_43_TO_38_6_ULT_51_32_ETC___d152 ?
	       result__h2417 :
	       ret__h1825 ;
  assign x__h1969 =
	     (prepareBoundsCheck_a[43:38] == 6'd50) ?
	       prepareBoundsCheck_a[23] :
	       prepareBoundsCheck_a_BITS_159_TO_110_PLUS_SEXT_ETC__q2[49] ;
  assign x__h865 =
	     IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d90 ?
	       result__h1498 :
	       ret__h872 ;
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_ddc or
	  prepareBoundsCheck_a or
	  prepareBoundsCheck_b or prepareBoundsCheck_pcc)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0: x__h926 = prepareBoundsCheck_a[161:96];
      2'd1: x__h926 = prepareBoundsCheck_b[161:96];
      2'd2: x__h926 = prepareBoundsCheck_pcc[161:96];
      2'd3: x__h926 = prepareBoundsCheck_ddc[161:96];
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_vaddr or
	  prepareBoundsCheck_a or bot__h1672 or prepareBoundsCheck_b)
  begin
    case (prepareBoundsCheck_toCheck[18:16])
      3'd0: x__h1617 = prepareBoundsCheck_a[159:96];
      3'd1: x__h1617 = bot__h1672;
      3'd2: x__h1617 = { 46'd0, prepareBoundsCheck_a[62:45] };
      3'd3: x__h1617 = prepareBoundsCheck_b[159:96];
      default: x__h1617 = prepareBoundsCheck_vaddr;
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_ddc or
	  prepareBoundsCheck_a or
	  prepareBoundsCheck_b or prepareBoundsCheck_pcc)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0:
	  x__h693 =
	      { prepareBoundsCheck_a[1:0], prepareBoundsCheck_a[23:10] };
      2'd1:
	  x__h693 =
	      { prepareBoundsCheck_b[1:0], prepareBoundsCheck_b[23:10] };
      2'd2:
	  x__h693 =
	      { prepareBoundsCheck_pcc[1:0], prepareBoundsCheck_pcc[23:10] };
      2'd3:
	  x__h693 =
	      { prepareBoundsCheck_ddc[1:0], prepareBoundsCheck_ddc[23:10] };
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_ddc or
	  prepareBoundsCheck_a or
	  prepareBoundsCheck_b or prepareBoundsCheck_pcc)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0:
	  x__h974 =
	      { prepareBoundsCheck_a[3:2], prepareBoundsCheck_a[37:24] };
      2'd1:
	  x__h974 =
	      { prepareBoundsCheck_b[3:2], prepareBoundsCheck_b[37:24] };
      2'd2:
	  x__h974 =
	      { prepareBoundsCheck_pcc[3:2], prepareBoundsCheck_pcc[37:24] };
      2'd3:
	  x__h974 =
	      { prepareBoundsCheck_ddc[3:2], prepareBoundsCheck_ddc[37:24] };
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_ddc or
	  prepareBoundsCheck_a or
	  prepareBoundsCheck_b or prepareBoundsCheck_pcc)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0: x__h1457 = prepareBoundsCheck_a[1:0];
      2'd1: x__h1457 = prepareBoundsCheck_b[1:0];
      2'd2: x__h1457 = prepareBoundsCheck_pcc[1:0];
      2'd3: x__h1457 = prepareBoundsCheck_ddc[1:0];
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_ddc or
	  prepareBoundsCheck_a or
	  prepareBoundsCheck_b or prepareBoundsCheck_pcc)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 =
	      prepareBoundsCheck_a[43:38];
      2'd1:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 =
	      prepareBoundsCheck_b[43:38];
      2'd2:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 =
	      prepareBoundsCheck_pcc[43:38];
      2'd3:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d23 =
	      prepareBoundsCheck_ddc[43:38];
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_ddc or
	  prepareBoundsCheck_a or
	  prepareBoundsCheck_b or prepareBoundsCheck_pcc)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d75 =
	      prepareBoundsCheck_a[23:10];
      2'd1:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d75 =
	      prepareBoundsCheck_b[23:10];
      2'd2:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d75 =
	      prepareBoundsCheck_pcc[23:10];
      2'd3:
	  IF_prepareBoundsCheck_toCheck_BITS_20_TO_19_EQ_ETC___d75 =
	      prepareBoundsCheck_ddc[23:10];
    endcase
  end
  always@(prepareBoundsCheck_toCheck or
	  prepareBoundsCheck_vaddr or
	  prepareBoundsCheck_size or
	  prepareBoundsCheck_a or x__h1818 or prepareBoundsCheck_b)
  begin
    case (prepareBoundsCheck_toCheck[15:13])
      3'd0: x__h1808 = { 1'b0, prepareBoundsCheck_a[159:96] + 64'd2 };
      3'd1: x__h1808 = x__h1818[64:0];
      3'd2: x__h1808 = { 47'd0, prepareBoundsCheck_a[62:45] };
      3'd3: x__h1808 = { 1'b0, prepareBoundsCheck_b[159:96] };
      3'd4:
	  x__h1808 =
	      { 1'b0, prepareBoundsCheck_a[159:96] } +
	      { 1'b0, prepareBoundsCheck_b[159:96] };
      default: x__h1808 =
		   { 1'b0, prepareBoundsCheck_vaddr } +
		   { 60'd0, prepareBoundsCheck_size };
    endcase
  end
  always@(prepareBoundsCheck_toCheck)
  begin
    case (prepareBoundsCheck_toCheck[20:19])
      2'd0:
	  CASE_prepareBoundsCheck_toCheck_BITS_20_TO_19__ETC__q6 =
	      prepareBoundsCheck_toCheck[11:6];
      2'd1:
	  CASE_prepareBoundsCheck_toCheck_BITS_20_TO_19__ETC__q6 =
	      prepareBoundsCheck_toCheck[5:0];
      2'd2: CASE_prepareBoundsCheck_toCheck_BITS_20_TO_19__ETC__q6 = 6'd32;
      2'd3: CASE_prepareBoundsCheck_toCheck_BITS_20_TO_19__ETC__q6 = 6'd33;
    endcase
  end
endmodule  // module_prepareBoundsCheck

