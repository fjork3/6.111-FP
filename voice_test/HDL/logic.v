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
    input clock,
    input reset,
    input training_enable,
    input [3:0] training_select,
    input DTW_score1,
	 input DTW_score2,
	 input DTW_score3,
	 input DTW_score4,
	 input DTW_score5,
	 input DTW_score6,
	 input DTW_score7,
	 input DTW_score8,
	 input DTW_score9,
    input DTW_done1,
	 input DTW_done2,
	 input DTW_done3,
	 input DTW_done4,
	 input DTW_done5,
	 input DTW_done6,
	 input DTW_done7,
	 input DTW_done8,
	 input DTW_done9,
    output reg DTW_train1,//NONE
	 output reg DTW_train2,//RED
	 output reg DTW_train3,//BLACK
	 output reg DTW_train4,//BLUE
	 output reg DTW_train5,//LEFT
	 output reg DTW_train6,//RIGHT
	 output reg DTW_train7,//GO
	 output reg DTW_train8,//STOP
	 output reg DTW_train9,//NOISE no clear word?
    output [3:1] command
    );

	
	reg command_reg;
	wire all_done;
	wire [26:0] min12,min34,min56,min78;
	wire [3:0] minstate12, minstate34, minstate56, minstate78, min;
	wire [26:0] min_next1, min_next2;
	wire [3:0] min_nextstate1, min_nextstate2;
	
	
	//Find the minimum among the DTW scores
	assign min12 = (DTW_score1 < DTW_score2)? DTW_score1: DTW_score2;
	assign minstate12 = (DTW_score1 < DTW_score2)? 1: 2;
	assign min34 = (DTW_score3 < DTW_score4)? DTW_score3: DTW_score4;
	assign minstate34 = (DTW_score3 < DTW_score4)? 3: 4;
	assign min56 = (DTW_score5 < DTW_score6)? DTW_score5: DTW_score6;
	assign minstate56 = (DTW_score5 < DTW_score6)? 5: 6;
	assign min78 = (DTW_score7 < DTW_score8)? DTW_score7: DTW_score8;
	assign minstate78 = (DTW_score7 < DTW_score8)? 7: 8;
	
	assign min_next1 = (min12 < min34)? min12: min34;
	assign min_nextstate1 = (min12 < min34)? minstate12: minstate34;
	assign min_next2 = (min56 < min78)? min56: min78;
	assign min_nextstate2 = (min56 < min78)? minstate56: minstate78;
	
	assign min_value = (min_next1 < min_next2)? min_next1: min_next2;
	assign min = (min_next1 < min_next2)? min_nextstate1: min_nextstate2;
	
	//is true only once all 9 DTW engines are complete
	assign all_done = (DWT_done1&DTW_done2&DTW_done3&DTW_done4&DTW_done5&DTW_done6&DTW_done7&DTW_done8&DTW_done9);
	
	
	always @(posedge clock) begin
		if(reset) begin //On reset clear all the train switches
		command_reg<= 0;
		DTW_train1 <= 0;
		DTW_train2 <= 0;
		DTW_train3 <= 0;
		DTW_train4 <= 0;
		DTW_train5 <= 0;
		DTW_train6 <= 0;
		DTW_train7 <= 0;
		DTW_train8 <= 0;
		DTW_train9 <= 0;
		end
		else begin
			if(training_enable) begin//if trainig switch is one train the corresponding DTW only
				command_reg <= 0;//command is nothing
				case(training_select)
					4'b0000: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 1;
						end
					4'b0100: begin
						DTW_train1 <= 1;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b0101: begin
						DTW_train1 <= 0;
						DTW_train2 <= 1;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b0110: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 1;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b0111: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 1;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b1000: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 1;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b1001: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 1;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b1010: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 1;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					4'b1011: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 1;
						DTW_train9 <= 0;
						end
					default: begin
						DTW_train1 <= 0;
						DTW_train2 <= 0;
						DTW_train3 <= 0;
						DTW_train4 <= 0;
						DTW_train5 <= 0;
						DTW_train6 <= 0;
						DTW_train7 <= 0;
						DTW_train8 <= 0;
						DTW_train9 <= 0;
						end
					endcase
				end
			else if(all_done) begin
				if(min_value < DTW_score9) begin //only use value if better score than plain noise
					case(min) begin //MY LIST OF command values, change if you think neccesary
					4'd1: command_reg <= 4'b0100;//NONE
					4'd2: command_reg <= 4'b0101;//RED
					4'd3: command_reg <= 4'b0110;//BLACK
					4'd4: command_reg <= 4'b0111;//BLUE
					4'd5: command_reg <= 4'b1000;//LEFT
					4'd6: command_reg <= 4'b1001;//RIGHT
					4'd7: command_reg <= 4'b1010;//GO
					4'd8: command_reg <= 4'b1011;//STOP
					default: command_reg <= 4'b0000; //NO COMMAND
				endcase
				end
				else command_reg <= 4'b0000;
			end
		else command_reg <= 4'b0000; //command only stays on value for one clock cycle.
		end
assign command = command_reg;
				
			


endmodule
