module labK;
reg a, b;
wire tmp, z;

not my_not(notOutput, b);
and my_and(z, a, lowerInput);
assign lowerInput = notOutput;

initial
begin
	a = 1; b = 1; 
	#1 $display("a=%b b=%b z=%b", a, b, z);
	$finish;
end

endmodule
