`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:15:38 12/03/2013 
// Design Name: 
// Module Name:    audio_control 
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
module audio_control(
    input clock,
    input reset,
    input [11:0] intL,
    input [11:0] intR,
    output dir,
    output [7:0] val,
    output done
    );

	reg dir_reg, done_reg;
	reg [7:0] val_reg;


	parameter THRESHHOLD = 11'd100;
	parameter STEPUNIT = 8'd1; 


always @ (posedge clock) begin
	if (reset) begin
		dir_reg <= 0;
		val_reg <= 0;
		done_reg <= 0;
	end
	else begin
		if(intR > THRESHHOLD + intL) begin
			dir_reg <= 0;
			val_reg <= STEPUNIT*((intR-intL-THRESHHOLD)>>4);
			done_reg <= 1;
			end
		else if(intL > THRESHHOLD + intR) begin
			dir_reg <= 1;
			val_reg <= STEPUNIT*((intL-intR-THRESHHOLD)>>4);
			done_reg <= 1;
			end
		else done_reg <= 0;
	end

end
	
assign dir = dir_reg;
assign val = val_reg;
assign done = done_reg;

endmodule
