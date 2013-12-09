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
    input [7:0] audio_in,//audio signal from ac97
    output [15:0] amplitude,//output integrated data
	 output [17:0] temp,//temp data for debugging
	 output done //output done signal
    );

	//PARAMETERS
	parameter MULTIPLY = 1; //multiply value for normalizing
	parameter THRESHHOLD = 5000;//Threshold for left mic to prevent too soft of data

	//output registers
	reg [9:0] count;
	reg [15:0] amplitude_reg;
	reg [17:0] tmp_reg;
	reg done_reg;
		
	wire [7:0] data;
	
	assign data = ((audio_in[7])? (~audio_in + 1): audio_in); //taking the magnitude of the signed data
	
	always @(posedge clock)begin
		if(reset) begin//on reset clear the registers
			amplitude_reg <= 0;
			count <= 0;
			tmp_reg <= 0;
			done_reg <= 0;
		end
		else begin
			if(ready) begin //add in each new data squared into temp
				tmp_reg <= tmp_reg + ((data*data)>>6);
				count <= count+1;
				done_reg <= 0;
			end
			else if(count == 10'd800) begin //one have 800 data multiply and store as amplitude
				amplitude_reg <= ((MULTIPLY*tmp_reg[17:2] > THRESHHOLD)? MULTIPLY*tmp_reg[17:2]: 0);
				tmp_reg <= 0;
				count <= 0;
				done_reg <= 1;
			end
		end
	end
	
	//output assignments to registers
	assign amplitude = amplitude_reg;
	assign temp = tmp_reg;	
	assign done = done_reg;

endmodule
