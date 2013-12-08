///////////////////////////////////////////////////////////////////////////////
//
// 31-tap FIR filter, 8-bit signed data, 10-bit signed coefficients.
// ready is asserted whenever there is a new sample on the X input,
// the Y output should also be sampled at the same time.  Assumes at
// least 32 clocks between ready assertions.  Note that since the
// coefficients have been scaled by 2**10, so has the output (it's
// expanded from 8 bits to 18 bits).  To get an 8-bit result from the
// filter just divide by 2**10, ie, use Y[17:10].
//
///////////////////////////////////////////////////////////////////////////////

module fir31(
  input wire clock,reset,ready,
  input wire signed [7:0] x,
  output reg signed [17:0] y
);

   // internal wires for coeff module interface
   wire signed [9:0] coeff;
   reg [4:0] index = 0;

   // instantiate object to get coefficients
   coeffs31 coeffs(.index(index), .coeff(coeff));

   reg [4:0] offset = 0;


   reg signed [17:0] accumulator = 0;
   reg signed [17:0] next_term = 0;

   reg running = 0;

   reg signed [7:0] sample [31:0];  // 32 element array each 8 bits wide

   // for now just pass data through
   always @(posedge clock) begin

      if (ready) begin
         // set up accumulator for calculation
         accumulator <= 0;
         index <= 0;
         next_term <= 0;
         running <= 1;

         // store newest sample in circular buffer
         sample[(offset+1)&31] <= x;
         offset <= offset + 1;

      end // posedge ready


      else if (running) begin   // computation is running

         // computation is done; output result
         if (index == 5'd31) begin
            y <= accumulator;
            next_term <= 0;      // make sure acc doesn't change
            running <= 0;
         end

         // otherwise, keep moving through and adding terms
         else begin
            accumulator <= accumulator + coeff * sample[(offset - index) & 31];
            index <= index + 1;
         end

      end   // ready

   end






endmodule




///////////////////////////////////////////////////////////////////////////////
//
// Coefficients for a 31-tap low-pass FIR filter with Wn=.125 (eg, 3kHz for a
// 48kHz sample rate).  Since we're doing integer arithmetic, we've scaled
// the coefficients by 2**10
// Matlab command: round(fir1(30,.125)*1024)
//
///////////////////////////////////////////////////////////////////////////////

module coeffs31(
  input wire [4:0] index,
  output reg signed [9:0] coeff
);
  // tools will turn this into a 31x10 ROM
  always @(index)
    case (index)
      5'd0:  coeff = -10'sd1;
      5'd1:  coeff = -10'sd1;
      5'd2:  coeff = -10'sd3;
      5'd3:  coeff = -10'sd5;
      5'd4:  coeff = -10'sd6;
      5'd5:  coeff = -10'sd7;
      5'd6:  coeff = -10'sd5;
      5'd7:  coeff = 10'sd0;
      5'd8:  coeff = 10'sd10;
      5'd9:  coeff = 10'sd26;
      5'd10: coeff = 10'sd46;
      5'd11: coeff = 10'sd69;
      5'd12: coeff = 10'sd91;
      5'd13: coeff = 10'sd110;
      5'd14: coeff = 10'sd123;
      5'd15: coeff = 10'sd128;
      5'd16: coeff = 10'sd123;
      5'd17: coeff = 10'sd110;
      5'd18: coeff = 10'sd91;
      5'd19: coeff = 10'sd69;
      5'd20: coeff = 10'sd46;
      5'd21: coeff = 10'sd26;
      5'd22: coeff = 10'sd10;
      5'd23: coeff = 10'sd0;
      5'd24: coeff = -10'sd5;
      5'd25: coeff = -10'sd7;
      5'd26: coeff = -10'sd6;
      5'd27: coeff = -10'sd5;
      5'd28: coeff = -10'sd3;
      5'd29: coeff = -10'sd1;
      5'd30: coeff = -10'sd1;
      default: coeff = 10'hXXX;
    endcase
endmodule
