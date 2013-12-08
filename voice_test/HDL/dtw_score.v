
module dtw_score(clock, in1, in2, score, start, done);

   // possible modification: take in data sequentially (since not all needs to be processed at once); would need next_data line, or something similar

   input clock;
   
   // Sequences of feature vectors: 40 frames, 12 features, 8 bits each
   input [39:0] [11:0] [7:0] in1, in2;
   
   output [7:0] score;

   // receive high pulse to start, emit high pulse on completion
   input start;
   output done;

endmodule
