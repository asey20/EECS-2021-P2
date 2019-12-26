module LabL;

reg signed [31:0] a, b, expect;
reg ctrl;
wire signed [31:0] z;
wire cout;

yAdder arith(z, cout, a, b, ctrl);

initial
begin

	repeat(10)
	begin

	a = $random;
	b = $random;
	ctrl = $random % 2;

	expect = ctrl ? (a - b) : (a + b);
	
	#1;

	if (expect === z)
		$display("PASS: a=%b b=%b ctrl=%b z=%b expect=%b", a, b, ctrl, z, expect);
	else
		$display("FAIL: a=%b b=%b ctrl=%b z=%b expect=%b", a, b, ctrl, z, expect);

	end

	$finish;
end

endmodule
