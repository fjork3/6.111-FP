/*
Generate Mel filter coefficients, one per clock cycle, for 257-point FFT result (from 512-point transformation discarding negative frequencies).
Parameterized by filter number.
One cycle latency between receiving coefficient & filter, and outputting Mel filter coefficient.
*/
module mel_filter(clock, coeff_num, filter_num, coeff);

   input clock;
   input [7:0] coeff_num;
   input [4:0] filter_num;
   
   output [7:0] coeff;
   
   reg [7:0] coeff_num_p;  // buffer coeff number for next cycle
   reg [7:0] descending, ascending;
   reg [7:0] low, mid, high;
   
//   boundaries = [0,3,6,10,14,18,24,30,36,44,52,62,72,85,98,114,131,150,173,197,225,256]


   // Implemented as 256-entry tables, with 2 entries for each index.
   // Assumes fixed placements of bin edges, as determined by Mel scale.
   // Based on low, mid, and high, assigns entry 0, 1023, or table entry. 

   // Select between possible values of coefficient based on bin selected
   assign coeff = (coeff_num_p > mid) ? ((coeff_num_p < high) ? descending : 8'b0)
                                    : ((coeff_num_p > low) ? ascending : 8'b0);

   always @(posedge clock) begin   
   
      coeff_num_p <= coeff_num;
      
      // Set boundaries for bins
      case(filter_num)
         5'd0: begin 
            low <= 0;
            mid <= 3;
            high <= 6;
            end
         5'd1: begin
            low <= 3;
            mid <= 6;
            high <= 10;
            end 
         5'd2: begin
            low <= 6;
            mid <= 10;
            high <= 14;
            end
         5'd3: begin
            low <= 10;
            mid <= 14;
            high <= 18;
            end               
         5'd4: begin
            low <= 14;
            mid <= 18;
            high <= 24; 
            end
         5'd5: begin
            low <= 18;
            mid <= 24;
            high <= 30;
            end
         5'd6: begin
            low <= 24;
            mid <= 30;
            high <= 36;  
            end 
         5'd7: begin
            low <= 30;
            mid <= 36;
            high <= 44;
            end
         5'd8: begin
            low <= 36;
            mid <= 44;
            high <= 52; 
            end
         5'd9: begin
            low <= 44;
            mid <= 52;
            high <= 62;
            end
         5'd10: begin
            low <= 52;
            mid <= 62;
            high <= 72;    
            end           
         5'd11: begin
            low <= 62;
            mid <= 72;
            high <= 85;
            end
         5'd12: begin
            low <= 72;
            mid <= 85;
            high <= 98; 
            end
         5'd13: begin
            low <= 85;
            mid <= 98;
            high <= 114;
            end
         5'd14: begin
            low <= 98;
            mid <= 114;
            high <= 131;    
            end
         5'd15: begin
            low <= 114;
            mid <= 131;
            high <= 150;
            end
         5'd16: begin
            low <= 131;
            mid <= 150;
            high <= 173;   
            end            
         5'd17: begin
            low <= 150;
            mid <= 173;
            high <= 197;
            end
         5'd18: begin
            low <= 173;
            mid <= 197;
            high <= 225; 
            end
         default: begin
            low <= 0;
            mid <= 0;
            high <= 0;    
            end                                   
      endcase
      
   
      case(coeff_num)
         // Values generated with python (create_coeffs.py)
         8'd0: ascending <= 1023;
         8'd1: ascending <= 341;
         8'd2: ascending <= 682;
         8'd3: ascending <= 1023;
         8'd4: ascending <= 341;
         8'd5: ascending <= 682;
         8'd6: ascending <= 1023;
         8'd7: ascending <= 256;
         8'd8: ascending <= 512;
         8'd9: ascending <= 767;
         8'd10: ascending <= 1023;
         8'd11: ascending <= 256;
         8'd12: ascending <= 512;
         8'd13: ascending <= 767;
         8'd14: ascending <= 1023;
         8'd15: ascending <= 256;
         8'd16: ascending <= 512;
         8'd17: ascending <= 767;
         8'd18: ascending <= 1023;
         8'd19: ascending <= 171;
         8'd20: ascending <= 341;
         8'd21: ascending <= 512;
         8'd22: ascending <= 682;
         8'd23: ascending <= 853;
         8'd24: ascending <= 1023;
         8'd25: ascending <= 171;
         8'd26: ascending <= 341;
         8'd27: ascending <= 512;
         8'd28: ascending <= 682;
         8'd29: ascending <= 853;
         8'd30: ascending <= 1023;
         8'd31: ascending <= 171;
         8'd32: ascending <= 341;
         8'd33: ascending <= 512;
         8'd34: ascending <= 682;
         8'd35: ascending <= 853;
         8'd36: ascending <= 1023;
         8'd37: ascending <= 128;
         8'd38: ascending <= 256;
         8'd39: ascending <= 384;
         8'd40: ascending <= 512;
         8'd41: ascending <= 639;
         8'd42: ascending <= 767;
         8'd43: ascending <= 895;
         8'd44: ascending <= 1023;
         8'd45: ascending <= 128;
         8'd46: ascending <= 256;
         8'd47: ascending <= 384;
         8'd48: ascending <= 512;
         8'd49: ascending <= 639;
         8'd50: ascending <= 767;
         8'd51: ascending <= 895;
         8'd52: ascending <= 1023;
         8'd53: ascending <= 102;
         8'd54: ascending <= 205;
         8'd55: ascending <= 307;
         8'd56: ascending <= 409;
         8'd57: ascending <= 512;
         8'd58: ascending <= 614;
         8'd59: ascending <= 716;
         8'd60: ascending <= 818;
         8'd61: ascending <= 921;
         8'd62: ascending <= 1023;
         8'd63: ascending <= 102;
         8'd64: ascending <= 205;
         8'd65: ascending <= 307;
         8'd66: ascending <= 409;
         8'd67: ascending <= 512;
         8'd68: ascending <= 614;
         8'd69: ascending <= 716;
         8'd70: ascending <= 818;
         8'd71: ascending <= 921;
         8'd72: ascending <= 1023;
         8'd73: ascending <= 79;
         8'd74: ascending <= 157;
         8'd75: ascending <= 236;
         8'd76: ascending <= 315;
         8'd77: ascending <= 393;
         8'd78: ascending <= 472;
         8'd79: ascending <= 551;
         8'd80: ascending <= 630;
         8'd81: ascending <= 708;
         8'd82: ascending <= 787;
         8'd83: ascending <= 866;
         8'd84: ascending <= 944;
         8'd85: ascending <= 1023;
         8'd86: ascending <= 79;
         8'd87: ascending <= 157;
         8'd88: ascending <= 236;
         8'd89: ascending <= 315;
         8'd90: ascending <= 393;
         8'd91: ascending <= 472;
         8'd92: ascending <= 551;
         8'd93: ascending <= 630;
         8'd94: ascending <= 708;
         8'd95: ascending <= 787;
         8'd96: ascending <= 866;
         8'd97: ascending <= 944;
         8'd98: ascending <= 1023;
         8'd99: ascending <= 64;
         8'd100: ascending <= 128;
         8'd101: ascending <= 192;
         8'd102: ascending <= 256;
         8'd103: ascending <= 320;
         8'd104: ascending <= 384;
         8'd105: ascending <= 448;
         8'd106: ascending <= 512;
         8'd107: ascending <= 575;
         8'd108: ascending <= 639;
         8'd109: ascending <= 703;
         8'd110: ascending <= 767;
         8'd111: ascending <= 831;
         8'd112: ascending <= 895;
         8'd113: ascending <= 959;
         8'd114: ascending <= 1023;
         8'd115: ascending <= 60;
         8'd116: ascending <= 120;
         8'd117: ascending <= 181;
         8'd118: ascending <= 241;
         8'd119: ascending <= 301;
         8'd120: ascending <= 361;
         8'd121: ascending <= 421;
         8'd122: ascending <= 481;
         8'd123: ascending <= 542;
         8'd124: ascending <= 602;
         8'd125: ascending <= 662;
         8'd126: ascending <= 722;
         8'd127: ascending <= 782;
         8'd128: ascending <= 842;
         8'd129: ascending <= 903;
         8'd130: ascending <= 963;
         8'd131: ascending <= 1023;
         8'd132: ascending <= 54;
         8'd133: ascending <= 108;
         8'd134: ascending <= 162;
         8'd135: ascending <= 215;
         8'd136: ascending <= 269;
         8'd137: ascending <= 323;
         8'd138: ascending <= 377;
         8'd139: ascending <= 431;
         8'd140: ascending <= 485;
         8'd141: ascending <= 538;
         8'd142: ascending <= 592;
         8'd143: ascending <= 646;
         8'd144: ascending <= 700;
         8'd145: ascending <= 754;
         8'd146: ascending <= 808;
         8'd147: ascending <= 861;
         8'd148: ascending <= 915;
         8'd149: ascending <= 969;
         8'd150: ascending <= 1023;
         8'd151: ascending <= 44;
         8'd152: ascending <= 89;
         8'd153: ascending <= 133;
         8'd154: ascending <= 178;
         8'd155: ascending <= 222;
         8'd156: ascending <= 267;
         8'd157: ascending <= 311;
         8'd158: ascending <= 356;
         8'd159: ascending <= 400;
         8'd160: ascending <= 445;
         8'd161: ascending <= 489;
         8'd162: ascending <= 534;
         8'd163: ascending <= 578;
         8'd164: ascending <= 623;
         8'd165: ascending <= 667;
         8'd166: ascending <= 712;
         8'd167: ascending <= 756;
         8'd168: ascending <= 801;
         8'd169: ascending <= 845;
         8'd170: ascending <= 890;
         8'd171: ascending <= 934;
         8'd172: ascending <= 979;
         8'd173: ascending <= 1023;
         8'd174: ascending <= 43;
         8'd175: ascending <= 85;
         8'd176: ascending <= 128;
         8'd177: ascending <= 171;
         8'd178: ascending <= 213;
         8'd179: ascending <= 256;
         8'd180: ascending <= 298;
         8'd181: ascending <= 341;
         8'd182: ascending <= 384;
         8'd183: ascending <= 426;
         8'd184: ascending <= 469;
         8'd185: ascending <= 512;
         8'd186: ascending <= 554;
         8'd187: ascending <= 597;
         8'd188: ascending <= 639;
         8'd189: ascending <= 682;
         8'd190: ascending <= 725;
         8'd191: ascending <= 767;
         8'd192: ascending <= 810;
         8'd193: ascending <= 853;
         8'd194: ascending <= 895;
         8'd195: ascending <= 938;
         8'd196: ascending <= 980;
         8'd197: ascending <= 1023;
         8'd198: ascending <= 37;
         8'd199: ascending <= 73;
         8'd200: ascending <= 110;
         8'd201: ascending <= 146;
         8'd202: ascending <= 183;
         8'd203: ascending <= 219;
         8'd204: ascending <= 256;
         8'd205: ascending <= 292;
         8'd206: ascending <= 329;
         8'd207: ascending <= 365;
         8'd208: ascending <= 402;
         8'd209: ascending <= 438;
         8'd210: ascending <= 475;
         8'd211: ascending <= 512;
         8'd212: ascending <= 548;
         8'd213: ascending <= 585;
         8'd214: ascending <= 621;
         8'd215: ascending <= 658;
         8'd216: ascending <= 694;
         8'd217: ascending <= 731;
         8'd218: ascending <= 767;
         8'd219: ascending <= 804;
         8'd220: ascending <= 840;
         8'd221: ascending <= 877;
         8'd222: ascending <= 913;
         8'd223: ascending <= 950;
         8'd224: ascending <= 986;
         8'd225: ascending <= 1023;
         8'd226: ascending <= 33;
         8'd227: ascending <= 66;
         8'd228: ascending <= 99;
         8'd229: ascending <= 132;
         8'd230: ascending <= 165;
         8'd231: ascending <= 198;
         8'd232: ascending <= 231;
         8'd233: ascending <= 264;
         8'd234: ascending <= 297;
         8'd235: ascending <= 330;
         8'd236: ascending <= 363;
         8'd237: ascending <= 396;
         8'd238: ascending <= 429;
         8'd239: ascending <= 462;
         8'd240: ascending <= 495;
         8'd241: ascending <= 528;
         8'd242: ascending <= 561;
         8'd243: ascending <= 594;
         8'd244: ascending <= 627;
         8'd245: ascending <= 660;
         8'd246: ascending <= 693;
         8'd247: ascending <= 726;
         8'd248: ascending <= 759;
         8'd249: ascending <= 792;
         8'd250: ascending <= 825;
         8'd251: ascending <= 858;
         8'd252: ascending <= 891;
         8'd253: ascending <= 924;
         8'd254: ascending <= 957;
         8'd255: ascending <= 990;
      endcase   
      
      case(coeff_num)
         8'd0: descending <= 1023;
         8'd1: descending <= 682;
         8'd2: descending <= 341;
         8'd3: descending <= 1023;
         8'd4: descending <= 682;
         8'd5: descending <= 341;
         8'd6: descending <= 1023;
         8'd7: descending <= 767;
         8'd8: descending <= 511;
         8'd9: descending <= 256;
         8'd10: descending <= 1023;
         8'd11: descending <= 767;
         8'd12: descending <= 511;
         8'd13: descending <= 256;
         8'd14: descending <= 1023;
         8'd15: descending <= 767;
         8'd16: descending <= 511;
         8'd17: descending <= 256;
         8'd18: descending <= 1023;
         8'd19: descending <= 852;
         8'd20: descending <= 682;
         8'd21: descending <= 511;
         8'd22: descending <= 341;
         8'd23: descending <= 170;
         8'd24: descending <= 1023;
         8'd25: descending <= 852;
         8'd26: descending <= 682;
         8'd27: descending <= 511;
         8'd28: descending <= 341;
         8'd29: descending <= 170;
         8'd30: descending <= 1023;
         8'd31: descending <= 852;
         8'd32: descending <= 682;
         8'd33: descending <= 511;
         8'd34: descending <= 341;
         8'd35: descending <= 170;
         8'd36: descending <= 1023;
         8'd37: descending <= 895;
         8'd38: descending <= 767;
         8'd39: descending <= 639;
         8'd40: descending <= 511;
         8'd41: descending <= 384;
         8'd42: descending <= 256;
         8'd43: descending <= 128;
         8'd44: descending <= 1023;
         8'd45: descending <= 895;
         8'd46: descending <= 767;
         8'd47: descending <= 639;
         8'd48: descending <= 511;
         8'd49: descending <= 384;
         8'd50: descending <= 256;
         8'd51: descending <= 128;
         8'd52: descending <= 1023;
         8'd53: descending <= 921;
         8'd54: descending <= 818;
         8'd55: descending <= 716;
         8'd56: descending <= 614;
         8'd57: descending <= 511;
         8'd58: descending <= 409;
         8'd59: descending <= 307;
         8'd60: descending <= 205;
         8'd61: descending <= 102;
         8'd62: descending <= 1023;
         8'd63: descending <= 921;
         8'd64: descending <= 818;
         8'd65: descending <= 716;
         8'd66: descending <= 614;
         8'd67: descending <= 511;
         8'd68: descending <= 409;
         8'd69: descending <= 307;
         8'd70: descending <= 205;
         8'd71: descending <= 102;
         8'd72: descending <= 1023;
         8'd73: descending <= 944;
         8'd74: descending <= 866;
         8'd75: descending <= 787;
         8'd76: descending <= 708;
         8'd77: descending <= 630;
         8'd78: descending <= 551;
         8'd79: descending <= 472;
         8'd80: descending <= 393;
         8'd81: descending <= 315;
         8'd82: descending <= 236;
         8'd83: descending <= 157;
         8'd84: descending <= 79;
         8'd85: descending <= 1023;
         8'd86: descending <= 944;
         8'd87: descending <= 866;
         8'd88: descending <= 787;
         8'd89: descending <= 708;
         8'd90: descending <= 630;
         8'd91: descending <= 551;
         8'd92: descending <= 472;
         8'd93: descending <= 393;
         8'd94: descending <= 315;
         8'd95: descending <= 236;
         8'd96: descending <= 157;
         8'd97: descending <= 79;
         8'd98: descending <= 1023;
         8'd99: descending <= 959;
         8'd100: descending <= 895;
         8'd101: descending <= 831;
         8'd102: descending <= 767;
         8'd103: descending <= 703;
         8'd104: descending <= 639;
         8'd105: descending <= 575;
         8'd106: descending <= 511;
         8'd107: descending <= 448;
         8'd108: descending <= 384;
         8'd109: descending <= 320;
         8'd110: descending <= 256;
         8'd111: descending <= 192;
         8'd112: descending <= 128;
         8'd113: descending <= 64;
         8'd114: descending <= 1023;
         8'd115: descending <= 963;
         8'd116: descending <= 903;
         8'd117: descending <= 842;
         8'd118: descending <= 782;
         8'd119: descending <= 722;
         8'd120: descending <= 662;
         8'd121: descending <= 602;
         8'd122: descending <= 542;
         8'd123: descending <= 481;
         8'd124: descending <= 421;
         8'd125: descending <= 361;
         8'd126: descending <= 301;
         8'd127: descending <= 241;
         8'd128: descending <= 181;
         8'd129: descending <= 120;
         8'd130: descending <= 60;
         8'd131: descending <= 1023;
         8'd132: descending <= 969;
         8'd133: descending <= 915;
         8'd134: descending <= 861;
         8'd135: descending <= 808;
         8'd136: descending <= 754;
         8'd137: descending <= 700;
         8'd138: descending <= 646;
         8'd139: descending <= 592;
         8'd140: descending <= 538;
         8'd141: descending <= 485;
         8'd142: descending <= 431;
         8'd143: descending <= 377;
         8'd144: descending <= 323;
         8'd145: descending <= 269;
         8'd146: descending <= 215;
         8'd147: descending <= 162;
         8'd148: descending <= 108;
         8'd149: descending <= 54;
         8'd150: descending <= 1023;
         8'd151: descending <= 979;
         8'd152: descending <= 934;
         8'd153: descending <= 890;
         8'd154: descending <= 845;
         8'd155: descending <= 801;
         8'd156: descending <= 756;
         8'd157: descending <= 712;
         8'd158: descending <= 667;
         8'd159: descending <= 623;
         8'd160: descending <= 578;
         8'd161: descending <= 534;
         8'd162: descending <= 489;
         8'd163: descending <= 445;
         8'd164: descending <= 400;
         8'd165: descending <= 356;
         8'd166: descending <= 311;
         8'd167: descending <= 267;
         8'd168: descending <= 222;
         8'd169: descending <= 178;
         8'd170: descending <= 133;
         8'd171: descending <= 89;
         8'd172: descending <= 44;
         8'd173: descending <= 1023;
         8'd174: descending <= 980;
         8'd175: descending <= 938;
         8'd176: descending <= 895;
         8'd177: descending <= 852;
         8'd178: descending <= 810;
         8'd179: descending <= 767;
         8'd180: descending <= 725;
         8'd181: descending <= 682;
         8'd182: descending <= 639;
         8'd183: descending <= 597;
         8'd184: descending <= 554;
         8'd185: descending <= 511;
         8'd186: descending <= 469;
         8'd187: descending <= 426;
         8'd188: descending <= 384;
         8'd189: descending <= 341;
         8'd190: descending <= 298;
         8'd191: descending <= 256;
         8'd192: descending <= 213;
         8'd193: descending <= 170;
         8'd194: descending <= 128;
         8'd195: descending <= 85;
         8'd196: descending <= 43;
         8'd197: descending <= 1023;
         8'd198: descending <= 986;
         8'd199: descending <= 950;
         8'd200: descending <= 913;
         8'd201: descending <= 877;
         8'd202: descending <= 840;
         8'd203: descending <= 804;
         8'd204: descending <= 767;
         8'd205: descending <= 731;
         8'd206: descending <= 694;
         8'd207: descending <= 658;
         8'd208: descending <= 621;
         8'd209: descending <= 585;
         8'd210: descending <= 548;
         8'd211: descending <= 511;
         8'd212: descending <= 475;
         8'd213: descending <= 438;
         8'd214: descending <= 402;
         8'd215: descending <= 365;
         8'd216: descending <= 329;
         8'd217: descending <= 292;
         8'd218: descending <= 256;
         8'd219: descending <= 219;
         8'd220: descending <= 183;
         8'd221: descending <= 146;
         8'd222: descending <= 110;
         8'd223: descending <= 73;
         8'd224: descending <= 37;
         8'd225: descending <= 1023;
         8'd226: descending <= 990;
         8'd227: descending <= 957;
         8'd228: descending <= 924;
         8'd229: descending <= 891;
         8'd230: descending <= 858;
         8'd231: descending <= 825;
         8'd232: descending <= 792;
         8'd233: descending <= 759;
         8'd234: descending <= 726;
         8'd235: descending <= 693;
         8'd236: descending <= 660;
         8'd237: descending <= 627;
         8'd238: descending <= 594;
         8'd239: descending <= 561;
         8'd240: descending <= 528;
         8'd241: descending <= 495;
         8'd242: descending <= 462;
         8'd243: descending <= 429;
         8'd244: descending <= 396;
         8'd245: descending <= 363;
         8'd246: descending <= 330;
         8'd247: descending <= 297;
         8'd248: descending <= 264;
         8'd249: descending <= 231;
         8'd250: descending <= 198;
         8'd251: descending <= 165;
         8'd252: descending <= 132;
         8'd253: descending <= 99;
         8'd254: descending <= 66;
         8'd255: descending <= 33;
      endcase
   end //always

endmodule //mel_filter
