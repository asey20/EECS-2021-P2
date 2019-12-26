
module LabL;

reg [31:0]  a, b, expect;
reg c;
wire [31:0]  z;
yMux #(32)  mux(z, a, b, c);

initial
begin

	repeat (500)
	begin
		a = $random;
		b = $random;
		c = $random % 2;
		
		expect = c ? b : a;
		#1;

		if (z !== expect)
			$display("FAIL: a=%b b=%b c=%b z=%b", a, b, c, z);	
	end

$finish;

end

endmodule
