`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:14 12/02/2013 
// Design Name: 
// Module Name:    audio_integrator 
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
module audio_integrator #(parameter ZERO = 12'd480)(
    input clock,
    input reset,
    input done,
    input [11:0] data,
    output start,
    output [11:0] integrated
    );

	 reg start_reg;
	 reg [11:0] data_reg[1:0]; 
	 reg cir_count;
	 reg [11:0] integrated_reg;
	 reg [3:0] i;
	 reg done_stop, peak_check;
	 wire [15:0] square_data;

	 assign square_data = (data >= ZERO)? 5*(data - ZERO) : 0;
	
always @(posedge clock) begin
	if (reset)begin
		cir_count <= 7'b0;
		integrated_reg <= 24'b0;
		for(i=0; i<2; i=i+1) begin
			data_reg[i] <= 12'b0;
			end
		start_reg <= 0;
		peak_check <= 0;
	end
	else begin
		if(done && !done_stop)begin
		data_reg[cir_count] <= square_data ;
			if (peak_check && (square_data <= data_reg[~cir_count])) begin
				integrated_reg <= data_reg[~cir_count];
				peak_check <= 0;
				end
			else if(square_data > data_reg[~cir_count]) begin
				peak_check <= 1;
				end
			else peak_check <= 0;
		start_reg <= 1;
		cir_count <= cir_count + 1;
		done_stop <= 1;
		end 
		else if (!done) begin
			if(start_reg) start_reg <= ~start_reg;
			if(done_stop) done_stop <= 0;
			end
	end
	end
	
assign start = start_reg;
assign integrated = integrated_reg;


endmodule
