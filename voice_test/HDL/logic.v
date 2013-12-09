`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:52 12/08/2013 
// Design Name: 
// Module Name:    logic 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module logic(
    input clock,//system clock
    input reset,//syetm reset
	 input talk,//push to record button
	 output reg feature_start,//start trigger to record/feature vector extractor
	 input feature_done,//done signal from feature vector
    input training_enable,//training_enable switch
    input [3:0] training_select,//training select choices
    input [25:0] DTW_score1,//scores for the 9 DTWS
	 input [25:0] DTW_score2,
	 input [25:0] DTW_score3,
	 input [25:0] DTW_score4,
	 input [25:0] DTW_score5,
	 input [25:0] DTW_score6,
	 input [25:0] DTW_score7,
	 input [25:0] DTW_score8,
	 input [25:0] DTW_score9,
    input DTW_done1, //done and start for the 9 DTWs
	 output reg DTW_start1,
	 input DTW_done2,
	 output reg DTW_start2,
	 input DTW_done3,
	 output reg DTW_start3,
	 input DTW_done4,
	 output reg DTW_start4,
	 input DTW_done5,
	 output reg DTW_start5,
	 input DTW_done6,
	 output reg DTW_start6,
	 input DTW_done7,
	 output reg DTW_start7,
	 input DTW_done8,
	 output reg DTW_start8,
	 input DTW_done9,
	 output reg DTW_start9, 
    output reg DTW_train1,//NONE  //Training signals for the 9 DTWs
	 output reg DTW_train2,//RED
	 output reg DTW_train3,//BLUE
	 output reg DTW_train4,//BLACK
	 output reg DTW_train5,//LEFT
	 output reg DTW_train6,//RIGHT
	 output reg DTW_train7,//GO
	 output reg DTW_train8,//STOP
	 output reg DTW_train9,//NOISE no clear word?
    output reg [3:0] command, //output command
	 output reg done //done output
    );

	//STATES
	parameter WAIT = 2'b00;
	parameter RECORD = 2'b01;
	parameter DTW = 2'b10;
	parameter COMPARE = 2'b11;
	
	
	reg [1:0] state; //overall state
	reg [1:0] compare_state;//state in COMPARE section
	
	wire all_done;
	reg [2:0] min12, min34, min56, min78,min_next1, min_next2, min; //compare storage registers
	reg [24:0] min12_value, min34_value, min56_value, min78_value, min_nextvalue1, min_nextvalue2, min_value;//compare value registers
	
	
	//is true only once all 9 DTW engines are complete
	assign all_done = (DTW_done1 & DTW_done2 & DTW_done3 
	                  & DTW_done4 & DTW_done5 & DTW_done6 
	                  & DTW_done7 & DTW_done8 & DTW_done9);
	
	
	always @(posedge clock) begin
		if(reset) begin // On reset clear all the train switches and starts
			state <= WAIT;
		   command <= 0;
			feature_start <= 0;
			done <= 0;
		   DTW_train1 <= 0;
			DTW_start1 <= 0;
		   DTW_train2 <= 0;
			DTW_start2 <= 0;
		   DTW_train3 <= 0;
			DTW_start3 <= 0;
		   DTW_train4 <= 0;
			DTW_start4 <= 0;
		   DTW_train5 <= 0;
			DTW_start5 <= 0;
		   DTW_train6 <= 0;
			DTW_start6 <= 0;
		   DTW_train7 <= 0;
			DTW_start7 <= 0;
		   DTW_train8 <= 0;
			DTW_start8 <= 0;
		   DTW_train9 <= 0;
			DTW_start9 <= 0;
		end
		else begin
			case (state)
			WAIT: begin //WAIT till talk button is pressed, then go to RECORD and start feature vector extraction
				DTW_train1 <= 0;
				DTW_train2 <= 0;
				DTW_train3 <= 0;
				DTW_train4 <= 0;
				DTW_train5 <= 0;
				DTW_train6 <= 0;
				DTW_train7 <= 0;
				DTW_train8 <= 0;
				DTW_train9 <= 0;
				if(talk) begin
					state <= RECORD;
					feature_start <= 1;
					done <= 0;
				end
			end
			RECORD: begin 
				//wait till Feature vector is generated , then if training activate only the respective DTW engine
				if(feature_done) begin
					if(training_enable) begin
						case(training_select)
							4'b0000: begin  //NOISE
								DTW_train9 <= 1;
								DTW_start9 <= 1;
								state <= DTW;
								end
							4'b0100: begin //NONE
								DTW_train1 <= 1;
								DTW_start1 <= 1;
								state <= DTW;
							end
							4'b0101: begin //RED
								DTW_train2 <= 1;
								DTW_start2 <= 1;
								state <= DTW;
								end
							4'b0110: begin //BLUE
								DTW_train3 <= 1;
								DTW_start3 <= 1;
								state <= DTW;
								end
							4'b0111: begin //BLACK
								DTW_train4 <= 1;
								DTW_start4 <= 1;
								state <= DTW;
								end
							4'b1000: begin //LEFT
								DTW_train5 <= 1;
								DTW_start5 <= 1;
								state <= DTW;
								end
							4'b1001: begin //RIGHT
								DTW_train6 <= 1;
								DTW_start6 <= 1;
								state <= DTW;
								end
							4'b1010: begin //GO
								DTW_train7 <= 1;
								DTW_start7 <= 1;
								state <= DTW;
								end
							4'b1011: begin //STOP
								DTW_train8 <= 1;
								DTW_start8 <= 1;
								state <= DTW;
								end
							default: begin //DON'T TRAIN
								DTW_train1 <= 0;
								DTW_train2 <= 0;
								DTW_train3 <= 0;
								DTW_train4 <= 0;
								DTW_train5 <= 0;
								DTW_train6 <= 0;
								DTW_train7 <= 0;
								DTW_train8 <= 0;
								DTW_train9 <= 0;
								state <= WAIT;
								end
							endcase
						end
					else begin //if not training all the DTWs are activated
						DTW_start1 <= 1;
						DTW_start2 <= 1;
						DTW_start3 <= 1;
						DTW_start4 <= 1;
						DTW_start5 <= 1;
						DTW_start6 <= 1;
						DTW_start7 <= 1;
						DTW_start8 <= 1;
						DTW_start9 <= 1;
						state <= DTW;
					end
				end
			end
			DTW: begin //Wait till all the DTWs are done
				if(training_enable) begin
					if(all_done) state <= WAIT;
					end
				else if(all_done) begin
					state <= COMPARE;
					compare_state <= 2'd0;
					end
				end
			COMPARE:begin //compare the scores to find the score with the lowest value
				case(compare_state)
				2'd0: begin //compare level 1: quarter finals
					min12 <= (DTW_score1 < DTW_score2)? 0: 1;
					min12_value <= (DTW_score1 < DTW_score2)? DTW_score1: DTW_score2;
					
					min34 <= (DTW_score3 < DTW_score4)? 2: 3;
					min34_value <= (DTW_score3 < DTW_score4)? DTW_score3: DTW_score4;
					
					min56 <= (DTW_score5 < DTW_score6)? 4: 5;
					min56_value <= (DTW_score5 < DTW_score6)? DTW_score5: DTW_score6;
					
					min78 <= (DTW_score7 < DTW_score8)? 6: 7;
					min78_value <= (DTW_score7 < DTW_score8)? DTW_score7: DTW_score8;
					
					compare_state <= 2'd1;
					end
				2'd1: begin//compare level 2: semi finals
					min_next1 <= (min12_value < min34_value)? min12: min34;
					min_nextvalue1 <= (min12_value < min34_value)? min12_value: min34_value;
					
					min_next2 <= (min56_value < min78_value)? min56: min78;
					min_nextvalue2 <= (min56_value < min78_value)? min56_value: min78_value;
					
					compare_state <= 2'd2;
					end
				2'd2:begin//compare level 3: finals
					min <= (min_nextvalue1 < min_nextvalue2)? min_next1: min_next2;
					min_value <= (min_nextvalue1 < min_nextvalue2)? min_nextvalue1: min_nextvalue2;
					
					compare_state <= 2'd3;
					end
				2'd3: begin//compare level 4: compare to Noise and send out command
					if( min_value < DTW_score9) begin
						case(min) //MY LIST OF command values, change if you think neccesary
							4'd0: command <= 4'b0100;//NONE
							4'd1: command <= 4'b0101;//RED
							4'd2: command <= 4'b0110;//BLUE
							4'd3: command <= 4'b0111;//BLACK
							4'd4: command <= 4'b1000;//LEFT
							4'd5: command <= 4'b1001;//RIGHT
							4'd6: command <= 4'b1010;//GO
							4'd7: command <= 4'b1011;//STOP
							default: command <= 4'b0000; //NO COMMAND
						endcase
					end // if
					else command <= 4'b0000;
					done <= 1;
					state <= WAIT;
					compare_state <= 0;
					end
				default: begin
					compare_state <= 0;
					end
				endcase
			end
			default: begin
				state <= WAIT;
				end
			endcase 
			// Each start is only active for 1 clock cycle
			if(DTW_start1) DTW_start1 <= 0;
			if(DTW_start2) DTW_start2 <= 0;
			if(DTW_start3) DTW_start3 <= 0;
			if(DTW_start4) DTW_start4 <= 0;
			if(DTW_start5) DTW_start5 <= 0;
			if(DTW_start6) DTW_start6 <= 0;
			if(DTW_start7) DTW_start7 <= 0;
			if(DTW_start8) DTW_start8 <= 0;
			if(DTW_start9) DTW_start9 <= 0;
			if(done) begin //done is only active for 1 cycle.
				done <= 0;
				command <= 4'b0000;
		
		end // else
   end // always
				
			


endmodule
