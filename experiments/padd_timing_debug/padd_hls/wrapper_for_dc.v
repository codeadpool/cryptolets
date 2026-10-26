module l1_mod_mul_d7267ca0d90c7363_regin (clk, rst, x, y, z);
  input clk, rst;
  input [380:0] x, y;
  output [380:0] z;
  reg [380:0] x_q, y_q;
  always @(posedge clk) begin
    if (rst) begin x_q <= 381'b0; y_q <= 381'b0; end
    else begin x_q <= x; y_q <= y; end
  end
  FIXEDMUL_l1_mod_mul u (.clk(clk), .rst(rst), .x_rsc_dat(x_q), .y_rsc_dat(y_q),
    .z_rsc_dat(z), .x_triosy_lz(), .y_triosy_lz(), .z_triosy_lz());
endmodule
