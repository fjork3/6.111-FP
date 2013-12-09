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
    input clock,//system clock
    input reset,//system reset
    input audio_dir,//input direction from audio control
    input [7:0] audio_val,//input value from audio control
    input audio_done,// done input from audio contorl
    input override_dir,//input direction from override_control
    input [7:0] override_val,//input value from override_control
    input override_done,//done signal from over_ride control
    input override,//override signal (when 1 use data from override, otherwise data from audio)
    output motor_out,//output signal to the servo motor
	 output [16:0] new_count, //new pulse width count for debugging
	 output [16:0] count //old pulse width count for debugging
    );

	//PARAMETERS
	parameter MS20COUNT = 20'd540000; //number of counts needed for the 20ms
	parameter MAXPULSE = 17'd67500; //Largest pulse width count
	parameter MINPULSE = 17'd13500;//smallesr pulse width count
	parameter CENTER = 17'd40500; //pulse width needed to center the servo
	
	//output registers
	reg motor_reg;
	reg [19:0] cycle_count;
	reg [16:0] pulse_count;
	reg [16:0] new_pulse_count;
	
	
	always @(posedge clock) begin
		if(reset) begin//on reset center the camera
			motor_reg <= 0;
			pulse_count <= CENTER;
			cycle_count <= 0;
			new_pulse_count <= CENTER;
		end
		else begin //make the pulse by having the signal be a 1 till the pulse count
			if(cycle_count == 0)begin
				motor_reg <= 1;
				cycle_count <= cycle_count + 1;
				end
			else if(cycle_count == pulse_count) begin
				motor_reg <= 0;
				cycle_count <= cycle_count + 1;
				end
			else if(cycle_count >= MS20COUNT) begin //and then 0 till the full 20ms passes
				cycle_count <= 0;
				motor_reg <= 1;
				if(new_pulse_count > MAXPULSE) pulse_count <= MAXPULSE; //keep pulse size within the set bounds
				else if(new_pulse_count < MINPULSE) pulse_count <= MINPULSE;
				else pulse_count <= new_pulse_count;
				end
			else cycle_count <= cycle_count + 1;
		
			if(override) begin //if override take new pulse count from override signals
				if (override_done) begin
				new_pulse_count <= (override_dir)? pulse_count + (override_val<<4): pulse_count - (override_val<<4);
				end
				else new_pulse_count <= new_pulse_count;
				end
			else if (audio_done)begin //otherwise take new pulse count from audio signals
				new_pulse_count <= (audio_dir)? pulse_count + (audio_val): pulse_count - (audio_val);  
				end
			else new_pulse_count <= new_pulse_count;
		
			
			end

end

//output assignments to registers
assign motor_out = motor_reg;
assign new_count = new_pulse_count;
assign count = pulse_count;

endmodule
