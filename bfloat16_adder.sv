module bfloat16_adder (output logic [15:0] sum, output logic ready,
                      input logic [15:0] a, b, input logic clock, nreset);

logic sign_a, sign_b, sign_sum;
logic [7:0] exponent_a, exponent_b, exponent_sum; //shift_bit;
logic [8:0] mantissa_a, mantissa_b, mantissa_sum; //considering the implicit leading 1 & overflow


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
    ready = 1'b0; //when sum is ready, ready = 1;
    exponent_a = a [14:7];
    mantissa_a = {1'b0, 1'b1, a[6:0]};
    exponent_b = b [14:7];
    mantissa_b = {1'b0, 1'b1, b[6:0]};
    unique casez(present_state)
      check_format: begin // extract exponent & mantissa and check the input number format (NaN/infinity)
        if((exponent_a == 8'b11111111 && mantissa_a[6:0] != 7'b0) || (exponent_b == 8'b11111111 && mantissa_b[6:0] != 7'b0))
                        sign_sum = 1'b1;
                        exponent_sum = 8'b11111111;
                        mantissa_sum = 9'b111111111;
                        next_state = addition_end;
        else if((exponent_a == 8'b11111111 && mantissa_a[6:0] == 7'b0) || (exponent_b == 8'b11111111 && mantissa_b[6:0] == 7'b0))
                        sign_sum = 1'b0;
                        exponent_sum = 8'b11111111;
                        mantissa_sum = 9'b0;
                        next_state = addition_end;
        else
                        next_state = check_zero;
                    end
      check_zero: begin // check zero
        if(exponent_a == 8'b0 && mantissa_a[6:0] == 7'b0)
                      sign_sum = sign_b;
                      exponent_sum = exponent_b;
                      mantissa_sum = mantissa_b
                      next_state =  addition_end;
        else if(exponent_b == 8'b0 && mantissa_b[6:0] == 7'b0)
                      sign_sum = sign_a;
                      exponent_sum = exponent_a;
                      mantissa_sum = mantissa_a
                      next_state =  addition_end;
        else
                      next_state = check_exponent;                
                  end
      check_exponent: begin //
        if(exponent_a == exponent_b )
                         exponent_sum = exponent_a;
                         next_state = add_mantissa;
        else if(exponent_a > exponent_b)
                         mantissa_b = mantissa_b >> 1;
                         
        else //if(exponent_a < exponent_b) 
                         mantissa_a = mantissa_a >> 1;
                         
                         next_state = check_exponent;
                      end
      add_mantissa: begin //
        if(a[15]^b[15] == 1'b0)
                       exponent_sum = exponent_a;
                       mantissa_sum = mantissa_a + mantissa_b;
                       sign_sum = sign_a;
                       next_state = normalize_number;
        else 
          if(mantissa_a > mantissa_b)
                       exponent_sum = exponent_a;
                       mantissa_sum = mantissa_a - mantissa_b;
                       sign_sum = sign_a;
                       next_state = normalize_number;
          else if(mantissa_a < mantissa_b)
                       exponent_sum = exponent_a;
                       mantissa_sum = mantissa_b - mantissa_a;
                       sign_sum = sign_b;
                       next_state = normalize_number;
        else
                         
                         
          
                    end
      normalize_number:begin
                        if(mantissa_sum[7] = 1'b1)
                          
      check_
                          addition_end:                    
                      
     
  end  
     
endmodule
    
