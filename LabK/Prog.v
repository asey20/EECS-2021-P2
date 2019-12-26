module client;
wire z;
reg[1:0] a, b;
integer flag, i, j;

Engine test(z, a, b);

initial
begin
	flag = $value$plusargs("a=%b", a);
	flag = $value$plusargs("a=%b", b);
	for (i = 0; i < 5; i = i + 1)
	begin
		for (j = 0; j < 5; j = j +1)
		begin
		a=i; b=j;
		#1;
		$display("a=%b, b=%b, z=%b", a, b, z);
		end
	end
	$finish;
end

endmodule
