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
    input audio_dir,
    input [7:0] audio_val,
    input audio_done,
    input override_dir,
    input [7:0] override_val,
    input override_done,
    input override,
    output ready,
    output motor_out,
	 output [16:0] new_count,
	 output [16:0] count
    );

	parameter MS20COUNT = 20'd540000;
	parameter MAXPULSE = 17'd67500;
	parameter MINPULSE = 17'd13500;
	parameter CENTER = 17'd40500;
	
	reg motor_reg;
	reg ready_reg;
	reg [19:0] cycle_count;
	reg [16:0] pulse_count;
	reg [16:0] new_pulse_count;
	
	
	always @(posedge clock) begin
		if(reset) begin
			motor_reg <= 0;
			pulse_count <= CENTER;
			cycle_count <= 0;
			new_pulse_count <= CENTER;
			ready_reg <= 1;
		end
		else if(cycle_count == 0)begin
			motor_reg <= 1;
			cycle_count <= cycle_count + 1;
			end
		else if(cycle_count == pulse_count) begin
			motor_reg <= 0;
			cycle_count <= cycle_count + 1;
			end
		else if(cycle_count >= MS20COUNT) begin
			cycle_count <= 0;
			motor_reg <= 1;
			if(new_pulse_count > MAXPULSE) pulse_count <= MAXPULSE;
			else if(new_pulse_count < MINPULSE) pulse_count <= MINPULSE;
			else pulse_count <= new_pulse_count;
			ready_reg <= 1;
			end
		else cycle_count <= cycle_count + 1;
		
		//new_pulse_count <= (override_dir)?CENTER + (override_val<<7): CENTER - (override_val<<7);
			
		//if(new_pulse_count > MAXPULSE) new_pulse_count <= MAXPULSE;
		//if(new_pulse_count < MINPULSE) new_pulse_count <= MINPULSE;
		
		if(override && !reset) begin
			if (override_done) begin
			new_pulse_count <= (override_dir)? pulse_count + (override_val<<4): pulse_count - (override_val<<4);
			ready_reg <= 0;
			end
			else new_pulse_count <= new_pulse_count;
			end
		else if (audio_done)begin
			new_pulse_count <= (audio_dir)? pulse_count + (audio_val<<6): pulse_count - (audio_val<<6);  
			ready_reg <= 0;
			end
		else new_pulse_count <= new_pulse_count;
		
		if(ready_reg && ! reset) ready_reg <= 0;
			

end

assign motor_out = motor_reg;
assign new_count = new_pulse_count;
assign count = pulse_count;
assign ready = ready_reg;

endmodule
