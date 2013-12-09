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
    input clock,//system clock
    input reset,//system reset
    input [15:0] intL,//integrated data from left mic
    input [15:0] intR,//integrated data from right mic
	 input intL_done,//ready signal from left mic (since sent from other board)
    output dir,//output direction 0 for left, 1 for right
    output [7:0] val,//output value (how many step to turn)
    output done//output done signal
    );

	//registers for outputs
	reg dir_reg, done_reg;
	reg [7:0] val_reg;

	//PARAMETERS
	parameter THRESHHOLD = 16'd8000; //threshhold difference needs to be for motor to turn
	parameter STEPUNIT = 8'd16; //how large a step should be taken for each unit of amplitude difference


always @ (posedge clock) begin
	if (reset) begin// on reset clear the registers
		dir_reg <= 0;
		val_reg <= 0;
		done_reg <= 0;
	end
	else if(intL_done) begin//when we've gotten data from the left mic
		if(intR > THRESHHOLD + intL) begin //if the right mic is louder turn right
			dir_reg <= 1;
			val_reg <= STEPUNIT*((intR-intL-THRESHHOLD)/32);
			done_reg <= 1;
			end
		else if(intL > THRESHHOLD + intR) begin// if the left mic is louder turn left
			dir_reg <= 0;
			val_reg <= STEPUNIT*((intL-intR-THRESHHOLD)/32);
			done_reg <= 1;
			end
		else done_reg <= 0;
	end

end

//Assign output registers	
assign dir = dir_reg;
assign val = val_reg;
assign done = done_reg;

endmodule
