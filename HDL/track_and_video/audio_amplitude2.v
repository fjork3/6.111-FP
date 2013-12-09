`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:18:06 12/04/2013 
// Design Name: 
// Module Name:    audio_amplitude2 
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
module audio_amplitude2(
    input clock,//system clock
    input reset,//system reset
    input ready,//ready signal from ac97
    input [7:0] audio_in,//audio data from ac97
    output [15:0] amplitude,//integrated output data
	 output [17:0] temp,//temp value used for debugging
	 output done//done output
    );

	//PARAMETERS
	parameter MULTIPLY = 1; //multiply value for right mic
	parameter THRESHHOLD = 6500;//Threshhold for right mic

	reg [9:0] count;//count for data coming in
	reg [15:0] amplitude_reg;//register for amplitude data
	reg [17:0] tmp_reg;//tmp register holding the sum
	reg done_reg;//done register
		
	wire [7:0] data;
	
	assign data = ((audio_in[7])? (~audio_in + 1): audio_in); //data comes in signed so take the magnitude
	
	always @(posedge clock)begin
		if(reset) begin//if reset clear the values
			amplitude_reg <= 0;
			count <= 0;
			tmp_reg <= 0;
			done_reg <= 0;
		end
		else begin
			if(ready) begin//when ready take in data entry square it and divide by 2^6
				tmp_reg <= tmp_reg + ((data*data)>>6);
				count <= count+1;
				done_reg <= 0;
			end
			else if(count == 10'd800) begin //once 800 sample have been taken multiply by MULTIPL value and take upper 16 bits
				amplitude_reg <= MULTIPLY*((tmp_reg[17:2] > THRESHHOLD)? tmp_reg[17:2]: 0);
				tmp_reg <= 0;
				count <= 0;
				done_reg <= 1;
			end
		end
	end
	
	//assignment of registers to outputs
	assign amplitude = amplitude_reg;
	assign temp = tmp_reg;	
	assign done = done_reg;

endmodule
