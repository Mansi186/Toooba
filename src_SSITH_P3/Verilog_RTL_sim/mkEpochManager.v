//
// Generated by Bluespec Compiler, version 2019.05.beta2 (build a88bf40db, 2019-05-24)
//
// On Sun Jul  5 21:47:59 BST 2020
//
//
// Ports:
// Name                         I/O  size props
// checkEpoch_0_check             O     1
// RDY_checkEpoch_0_check         O     1 const
// checkEpoch_1_check             O     1
// RDY_checkEpoch_1_check         O     1 const
// RDY_updatePrevEpoch_0_update   O     1 const
// RDY_updatePrevEpoch_1_update   O     1 const
// getEpoch                       O     4 reg
// RDY_getEpoch                   O     1 const
// RDY_incrementEpoch             O     1
// getEpochState                  O     8 reg
// RDY_getEpochState              O     1 const
// isFull_ehrPort0                O     1
// RDY_isFull_ehrPort0            O     1 const
// CLK                            I     1 clock
// RST_N                          I     1 reset
// checkEpoch_0_check_e           I     4
// checkEpoch_1_check_e           I     4
// updatePrevEpoch_0_update_e     I     4
// updatePrevEpoch_1_update_e     I     4
// EN_updatePrevEpoch_0_update    I     1
// EN_updatePrevEpoch_1_update    I     1
// EN_incrementEpoch              I     1
//
// Combinational paths from inputs to outputs:
//   checkEpoch_0_check_e -> checkEpoch_0_check
//   checkEpoch_1_check_e -> checkEpoch_1_check
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

module mkEpochManager(CLK,
		      RST_N,

		      checkEpoch_0_check_e,
		      checkEpoch_0_check,
		      RDY_checkEpoch_0_check,

		      checkEpoch_1_check_e,
		      checkEpoch_1_check,
		      RDY_checkEpoch_1_check,

		      updatePrevEpoch_0_update_e,
		      EN_updatePrevEpoch_0_update,
		      RDY_updatePrevEpoch_0_update,

		      updatePrevEpoch_1_update_e,
		      EN_updatePrevEpoch_1_update,
		      RDY_updatePrevEpoch_1_update,

		      getEpoch,
		      RDY_getEpoch,

		      EN_incrementEpoch,
		      RDY_incrementEpoch,

		      getEpochState,
		      RDY_getEpochState,

		      isFull_ehrPort0,
		      RDY_isFull_ehrPort0);
  input  CLK;
  input  RST_N;

  // value method checkEpoch_0_check
  input  [3 : 0] checkEpoch_0_check_e;
  output checkEpoch_0_check;
  output RDY_checkEpoch_0_check;

  // value method checkEpoch_1_check
  input  [3 : 0] checkEpoch_1_check_e;
  output checkEpoch_1_check;
  output RDY_checkEpoch_1_check;

  // action method updatePrevEpoch_0_update
  input  [3 : 0] updatePrevEpoch_0_update_e;
  input  EN_updatePrevEpoch_0_update;
  output RDY_updatePrevEpoch_0_update;

  // action method updatePrevEpoch_1_update
  input  [3 : 0] updatePrevEpoch_1_update_e;
  input  EN_updatePrevEpoch_1_update;
  output RDY_updatePrevEpoch_1_update;

  // value method getEpoch
  output [3 : 0] getEpoch;
  output RDY_getEpoch;

  // action method incrementEpoch
  input  EN_incrementEpoch;
  output RDY_incrementEpoch;

  // value method getEpochState
  output [7 : 0] getEpochState;
  output RDY_getEpochState;

  // value method isFull_ehrPort0
  output isFull_ehrPort0;
  output RDY_isFull_ehrPort0;

  // signals for module outputs
  wire [7 : 0] getEpochState;
  wire [3 : 0] getEpoch;
  wire RDY_checkEpoch_0_check,
       RDY_checkEpoch_1_check,
       RDY_getEpoch,
       RDY_getEpochState,
       RDY_incrementEpoch,
       RDY_isFull_ehrPort0,
       RDY_updatePrevEpoch_0_update,
       RDY_updatePrevEpoch_1_update,
       checkEpoch_0_check,
       checkEpoch_1_check,
       isFull_ehrPort0;

  // inlined wires
  wire [4 : 0] updatePrevEn_0_lat_0$wget, updatePrevEn_1_lat_0$wget;

  // register curr_epoch
  reg [3 : 0] curr_epoch;
  wire [3 : 0] curr_epoch$D_IN;
  wire curr_epoch$EN;

  // register prev_checked_epoch
  reg [3 : 0] prev_checked_epoch;
  wire [3 : 0] prev_checked_epoch$D_IN;
  wire prev_checked_epoch$EN;

  // register updatePrevEn_0_rl
  reg [4 : 0] updatePrevEn_0_rl;
  wire [4 : 0] updatePrevEn_0_rl$D_IN;
  wire updatePrevEn_0_rl$EN;

  // register updatePrevEn_1_rl
  reg [4 : 0] updatePrevEn_1_rl;
  wire [4 : 0] updatePrevEn_1_rl$D_IN;
  wire updatePrevEn_1_rl$EN;

  // rule scheduling signals
  wire CAN_FIRE_RL_canon_prev_checked_epoch,
       CAN_FIRE_RL_updatePrevEn_0_canon,
       CAN_FIRE_RL_updatePrevEn_1_canon,
       CAN_FIRE_incrementEpoch,
       CAN_FIRE_updatePrevEpoch_0_update,
       CAN_FIRE_updatePrevEpoch_1_update,
       WILL_FIRE_RL_canon_prev_checked_epoch,
       WILL_FIRE_RL_updatePrevEn_0_canon,
       WILL_FIRE_RL_updatePrevEn_1_canon,
       WILL_FIRE_incrementEpoch,
       WILL_FIRE_updatePrevEpoch_0_update,
       WILL_FIRE_updatePrevEpoch_1_update;

  // remaining internal signals
  wire [3 : 0] IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d19,
	       _theResult____h2934,
	       next_epoch__h81;
  wire IF_IF_updatePrevEn_0_lat_0_whas_THEN_updatePre_ETC___d66,
       IF_IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_up_ETC___d45,
       IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d9,
       IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d36,
       IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d46,
       NOT_IF_IF_updatePrevEn_0_lat_0_whas_THEN_updat_ETC___d68,
       NOT_prev_checked_epoch_3_ULE_updatePrevEpoch_0_ETC___d56,
       NOT_updatePrevEpoch_0_update_e_ULE_curr_epoch_1_7___d58,
       NOT_updatePrevEpoch_1_update_e_ULE_curr_epoch_1_9___d70,
       prev_checked_epoch_3_ULE_curr_epoch_1___d54;

  // value method checkEpoch_0_check
  assign checkEpoch_0_check = checkEpoch_0_check_e == curr_epoch ;
  assign RDY_checkEpoch_0_check = 1'd1 ;

  // value method checkEpoch_1_check
  assign checkEpoch_1_check = checkEpoch_1_check_e == curr_epoch ;
  assign RDY_checkEpoch_1_check = 1'd1 ;

  // action method updatePrevEpoch_0_update
  assign RDY_updatePrevEpoch_0_update = 1'd1 ;
  assign CAN_FIRE_updatePrevEpoch_0_update = 1'd1 ;
  assign WILL_FIRE_updatePrevEpoch_0_update = EN_updatePrevEpoch_0_update ;

  // action method updatePrevEpoch_1_update
  assign RDY_updatePrevEpoch_1_update = 1'd1 ;
  assign CAN_FIRE_updatePrevEpoch_1_update = 1'd1 ;
  assign WILL_FIRE_updatePrevEpoch_1_update = EN_updatePrevEpoch_1_update ;

  // value method getEpoch
  assign getEpoch = curr_epoch ;
  assign RDY_getEpoch = 1'd1 ;

  // action method incrementEpoch
  assign RDY_incrementEpoch = prev_checked_epoch != next_epoch__h81 ;
  assign CAN_FIRE_incrementEpoch = prev_checked_epoch != next_epoch__h81 ;
  assign WILL_FIRE_incrementEpoch = EN_incrementEpoch ;

  // value method getEpochState
  assign getEpochState = { curr_epoch, prev_checked_epoch } ;
  assign RDY_getEpochState = 1'd1 ;

  // value method isFull_ehrPort0
  assign isFull_ehrPort0 = next_epoch__h81 == prev_checked_epoch ;
  assign RDY_isFull_ehrPort0 = 1'd1 ;

  // rule RL_canon_prev_checked_epoch
  assign CAN_FIRE_RL_canon_prev_checked_epoch = 1'd1 ;
  assign WILL_FIRE_RL_canon_prev_checked_epoch = 1'd1 ;

  // rule RL_updatePrevEn_0_canon
  assign CAN_FIRE_RL_updatePrevEn_0_canon = 1'd1 ;
  assign WILL_FIRE_RL_updatePrevEn_0_canon = 1'd1 ;

  // rule RL_updatePrevEn_1_canon
  assign CAN_FIRE_RL_updatePrevEn_1_canon = 1'd1 ;
  assign WILL_FIRE_RL_updatePrevEn_1_canon = 1'd1 ;

  // inlined wires
  assign updatePrevEn_0_lat_0$wget = { 1'd1, updatePrevEpoch_0_update_e } ;
  assign updatePrevEn_1_lat_0$wget = { 1'd1, updatePrevEpoch_1_update_e } ;

  // register curr_epoch
  assign curr_epoch$D_IN = next_epoch__h81 ;
  assign curr_epoch$EN = EN_incrementEpoch ;

  // register prev_checked_epoch
  assign prev_checked_epoch$D_IN =
	     IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d36 ?
	       IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d19 :
	       (EN_updatePrevEpoch_1_update ?
		  updatePrevEn_1_lat_0$wget[3:0] :
		  updatePrevEn_1_rl[3:0]) ;
  assign prev_checked_epoch$EN =
	     IF_IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_up_ETC___d45 ;

  // register updatePrevEn_0_rl
  assign updatePrevEn_0_rl$D_IN = 5'b01010 ;
  assign updatePrevEn_0_rl$EN = 1'd1 ;

  // register updatePrevEn_1_rl
  assign updatePrevEn_1_rl$D_IN = 5'b01010 ;
  assign updatePrevEn_1_rl$EN = 1'd1 ;

  // remaining internal signals
  assign IF_IF_updatePrevEn_0_lat_0_whas_THEN_updatePre_ETC___d66 =
	     _theResult____h2934 <= curr_epoch ;
  assign IF_IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_up_ETC___d45 =
	     IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d36 ?
	       IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d9 :
	       (EN_updatePrevEpoch_1_update ?
		  updatePrevEn_1_lat_0$wget[4] :
		  updatePrevEn_1_rl[4]) ;
  assign IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d19 =
	     EN_updatePrevEpoch_0_update ?
	       updatePrevEn_0_lat_0$wget[3:0] :
	       updatePrevEn_0_rl[3:0] ;
  assign IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d9 =
	     EN_updatePrevEpoch_0_update ?
	       updatePrevEn_0_lat_0$wget[4] :
	       updatePrevEn_0_rl[4] ;
  assign IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d36 =
	     EN_updatePrevEpoch_1_update ?
	       !updatePrevEn_1_lat_0$wget[4] :
	       !updatePrevEn_1_rl[4] ;
  assign IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d46 =
	     IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d36 &&
	     (EN_updatePrevEpoch_0_update ?
		!updatePrevEn_0_lat_0$wget[4] :
		!updatePrevEn_0_rl[4]) ;
  assign NOT_IF_IF_updatePrevEn_0_lat_0_whas_THEN_updat_ETC___d68 =
	     _theResult____h2934 > updatePrevEpoch_1_update_e ;
  assign NOT_prev_checked_epoch_3_ULE_updatePrevEpoch_0_ETC___d56 =
	     prev_checked_epoch > updatePrevEpoch_0_update_e ;
  assign NOT_updatePrevEpoch_0_update_e_ULE_curr_epoch_1_7___d58 =
	     updatePrevEpoch_0_update_e > curr_epoch ;
  assign NOT_updatePrevEpoch_1_update_e_ULE_curr_epoch_1_9___d70 =
	     updatePrevEpoch_1_update_e > curr_epoch ;
  assign _theResult____h2934 =
	     IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d9 ?
	       IF_updatePrevEn_0_lat_0_whas_THEN_updatePrevEn_ETC___d19 :
	       prev_checked_epoch ;
  assign next_epoch__h81 = (curr_epoch == 4'd11) ? 4'd0 : curr_epoch + 4'd1 ;
  assign prev_checked_epoch_3_ULE_curr_epoch_1___d54 =
	     prev_checked_epoch <= curr_epoch ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        curr_epoch <= `BSV_ASSIGNMENT_DELAY 4'd0;
	prev_checked_epoch <= `BSV_ASSIGNMENT_DELAY 4'd0;
	updatePrevEn_0_rl <= `BSV_ASSIGNMENT_DELAY 5'd10;
	updatePrevEn_1_rl <= `BSV_ASSIGNMENT_DELAY 5'd10;
      end
    else
      begin
        if (curr_epoch$EN)
	  curr_epoch <= `BSV_ASSIGNMENT_DELAY curr_epoch$D_IN;
	if (prev_checked_epoch$EN)
	  prev_checked_epoch <= `BSV_ASSIGNMENT_DELAY prev_checked_epoch$D_IN;
	if (updatePrevEn_0_rl$EN)
	  updatePrevEn_0_rl <= `BSV_ASSIGNMENT_DELAY updatePrevEn_0_rl$D_IN;
	if (updatePrevEn_1_rl$EN)
	  updatePrevEn_1_rl <= `BSV_ASSIGNMENT_DELAY updatePrevEn_1_rl$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    curr_epoch = 4'hA;
    prev_checked_epoch = 4'hA;
    updatePrevEn_0_rl = 5'h0A;
    updatePrevEn_1_rl = 5'h0A;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_updatePrevEpoch_0_update &&
	  prev_checked_epoch_3_ULE_curr_epoch_1___d54 &&
	  (NOT_prev_checked_epoch_3_ULE_updatePrevEpoch_0_ETC___d56 ||
	   NOT_updatePrevEpoch_0_update_e_ULE_curr_epoch_1_7___d58))
	$fdisplay(32'h80000002, "\n%m: ASSERT FAIL!!");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_updatePrevEpoch_0_update &&
	  !prev_checked_epoch_3_ULE_curr_epoch_1___d54 &&
	  NOT_prev_checked_epoch_3_ULE_updatePrevEpoch_0_ETC___d56 &&
	  NOT_updatePrevEpoch_0_update_e_ULE_curr_epoch_1_7___d58)
	$fdisplay(32'h80000002, "\n%m: ASSERT FAIL!!");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_updatePrevEpoch_1_update &&
	  IF_IF_updatePrevEn_0_lat_0_whas_THEN_updatePre_ETC___d66 &&
	  (NOT_IF_IF_updatePrevEn_0_lat_0_whas_THEN_updat_ETC___d68 ||
	   NOT_updatePrevEpoch_1_update_e_ULE_curr_epoch_1_9___d70))
	$fdisplay(32'h80000002, "\n%m: ASSERT FAIL!!");
    if (RST_N != `BSV_RESET_VALUE)
      if (EN_updatePrevEpoch_1_update &&
	  !IF_IF_updatePrevEn_0_lat_0_whas_THEN_updatePre_ETC___d66 &&
	  NOT_IF_IF_updatePrevEn_0_lat_0_whas_THEN_updat_ETC___d68 &&
	  NOT_updatePrevEpoch_1_update_e_ULE_curr_epoch_1_9___d70)
	$fdisplay(32'h80000002, "\n%m: ASSERT FAIL!!");
    if (RST_N != `BSV_RESET_VALUE)
      if (IF_IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_up_ETC___d45 &&
	  IF_updatePrevEn_1_lat_0_whas__6_THEN_NOT_updat_ETC___d46)
	$fdisplay(32'h80000002, "\n%m: ASSERT FAIL!!");
  end
  // synopsys translate_on
endmodule  // mkEpochManager

