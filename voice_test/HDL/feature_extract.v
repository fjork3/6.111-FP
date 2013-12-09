/*
Computation engine for feature extraction.
- Runs FFT on chunks of audio data stored in BRAM
- 
One cycle through (on a start signal) will compute a single feature vector, for a 512-sample chunk of data (about 30 ms).
*/
module feature_extract(clock, start, done, bram_addr, bram_data, chunk_num);

   input clock, start;
   output reg done;
   output reg [13:0] bram_addr;
   input [7:0] bram_data;
   input [5:0] chunk_num;
   
   
   // 3e80 is highest address of BRAM
   parameter MAX_ADDR = 14'h3E80;

   // Main state machine state; keeps track of computation step.
   reg [3:0] state = 0;
   parameter IDLE_STATE = 4'h0;
   parameter READING_AUDIO = 4'h1;
   parameter COMPUTING_FFT = 4'h2;
   parameter READING_FFT = 4'h3;
   parameter FILTER_MULT = 4'h4;
   
   parameter SAMPLES_PER_CHUNK = 200;
   
   // Internal state
   reg [8:0] sample_num;
   reg [13:0] addr_base;
   reg init;
   reg [4:0] filter_num;
   
   
   // FFT module I/O
   reg fft_start, fft_reset;
   reg [8:0] fft_addr_in, fft_addr_out;
   reg fft_we, fft_re;
   wire fft_done;
   reg [7:0] fft_data_in;
   wire [7:0] fft_real_out, fft_imag_out;
   
   fft #(.M(9), .B(8)) fft_inst(.clk(clock), .reset(fft_reset),
            .start(fft_start), .done(fft_done),
            .addr_in(fft_addr_in), .addr_out(fft_addr_out),
            .write_enable_in(fft_we), .read_enable_out(fft_re),
            .data_real_in(fft_data_in), .data_imag_in(8'b0),
            .data_real_out(fft_real_out), .data_imag_out(fft_imag_out));
            
            
   // TODO BRAM for storing FFT output
   // bram #(.LOGSIZE(512), .WIDTH(16)) fft_out_ram(                  
   
   always @(posedge clock) begin
      
      
      // Main FSM
      case(state)
         //////////////////////////////////////////////////////////////////////////
         IDLE_STATE: begin
         // Waiting for signal to begin computation.
            if (start) begin
               init <= 1;
               state <= READING_AUDIO;
            end // if
            fft_we <= 0;
            fft_re <= 0;
            done <= 0;
            fft_reset <= 1;
   
         end // IDLE_STATE

         //////////////////////////////////////////////////////////////////////////
         READING_AUDIO: begin
         // Read audio data from BRAM into FFT module, one per clock cycle.
            
            // On first cycle, set BRAM address to start of relevant section.
            if (init) begin
               addr_base <= chunk_num * SAMPLES_PER_CHUNK;
               init <= 0;
               sample_num <= 0;
            end // if
            // TODO make sure timings work for getting first sample
            else begin
               fft_we <= 1;
               bram_addr <= addr_base + sample_num;
               sample_num <= sample_num + 1;
               fft_addr_in <= sample_num;
               
               // Go to next sample, or end 
               
            end // else
            
            // If on last sample, start FFT running.
            if (sample_num == 9'd511) begin
               state <= COMPUTING_FFT;
               fft_start <= 1;
            end // if
   
         end // READING_AUDIO
         
         
         //////////////////////////////////////////////////////////////////////////
         COMPUTING_FFT: begin
         // Wait for FFT module to finish
            
            
            if (fft_done)
               state <= READING_FFT;
   
            fft_we <= 0;
            init <= 0;
            fft_start <= 0;
            fft_reset <= 0;
   
         end // COMPUTING_FFT
         
         //////////////////////////////////////////////////////////////////////////
         READING_FFT: begin
         // Read out real and imaginary data from FFT, store results in a BRAM
            // TODO
            
   
   
         end // READING_FFT
         
         //////////////////////////////////////////////////////////////////////////
         FILTER_MULT: begin
         // Read through FFT data from BRAM and Mel filter coeffs
         // Generate vector of feature values
            // TODO
   
   
   
         end // FILTER_MULT     
                      
      endcase
   end // always

endmodule
