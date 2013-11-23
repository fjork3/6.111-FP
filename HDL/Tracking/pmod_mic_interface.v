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
module servo_interface(
    input clock,
    input reset,
    input sdata,
    input start,
    output sclock,
    output ncs,
    output done,
    output [11:0] data
    );

	parameter IDLE = 2'b00;
	parameter SHIFT_IN = 2'b01;
	parameter SYNCDATA = 2'b10;

	reg [1:0] state;
	reg [15: 0] temp;
	reg clk_div;
	reg [1:0] clk_counter;
	reg [3:0] shiftCounter = 4'b0000;
	reg enShiftCounter;
	reg enParalelLoad;
	reg ncs_reg;
	reg done_reg;
	reg [11:0] data_reg;


always @ (posedge clock) begin  //will need to be changed to match our clock
	if(reset)clk_counter <= 2'b00;
	else clk_counter <= clk_counter + 1;
	clk_div <= clk_counter[1];	
end

always @ (posedge clk_div) begin
	if (reset) state <= IDLE;
	else begin
	case(state)
		IDLE: begin
			enShiftCounter <= 0;
			don_reg <= 1;
			ncs_reg <= 1;
			enParalelLoad <= 0;
			if(start) state <= SHIFT_IN;
			end
		SHIFT_IN: begin
			

always 
	