module bfloat16_adder (output logic [15:0] sum, output logic ready,
                      input logic [15:0] a, b, input logic clock, nreset);

//logic sign_a, sign_b, sign_sum;
logic [7:0] exponent_a, exponent_b, exponent_sum, shift_bit;
logic [8:0] mantissa_a, mantissa_b, mantissa_sum; //considering the implicit leading 1 & overflow
logic [31:0] sum32;


enum {check_format, check_zero, check_exponent, add_mantissa, normalize_number, check_over} present_state, next_state;

always_ff @(posedge clock, negedge nreset)
  begin: SEQ
   if(~nreset)
     present_state <= check_format;
   else
     present_state <= next_state;
  end
  
always_comb
  begin: COM
    ready = 1'b0;
    exponent_a = a [14:7];
    mantissa_a = {1'b0, 1'b1, a[6:0]};
    exponent_b = b [14:7];
    mantissa_b = {1'b0, 1'b1, b[6:0]};
    unique casez(present_state)
      check_format: begin // extract exponent & mantissa and check the input number format
                      ready = 1'b1;
                      if(exponent_a == 8'b11111111)
                        
                      else
                        next_state = check_zero;
                    end
      check_zero: begin
                    if(exponent_a == 8'b0 && mantissa_a[6:0] == 7'b0)
                      sum = b;
                      next_state =  ;
                    else if(exponent_b == 8'b0 && mantissa_b[6:0] == 7'b0)
                      sum = a;
                      next_state =  ;
                    else
                      next_state = check_exponent;                
                  end
      check_exponent: begin
                       if(exponent_a == exponent_b )
                         exponent_sum = exponent_a;
                         next_state = add_mantissa;
                       else if(exponent_a > exponent_b)
                         mantissa_b = mantissa_b >> 1;
                         
                       else if(exponent_a < exponent_b)
                         mantissa_a = mantissa_a >> 1;
                         
                       else
                         next_state = check_exponent;
                      end
      add_mantissa: begin
                     if(a[15]^b[15] == 1'b0)
                       
                       next_state = normalize_number;
                    end
      normalize_number:
      check_
                      
     
  end  
     
endmodule
    
