module Engine(z, a);
output signed [31:0] z;
input signed [31:0] a;

wire[31:0] tmp;
wire cout;
wire cin;
assign cin = 0;
assign tmp[31:1] = a[30:0];
assign tmp[0] = 0;
yAdder adder(z, cout, tmp, a, cin);

endmodule
