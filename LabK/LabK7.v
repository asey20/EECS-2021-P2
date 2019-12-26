module LabK;

reg a, b, c, flag;

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
	flag = $value$plusargs("a=%b", a);
	if (flag === 0) 
		$display("argument a is missing!");
 
	flag = $value$plusargs("b=%b", b);
	if (flag === 0)
		$display("argument b is missing!");
  
	flag = $value$plusargs("c=%b", c);
	if (flag === 0) 
			$display("argument c is missing!");
 
	#1 $display("a=%b b=%b c=%b z=%b", a, b, c, z);
	$finish;
end


endmodule
