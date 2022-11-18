module bfloat16_adder_behav (output logic [15:0] sum, output logic ready,
                      input logic [15:0] a, b, input logic clock, nreset);
                     
// bfloat16 is the same as shortreal, but without the last 16 bits of the mantissa
// Therefore, in order to check the functionality, we will use shortreal arithmetic

shortreal rsum, ra, rb; // shortreal is 32 bit floating point
logic [31:0] sum32 , a32, b32;

enum {waiting, running} state;

always @(*)
  begin
  sum32 = $shortrealtobits(rsum); // converts real to bits
  sum = sum32[31:16];
  end
  
always @(*)
  begin
  a32 = {a, {16{1'b0}}};
  b32 = {b, {16{1'b0}}};
  ra = $bitstoshortreal(a32); // converts bits to real
  rb = $bitstoshortreal(b32);
  end

always @(posedge clock, negedge nreset)

if (~nreset)
  begin
  rsum <= 0;
  ready <= '0;
  end
else
  begin
  ready <= '1;
  rsum <= rb + ra;
  end

  
endmodule

