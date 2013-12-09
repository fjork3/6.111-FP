`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:58:05 11/19/2013 
// Design Name: 
// Module Name:    override_control 
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
module override_control(
    input clock,//system clock
    input reset,//system reset
    input [3:0] command, //voice (or switches) command
    input done_in,// command is ready for use signal
    output dir,//output direction (0 is left, 1 is right)
    output [7:0] val, //output value of how much to turn
    output done,//output saying val and dir are ready
	 output[3:0] com_debug//output of the stored command for debugging purposes;
    );
	
	//PARAMETERS
	 parameter STEPSIZE = 8'b00000010; //step size when direction is said
	 parameter GOSIZE = 8'b00000001; //step per clock cycle when in GO mode
	 
	 //module registers including output registers
	 reg [3:0] command_reg;
	 reg dir_reg, done_reg;
	 reg [7:0] val_reg;
	 reg persist;
	 
	 always @(posedge clock)begin
		if (reset)begin//on reset clear all the registers
			dir_reg <= 0;
			done_reg <= 0;
			command_reg <= 0;
			val_reg <= 0;
			persist <= 0;
		end
		else begin//choose outputs based on the given command
			case(command_reg)
			4'b1000: begin //Step Right
				dir_reg <= 0;
				val_reg <= STEPSIZE;
				done_reg <= 1;
				command_reg <= 0;
				end
			4'b1001: begin //Step Left
				dir_reg <= 1;
				val_reg <= STEPSIZE;
				done_reg <= 1;
				command_reg <= 0;
				end
			4'b1010: begin //Go
				val_reg <= GOSIZE;
				persist <= 1;
				done_reg <= 1;
				command_reg <= 0;
				end
			4'b1011: begin //STOP
				val_reg <= 8'b00000000;
				persist <= 0;
				done_reg <= 0;
				command_reg <= 0;
				end
			default: begin//for GO keep sending the signal otherwise stop after one clock cycle
				if(persist) done_reg <= 1;
				else begin
					done_reg <= 0;
					val_reg <= 8'b000000;
				end
			end
			endcase
		end

		if (done_in && !reset)command_reg <= command; //only store command when given the done_in signal
	end

//output registers assignments
assign dir = dir_reg;
assign val = val_reg;
assign done = done_reg;
assign com_debug = command_reg;
			
	 

endmodule
