module LabK;

reg a, b, c;
wire notOutput, lowerInput;
wire UpperAndOut, UpperAndIn;
wire LowerAndOut, LowerAndIn;

not (notOutput, c);
and (UpperAndOut, a, lowerInput);
and (LowerAndOut, c, b);
or (z, UpperAndIn, LowerAndIn);

assign lowerInput = notOutput;
assign UpperAndIn = UpperAndOut;
assign LowerAndIn = LowerAndOut;

initial
begin
	a = 1; b = 0; c = 0;
	#1;
	$display("a=%b b=%b c=%b z=%b", a, b, c, z);
	$finish;
end


endmodule
