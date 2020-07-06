//
// Generated by Bluespec Compiler, version 2019.05.beta2 (build a88bf40db, 2019-05-24)
//
// On Sun Jul  5 22:11:05 BST 2020
//
//
// Ports:
// Name                         I/O  size props
// RDY_enq                        O     1
// RDY_deq                        O     1 reg
// first                          O   823
// RDY_first                      O     1 reg
// RDY_specUpdate_incorrectSpeculation  O     1 const
// RDY_specUpdate_correctSpeculation  O     1 const
// CLK                            I     1 clock
// RST_N                          I     1 reset
// enq_x                          I   823
// specUpdate_incorrectSpeculation_kill_all  I     1
// specUpdate_incorrectSpeculation_kill_tag  I     4
// specUpdate_correctSpeculation_mask  I    12
// EN_enq                         I     1
// EN_deq                         I     1
// EN_specUpdate_incorrectSpeculation  I     1
// EN_specUpdate_correctSpeculation  I     1
//
// Combinational paths from inputs to outputs:
//   (specUpdate_incorrectSpeculation_kill_all,
//    specUpdate_incorrectSpeculation_kill_tag,
//    EN_deq,
//    EN_specUpdate_incorrectSpeculation) -> RDY_enq
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

module mkAluRegToExeFifo(CLK,
			 RST_N,

			 enq_x,
			 EN_enq,
			 RDY_enq,

			 EN_deq,
			 RDY_deq,

			 first,
			 RDY_first,

			 specUpdate_incorrectSpeculation_kill_all,
			 specUpdate_incorrectSpeculation_kill_tag,
			 EN_specUpdate_incorrectSpeculation,
			 RDY_specUpdate_incorrectSpeculation,

			 specUpdate_correctSpeculation_mask,
			 EN_specUpdate_correctSpeculation,
			 RDY_specUpdate_correctSpeculation);
  input  CLK;
  input  RST_N;

  // action method enq
  input  [822 : 0] enq_x;
  input  EN_enq;
  output RDY_enq;

  // action method deq
  input  EN_deq;
  output RDY_deq;

  // value method first
  output [822 : 0] first;
  output RDY_first;

  // action method specUpdate_incorrectSpeculation
  input  specUpdate_incorrectSpeculation_kill_all;
  input  [3 : 0] specUpdate_incorrectSpeculation_kill_tag;
  input  EN_specUpdate_incorrectSpeculation;
  output RDY_specUpdate_incorrectSpeculation;

  // action method specUpdate_correctSpeculation
  input  [11 : 0] specUpdate_correctSpeculation_mask;
  input  EN_specUpdate_correctSpeculation;
  output RDY_specUpdate_correctSpeculation;

  // signals for module outputs
  wire [822 : 0] first;
  wire RDY_deq,
       RDY_enq,
       RDY_first,
       RDY_specUpdate_correctSpeculation,
       RDY_specUpdate_incorrectSpeculation;

  // inlined wires
  wire [11 : 0] m_m_specBits_0_lat_1$wget;
  wire m_m_valid_0_lat_0$whas;

  // register m_m_row_0
  reg [810 : 0] m_m_row_0;
  wire [810 : 0] m_m_row_0$D_IN;
  wire m_m_row_0$EN;

  // register m_m_specBits_0_rl
  reg [11 : 0] m_m_specBits_0_rl;
  wire [11 : 0] m_m_specBits_0_rl$D_IN;
  wire m_m_specBits_0_rl$EN;

  // register m_m_valid_0_rl
  reg m_m_valid_0_rl;
  wire m_m_valid_0_rl$D_IN, m_m_valid_0_rl$EN;

  // rule scheduling signals
  wire CAN_FIRE_RL_m_m_specBits_0_canon,
       CAN_FIRE_RL_m_m_valid_0_canon,
       CAN_FIRE_deq,
       CAN_FIRE_enq,
       CAN_FIRE_specUpdate_correctSpeculation,
       CAN_FIRE_specUpdate_incorrectSpeculation,
       WILL_FIRE_RL_m_m_specBits_0_canon,
       WILL_FIRE_RL_m_m_valid_0_canon,
       WILL_FIRE_deq,
       WILL_FIRE_enq,
       WILL_FIRE_specUpdate_correctSpeculation,
       WILL_FIRE_specUpdate_incorrectSpeculation;

  // inputs to muxes for submodule ports
  wire MUX_m_m_valid_0_lat_0$wset_1__SEL_1;

  // remaining internal signals
  reg [29 : 0] CASE_enq_x_BITS_817_TO_815_0_enq_x_BITS_817_TO_ETC__q4,
	       CASE_m_m_row_0_BITS_805_TO_803_0_m_m_row_0_BIT_ETC__q11;
  reg [11 : 0] CASE_enq_x_BITS_728_TO_717_1_enq_x_BITS_728_TO_ETC__q6,
	       CASE_m_m_row_0_BITS_716_TO_705_1_m_m_row_0_BIT_ETC__q13;
  reg [10 : 0] CASE_enq_x_BITS_787_TO_786_0_enq_x_BITS_787_TO_ETC__q5,
	       CASE_m_m_row_0_BITS_775_TO_774_0_m_m_row_0_BIT_ETC__q12;
  reg [4 : 0] CASE_enq_x_BITS_715_TO_711_0_enq_x_BITS_715_TO_ETC__q7,
	      CASE_m_m_row_0_BITS_703_TO_699_0_m_m_row_0_BIT_ETC__q14;
  reg [3 : 0] CASE_IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq__ETC__q2,
	      CASE_IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_4_ETC__q9,
	      IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71,
	      IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355;
  reg [2 : 0] CASE_IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_ETC__q1,
	      CASE_IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_8_ETC__q8,
	      CASE_enq_x_BITS_791_TO_789_0_enq_x_BITS_791_TO_ETC__q3,
	      CASE_m_m_row_0_BITS_779_TO_777_0_m_m_row_0_BIT_ETC__q10,
	      IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103,
	      IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387;
  wire [11 : 0] sb__h12423, upd__h1154;
  wire [8 : 0] IF_enq_x_BITS_785_TO_782_8_EQ_0_9_OR_NOT_enq_x_ETC___d155,
	       IF_enq_x_BITS_785_TO_782_8_EQ_1_0_OR_NOT_enq_x_ETC___d154,
	       IF_enq_x_BITS_785_TO_782_8_EQ_2_2_OR_NOT_enq_x_ETC___d153,
	       IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_0_33_OR__ETC___d437,
	       IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_1_34_OR__ETC___d436,
	       IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_2_36_OR__ETC___d435;

  // action method enq
  assign RDY_enq = m_m_valid_0_lat_0$whas ? !1'd0 : !m_m_valid_0_rl ;
  assign CAN_FIRE_enq = m_m_valid_0_lat_0$whas ? !1'd0 : !m_m_valid_0_rl ;
  assign WILL_FIRE_enq = EN_enq ;

  // action method deq
  assign RDY_deq = m_m_valid_0_rl ;
  assign CAN_FIRE_deq = m_m_valid_0_rl ;
  assign WILL_FIRE_deq = EN_deq ;

  // value method first
  assign first =
	     { m_m_row_0[810:806],
	       CASE_m_m_row_0_BITS_805_TO_803_0_m_m_row_0_BIT_ETC__q11,
	       CASE_m_m_row_0_BITS_775_TO_774_0_m_m_row_0_BIT_ETC__q12,
	       m_m_row_0[764:717],
	       CASE_m_m_row_0_BITS_716_TO_705_1_m_m_row_0_BIT_ETC__q13,
	       m_m_row_0[704],
	       CASE_m_m_row_0_BITS_703_TO_699_0_m_m_row_0_BIT_ETC__q14,
	       m_m_row_0[698:0],
	       m_m_specBits_0_rl } ;
  assign RDY_first = m_m_valid_0_rl ;

  // action method specUpdate_incorrectSpeculation
  assign RDY_specUpdate_incorrectSpeculation = 1'd1 ;
  assign CAN_FIRE_specUpdate_incorrectSpeculation = 1'd1 ;
  assign WILL_FIRE_specUpdate_incorrectSpeculation =
	     EN_specUpdate_incorrectSpeculation ;

  // action method specUpdate_correctSpeculation
  assign RDY_specUpdate_correctSpeculation = 1'd1 ;
  assign CAN_FIRE_specUpdate_correctSpeculation = 1'd1 ;
  assign WILL_FIRE_specUpdate_correctSpeculation =
	     EN_specUpdate_correctSpeculation ;

  // rule RL_m_m_valid_0_canon
  assign CAN_FIRE_RL_m_m_valid_0_canon = 1'd1 ;
  assign WILL_FIRE_RL_m_m_valid_0_canon = 1'd1 ;

  // rule RL_m_m_specBits_0_canon
  assign CAN_FIRE_RL_m_m_specBits_0_canon = 1'd1 ;
  assign WILL_FIRE_RL_m_m_specBits_0_canon = 1'd1 ;

  // inputs to muxes for submodule ports
  assign MUX_m_m_valid_0_lat_0$wset_1__SEL_1 =
	     EN_specUpdate_incorrectSpeculation &&
	     (specUpdate_incorrectSpeculation_kill_all ||
	      m_m_specBits_0_rl[specUpdate_incorrectSpeculation_kill_tag]) ;

  // inlined wires
  assign m_m_valid_0_lat_0$whas =
	     MUX_m_m_valid_0_lat_0$wset_1__SEL_1 || EN_deq ;
  assign m_m_specBits_0_lat_1$wget =
	     sb__h12423 & specUpdate_correctSpeculation_mask ;

  // register m_m_row_0
  assign m_m_row_0$D_IN =
	     { enq_x[822:818],
	       CASE_enq_x_BITS_817_TO_815_0_enq_x_BITS_817_TO_ETC__q4,
	       CASE_enq_x_BITS_787_TO_786_0_enq_x_BITS_787_TO_ETC__q5,
	       enq_x[776:729],
	       CASE_enq_x_BITS_728_TO_717_1_enq_x_BITS_728_TO_ETC__q6,
	       enq_x[716],
	       CASE_enq_x_BITS_715_TO_711_0_enq_x_BITS_715_TO_ETC__q7,
	       enq_x[710:12] } ;
  assign m_m_row_0$EN = EN_enq ;

  // register m_m_specBits_0_rl
  assign m_m_specBits_0_rl$D_IN =
	     EN_specUpdate_correctSpeculation ? upd__h1154 : sb__h12423 ;
  assign m_m_specBits_0_rl$EN = 1'd1 ;

  // register m_m_valid_0_rl
  assign m_m_valid_0_rl$D_IN =
	     EN_enq || (m_m_valid_0_lat_0$whas ? 1'd0 : m_m_valid_0_rl) ;
  assign m_m_valid_0_rl$EN = 1'd1 ;

  // remaining internal signals
  assign IF_enq_x_BITS_785_TO_782_8_EQ_0_9_OR_NOT_enq_x_ETC___d155 =
	     (enq_x[785:782] == 4'd0 ||
	      enq_x[785:782] != 4'd1 && enq_x[785:782] != 4'd2 &&
	      enq_x[785:782] != 4'd3 &&
	      enq_x[785:782] != 4'd4 &&
	      enq_x[785:782] != 4'd5 &&
	      enq_x[785:782] != 4'd6 &&
	      IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
	      4'd0) ?
	       { 4'd0, enq_x[781:777] } :
	       IF_enq_x_BITS_785_TO_782_8_EQ_1_0_OR_NOT_enq_x_ETC___d154 ;
  assign IF_enq_x_BITS_785_TO_782_8_EQ_1_0_OR_NOT_enq_x_ETC___d154 =
	     (enq_x[785:782] == 4'd1 ||
	      enq_x[785:782] != 4'd2 && enq_x[785:782] != 4'd3 &&
	      enq_x[785:782] != 4'd4 &&
	      enq_x[785:782] != 4'd5 &&
	      enq_x[785:782] != 4'd6 &&
	      IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
	      4'd1) ?
	       { 4'd1, enq_x[781:777] } :
	       IF_enq_x_BITS_785_TO_782_8_EQ_2_2_OR_NOT_enq_x_ETC___d153 ;
  assign IF_enq_x_BITS_785_TO_782_8_EQ_2_2_OR_NOT_enq_x_ETC___d153 =
	     (enq_x[785:782] == 4'd2 ||
	      enq_x[785:782] != 4'd3 && enq_x[785:782] != 4'd4 &&
	      enq_x[785:782] != 4'd5 &&
	      enq_x[785:782] != 4'd6 &&
	      IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
	      4'd2) ?
	       { 4'd2,
		 (enq_x[781:779] == 3'd0 ||
		  enq_x[781:779] != 3'd1 &&
		  IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103 ==
		  3'd0) ?
		   { 3'd0, enq_x[778:777] } :
		   ((enq_x[781:779] == 3'd1 ||
		     IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103 ==
		     3'd1) ?
		      { 3'd1, enq_x[778:777] } :
		      { CASE_IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_ETC__q1,
			2'h2 }) } :
	       ((enq_x[785:782] == 4'd3 ||
		 enq_x[785:782] != 4'd4 && enq_x[785:782] != 4'd5 &&
		 enq_x[785:782] != 4'd6 &&
		 IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
		 4'd3) ?
		  { 4'd3, enq_x[781:777] } :
		  ((enq_x[785:782] == 4'd4 ||
		    enq_x[785:782] != 4'd5 && enq_x[785:782] != 4'd6 &&
		    IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
		    4'd4) ?
		     9'd138 :
		     ((enq_x[785:782] == 4'd5 ||
		       enq_x[785:782] != 4'd6 &&
		       IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
		       4'd5) ?
			9'd170 :
			((enq_x[785:782] == 4'd6 ||
			  IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 ==
			  4'd6) ?
			   { 4'd6, enq_x[781:777] } :
			   { CASE_IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq__ETC__q2,
			     5'h0A })))) ;
  assign IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_0_33_OR__ETC___d437 =
	     (m_m_row_0[773:770] == 4'd0 ||
	      m_m_row_0[773:770] != 4'd1 && m_m_row_0[773:770] != 4'd2 &&
	      m_m_row_0[773:770] != 4'd3 &&
	      m_m_row_0[773:770] != 4'd4 &&
	      m_m_row_0[773:770] != 4'd5 &&
	      m_m_row_0[773:770] != 4'd6 &&
	      IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
	      4'd0) ?
	       { 4'd0, m_m_row_0[769:765] } :
	       IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_1_34_OR__ETC___d436 ;
  assign IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_1_34_OR__ETC___d436 =
	     (m_m_row_0[773:770] == 4'd1 ||
	      m_m_row_0[773:770] != 4'd2 && m_m_row_0[773:770] != 4'd3 &&
	      m_m_row_0[773:770] != 4'd4 &&
	      m_m_row_0[773:770] != 4'd5 &&
	      m_m_row_0[773:770] != 4'd6 &&
	      IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
	      4'd1) ?
	       { 4'd1, m_m_row_0[769:765] } :
	       IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_2_36_OR__ETC___d435 ;
  assign IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_2_36_OR__ETC___d435 =
	     (m_m_row_0[773:770] == 4'd2 ||
	      m_m_row_0[773:770] != 4'd3 && m_m_row_0[773:770] != 4'd4 &&
	      m_m_row_0[773:770] != 4'd5 &&
	      m_m_row_0[773:770] != 4'd6 &&
	      IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
	      4'd2) ?
	       { 4'd2,
		 (m_m_row_0[769:767] == 3'd0 ||
		  m_m_row_0[769:767] != 3'd1 &&
		  IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387 ==
		  3'd0) ?
		   { 3'd0, m_m_row_0[766:765] } :
		   ((m_m_row_0[769:767] == 3'd1 ||
		     IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387 ==
		     3'd1) ?
		      { 3'd1, m_m_row_0[766:765] } :
		      { CASE_IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_8_ETC__q8,
			2'h2 }) } :
	       ((m_m_row_0[773:770] == 4'd3 ||
		 m_m_row_0[773:770] != 4'd4 && m_m_row_0[773:770] != 4'd5 &&
		 m_m_row_0[773:770] != 4'd6 &&
		 IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
		 4'd3) ?
		  { 4'd3, m_m_row_0[769:765] } :
		  ((m_m_row_0[773:770] == 4'd4 ||
		    m_m_row_0[773:770] != 4'd5 &&
		    m_m_row_0[773:770] != 4'd6 &&
		    IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
		    4'd4) ?
		     9'd138 :
		     ((m_m_row_0[773:770] == 4'd5 ||
		       m_m_row_0[773:770] != 4'd6 &&
		       IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
		       4'd5) ?
			9'd170 :
			((m_m_row_0[773:770] == 4'd6 ||
			  IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 ==
			  4'd6) ?
			   { 4'd6, m_m_row_0[769:765] } :
			   { CASE_IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_4_ETC__q9,
			     5'h0A })))) ;
  assign sb__h12423 = EN_enq ? enq_x[11:0] : m_m_specBits_0_rl ;
  assign upd__h1154 = m_m_specBits_0_lat_1$wget ;
  always@(enq_x)
  begin
    case (enq_x[785:782])
      4'd7, 4'd8, 4'd9, 4'd10, 4'd11:
	  IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 =
	      enq_x[785:782];
      default: IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71 =
		   4'd12;
    endcase
  end
  always@(enq_x)
  begin
    case (enq_x[781:779])
      3'd2, 3'd3:
	  IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103 =
	      enq_x[781:779];
      default: IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103 =
		   3'd4;
    endcase
  end
  always@(m_m_row_0)
  begin
    case (m_m_row_0[773:770])
      4'd7, 4'd8, 4'd9, 4'd10, 4'd11:
	  IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 =
	      m_m_row_0[773:770];
      default: IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355 =
		   4'd12;
    endcase
  end
  always@(m_m_row_0)
  begin
    case (m_m_row_0[769:767])
      3'd2, 3'd3:
	  IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387 =
	      m_m_row_0[769:767];
      default: IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387 =
		   3'd4;
    endcase
  end
  always@(IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103)
  begin
    case (IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103)
      3'd2, 3'd3:
	  CASE_IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_ETC__q1 =
	      IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_x_BI_ETC___d103;
      default: CASE_IF_enq_x_BITS_781_TO_779_6_EQ_2_00_OR_enq_ETC__q1 = 3'd4;
    endcase
  end
  always@(IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71)
  begin
    case (IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71)
      4'd7, 4'd8, 4'd9, 4'd10, 4'd11:
	  CASE_IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq__ETC__q2 =
	      IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq_x_BIT_ETC___d71;
      default: CASE_IF_enq_x_BITS_785_TO_782_8_EQ_7_2_OR_enq__ETC__q2 = 4'd12;
    endcase
  end
  always@(enq_x)
  begin
    case (enq_x[791:789])
      3'd0, 3'd1, 3'd2, 3'd3, 3'd4:
	  CASE_enq_x_BITS_791_TO_789_0_enq_x_BITS_791_TO_ETC__q3 =
	      enq_x[791:789];
      default: CASE_enq_x_BITS_791_TO_789_0_enq_x_BITS_791_TO_ETC__q3 = 3'd7;
    endcase
  end
  always@(enq_x or CASE_enq_x_BITS_791_TO_789_0_enq_x_BITS_791_TO_ETC__q3)
  begin
    case (enq_x[817:815])
      3'd0, 3'd1, 3'd2, 3'd3:
	  CASE_enq_x_BITS_817_TO_815_0_enq_x_BITS_817_TO_ETC__q4 =
	      enq_x[817:788];
      3'd4:
	  CASE_enq_x_BITS_817_TO_815_0_enq_x_BITS_817_TO_ETC__q4 =
	      { enq_x[817:815],
		18'h2AAAA,
		enq_x[796:792],
		CASE_enq_x_BITS_791_TO_789_0_enq_x_BITS_791_TO_ETC__q3,
		enq_x[788] };
      default: CASE_enq_x_BITS_817_TO_815_0_enq_x_BITS_817_TO_ETC__q4 =
		   30'd715827882;
    endcase
  end
  always@(enq_x or IF_enq_x_BITS_785_TO_782_8_EQ_0_9_OR_NOT_enq_x_ETC___d155)
  begin
    case (enq_x[787:786])
      2'd0:
	  CASE_enq_x_BITS_787_TO_786_0_enq_x_BITS_787_TO_ETC__q5 =
	      enq_x[787:777];
      2'd1:
	  CASE_enq_x_BITS_787_TO_786_0_enq_x_BITS_787_TO_ETC__q5 =
	      { enq_x[787:786],
		IF_enq_x_BITS_785_TO_782_8_EQ_0_9_OR_NOT_enq_x_ETC___d155 };
      default: CASE_enq_x_BITS_787_TO_786_0_enq_x_BITS_787_TO_ETC__q5 =
		   11'd1194;
    endcase
  end
  always@(enq_x)
  begin
    case (enq_x[728:717])
      12'd1,
      12'd2,
      12'd3,
      12'd256,
      12'd260,
      12'd261,
      12'd262,
      12'd320,
      12'd321,
      12'd322,
      12'd323,
      12'd324,
      12'd384,
      12'd768,
      12'd769,
      12'd770,
      12'd771,
      12'd772,
      12'd773,
      12'd774,
      12'd832,
      12'd833,
      12'd834,
      12'd835,
      12'd836,
      12'd1952,
      12'd1953,
      12'd1954,
      12'd1955,
      12'd1968,
      12'd1969,
      12'd1970,
      12'd1971,
      12'd2048,
      12'd2049,
      12'd2496,
      12'd2816,
      12'd2818,
      12'd3008,
      12'd3072,
      12'd3073,
      12'd3074,
      12'd3857,
      12'd3858,
      12'd3859,
      12'd3860:
	  CASE_enq_x_BITS_728_TO_717_1_enq_x_BITS_728_TO_ETC__q6 =
	      enq_x[728:717];
      default: CASE_enq_x_BITS_728_TO_717_1_enq_x_BITS_728_TO_ETC__q6 =
		   12'd2303;
    endcase
  end
  always@(enq_x)
  begin
    case (enq_x[715:711])
      5'd0, 5'd1, 5'd12, 5'd13, 5'd14, 5'd15, 5'd28, 5'd29, 5'd30, 5'd31:
	  CASE_enq_x_BITS_715_TO_711_0_enq_x_BITS_715_TO_ETC__q7 =
	      enq_x[715:711];
      default: CASE_enq_x_BITS_715_TO_711_0_enq_x_BITS_715_TO_ETC__q7 = 5'd10;
    endcase
  end
  always@(IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387)
  begin
    case (IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387)
      3'd2, 3'd3:
	  CASE_IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_8_ETC__q8 =
	      IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_84_OR__ETC___d387;
      default: CASE_IF_m_m_row_0_99_BITS_769_TO_767_80_EQ_2_8_ETC__q8 = 3'd4;
    endcase
  end
  always@(IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355)
  begin
    case (IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355)
      4'd7, 4'd8, 4'd9, 4'd10, 4'd11:
	  CASE_IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_4_ETC__q9 =
	      IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_46_OR__ETC___d355;
      default: CASE_IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_7_4_ETC__q9 = 4'd12;
    endcase
  end
  always@(m_m_row_0)
  begin
    case (m_m_row_0[779:777])
      3'd0, 3'd1, 3'd2, 3'd3, 3'd4:
	  CASE_m_m_row_0_BITS_779_TO_777_0_m_m_row_0_BIT_ETC__q10 =
	      m_m_row_0[779:777];
      default: CASE_m_m_row_0_BITS_779_TO_777_0_m_m_row_0_BIT_ETC__q10 = 3'd7;
    endcase
  end
  always@(m_m_row_0 or
	  CASE_m_m_row_0_BITS_779_TO_777_0_m_m_row_0_BIT_ETC__q10)
  begin
    case (m_m_row_0[805:803])
      3'd0, 3'd1, 3'd2, 3'd3:
	  CASE_m_m_row_0_BITS_805_TO_803_0_m_m_row_0_BIT_ETC__q11 =
	      m_m_row_0[805:776];
      3'd4:
	  CASE_m_m_row_0_BITS_805_TO_803_0_m_m_row_0_BIT_ETC__q11 =
	      { m_m_row_0[805:803],
		18'h2AAAA,
		m_m_row_0[784:780],
		CASE_m_m_row_0_BITS_779_TO_777_0_m_m_row_0_BIT_ETC__q10,
		m_m_row_0[776] };
      default: CASE_m_m_row_0_BITS_805_TO_803_0_m_m_row_0_BIT_ETC__q11 =
		   30'd715827882;
    endcase
  end
  always@(m_m_row_0 or
	  IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_0_33_OR__ETC___d437)
  begin
    case (m_m_row_0[775:774])
      2'd0:
	  CASE_m_m_row_0_BITS_775_TO_774_0_m_m_row_0_BIT_ETC__q12 =
	      m_m_row_0[775:765];
      2'd1:
	  CASE_m_m_row_0_BITS_775_TO_774_0_m_m_row_0_BIT_ETC__q12 =
	      { m_m_row_0[775:774],
		IF_m_m_row_0_99_BITS_773_TO_770_32_EQ_0_33_OR__ETC___d437 };
      default: CASE_m_m_row_0_BITS_775_TO_774_0_m_m_row_0_BIT_ETC__q12 =
		   11'd1194;
    endcase
  end
  always@(m_m_row_0)
  begin
    case (m_m_row_0[716:705])
      12'd1,
      12'd2,
      12'd3,
      12'd256,
      12'd260,
      12'd261,
      12'd262,
      12'd320,
      12'd321,
      12'd322,
      12'd323,
      12'd324,
      12'd384,
      12'd768,
      12'd769,
      12'd770,
      12'd771,
      12'd772,
      12'd773,
      12'd774,
      12'd832,
      12'd833,
      12'd834,
      12'd835,
      12'd836,
      12'd1952,
      12'd1953,
      12'd1954,
      12'd1955,
      12'd1968,
      12'd1969,
      12'd1970,
      12'd1971,
      12'd2048,
      12'd2049,
      12'd2496,
      12'd2816,
      12'd2818,
      12'd3008,
      12'd3072,
      12'd3073,
      12'd3074,
      12'd3857,
      12'd3858,
      12'd3859,
      12'd3860:
	  CASE_m_m_row_0_BITS_716_TO_705_1_m_m_row_0_BIT_ETC__q13 =
	      m_m_row_0[716:705];
      default: CASE_m_m_row_0_BITS_716_TO_705_1_m_m_row_0_BIT_ETC__q13 =
		   12'd2303;
    endcase
  end
  always@(m_m_row_0)
  begin
    case (m_m_row_0[703:699])
      5'd0, 5'd1, 5'd12, 5'd13, 5'd14, 5'd15, 5'd28, 5'd29, 5'd30, 5'd31:
	  CASE_m_m_row_0_BITS_703_TO_699_0_m_m_row_0_BIT_ETC__q14 =
	      m_m_row_0[703:699];
      default: CASE_m_m_row_0_BITS_703_TO_699_0_m_m_row_0_BIT_ETC__q14 =
		   5'd10;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        m_m_specBits_0_rl <= `BSV_ASSIGNMENT_DELAY 12'hAAA;
	m_m_valid_0_rl <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (m_m_specBits_0_rl$EN)
	  m_m_specBits_0_rl <= `BSV_ASSIGNMENT_DELAY m_m_specBits_0_rl$D_IN;
	if (m_m_valid_0_rl$EN)
	  m_m_valid_0_rl <= `BSV_ASSIGNMENT_DELAY m_m_valid_0_rl$D_IN;
      end
    if (m_m_row_0$EN) m_m_row_0 <= `BSV_ASSIGNMENT_DELAY m_m_row_0$D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    m_m_row_0 =
	811'h2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
    m_m_specBits_0_rl = 12'hAAA;
    m_m_valid_0_rl = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkAluRegToExeFifo

