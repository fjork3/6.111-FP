
module dtw_score(clock,reset, in, train_enable, score, start, done);

   // possible modification: take in data sequentially (since not all needs to be processed at once); would need next_data line, or something similar

   input clock; //system clock
	input reset; //system reset
   
   // Sequences of feature vectors: 40 frames, 12 features, 8 bits each
   input [7:0] in; 
   input train_enable; //when true sequence is stored rather than compared
   output reg [24:0] score; //final DTW score

   // receive high pulse to start, emit high pulse on completion
   input start;
   output reg done;
	
	//STATES
	parameter WAIT = 2'b00;
	parameter DATA_IN = 2'b01;
	parameter ADD = 2'b10;
	parameter TRAIN = 2'b11;
	
	//Counting Registers
	reg [3:0] j;
	reg [5:0] i;
	
	reg [1:0] state;
	reg [7:0] test[39:0][11:0]; //data just recorded
	reg [15:0] tmp[39:0][11:0]; //tmp storage of compared square values
	
	//BEGIN STATE MACHINE
	always @(posedge clock) begin
		if(reset) begin //on reset clear out registers
			for(i=0;i<40;i=i+1) begin
				for(j=0; j<12; j=j+1) begin
					test[i][j] <= 8'b0;
					tmp[i][j] <= 16'b0;
					end
				end
			score <= 0;
			state <= WAIT;
			done <= 0;
		end
		else begin
			case (state) 
			WAIT: begin //WAIT until start signal then if train is enabled go to TRAIN, otherwise go to DATA_IN
				if(train_enable && start)begin
					state <= TRAIN;
					i<=0;
				end
				else if(start) begin
					state <= DATA_IN;
					score <= 0;
					done <= 0;
					i <= 0;
				end
				else state <= WAIT;
				end
			TRAIN:begin//Store the incoming 40*12 bytes in test[i][j] then go back to WAIT
					if(i < 40) begin
						if(j < 12) begin
							test[i][j] <= in;
							j <= j+1;
						end
						else begin
							j<= 0;
							i <= i +1;
						end
					end
					else begin
						state <= WAIT;
						done <= 1;
					end
				end
			DATA_IN: begin //Square the difference between test[i][j] and the input (EUCLIDIEAN DISTANCE) once done for all 480 bytes go to ADD
					if(i < 40) begin
						if(j < 12) begin
							tmp[i][j] <= (in>test[i][j])? ((in - test[i][j])*(in - test[i][j])):((test[i][j] - in)*(test[i][j] - in));
							j <= j+1;
							end
						else begin
							j <= 0;
							i <= i + 1;
							end
						end
					else begin
						state <= ADD;
						i<= 0;
					end
				end
			ADD: begin //ADD together the 480 square bytes to get a full DTW score, then return the value and go back to WAIT
						if(i < 40) begin
							if(j < 12) begin
								score <= score + tmp[i][j];
								j <= j + 1;
								end
							else begin
								j <= 0;
								i <= i + 1;
								end
						end
						else begin
							state <= WAIT;
							done <= 1;
							i<= 0;
						end
					end
			default begin
				state <= WAIT;
				end
			endcase
		end
	end
endmodule
