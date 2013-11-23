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
    input clock,
    input reset,
    input [3:0] command,
    input done_in,
    input ready,
    output dir,
    output [7:0] val,
    output done,
	 output[3:0] com_debug
    );
	
	 parameter STEPSIZE = 8'b00000010;
	 parameter GOSIZE = 8'b00000001;
	 
	 reg [3:0] command_reg;
	 reg dir_reg, done_reg;
	 reg [7:0] val_reg;
	 reg persist;
	 
	 always @(posedge clock)begin
		if (reset)begin
			dir_reg <= 0;
			done_reg <= 0;
			command_reg <= 0;
			val_reg <= 0;
			persist <= 0;
		end
		else begin
			case(command_reg)
			4'b1000: begin //Step Left
				dir_reg <= 0;
				val_reg <= STEPSIZE;
				done_reg <= 1;
				command_reg <= 0;
				end
			4'b1001: begin //Step Right
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
			default: begin
				if(persist) done_reg <= 1;
				else begin
					done_reg <= 0;
					val_reg <= 8'b000000;
				end
			end
			endcase
		end

		if (done_in && !reset)command_reg <= command;
	end

assign dir = dir_reg;
assign val = val_reg;
assign done = done_reg;
assign com_debug = command_reg;
			
	 

endmodule
