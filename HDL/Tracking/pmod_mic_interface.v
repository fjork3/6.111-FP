`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:13 11/13/2013 
// Design Name: 
// Module Name:    servo_interface 
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
module pmod_mic_interface(
    input clock, 
    input reset,
    input sdata,
    input start,
    output sclock,
    output ncs,
    output done,
    output [11:0] data,
	 output [1:0] outstate,
	 output [3:0] counter
    );

	parameter IDLE = 2'b00;
	parameter SHIFT_IN = 2'b01;
	parameter SYNCDATA = 2'b10;

	reg [1:0] state;
	reg [15: 0] temp;
	reg [4:0] clk_counter;
	reg clk_div;
	reg [3:0] shiftCounter = 4'b0000;
	reg enShiftCounter;
	reg enParalelLoad;
	reg ncs_reg;
	reg done_reg;
	reg [11:0] data_reg;


always @ (posedge clock) begin  //produces a 27/512 = 52 khz signal
	if(reset)clk_counter <= 5'b0;
	else clk_counter <= clk_counter + 1;
	clk_div <= clk_counter[4];	
end

always @ (posedge clk_div) begin
	if (reset) begin
		state <= IDLE;
		shiftCounter <= 4'b0000;
		temp <= 0;
		end
	else begin
	case(state)
		IDLE: begin
			enShiftCounter <= 0;
			done_reg <= 1;
			ncs_reg <= 1;
			enParalelLoad <= 0;
			temp <= 0;
			if(start) state <= SHIFT_IN;
			end
		SHIFT_IN: begin
			done_reg <= 0;
			ncs_reg <= 0;
			enParalelLoad <= 0;
			if(shiftCounter == 4'b1111)begin
				state <= SYNCDATA;
				enShiftCounter <= 0;
				end
			else enShiftCounter <= 1;
			end
		SYNCDATA: begin
			enShiftCounter <= 0;
			done_reg <= 0;
			ncs_reg <= 1;
			enParalelLoad <= 1;
			if (!start) state <= IDLE;
			end
		default: state <= IDLE;
		endcase
	
	if(enShiftCounter) begin
		temp <= {temp[14:0],sdata};
		shiftCounter <= shiftCounter + 1;
		end
	else if(enParalelLoad) begin
		shiftCounter <= 4'b0000;
		data_reg <= temp[11:0];
		end
	end
	
	end

assign sclock = !clk_div;
assign ncs = ncs_reg;
assign done = done_reg;
assign data = data_reg;
assign counter = shiftCounter;
assign outstate = state;
endmodule

	