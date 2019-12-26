
module LabL;

reg [31:0]  a0, a1, a2, a3,  expect;
reg [1:0] c;
wire [31:0]  z;
yMux4to1 #(32)  mux(z, a0, a1, a2, a3, c);

initial
begin

	repeat (500)
	begin
		a0 = $random;
		a1 = $random;
		a2 = $random;
		a3 = $random;
		c = $random % 4;
		
		if (c === 0)
		expect = a0;
		else if (c === 1)
		expect = a1;
		else if (c === 2)
		expect = a2;
		else 
		expect = a3;

		#1;

		if (z !== expect)
			$display("FAIL: a0=%b a1=%b a2=%b a3=%b c=%b  z=%b", a0, a1, a2, a3, c, z);	
	end

$finish;

end

endmodule
