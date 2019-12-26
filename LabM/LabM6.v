module labM;

reg clk, read, write;
reg [31:0] address, memIn;
wire [31:0] memOut;

mem data(memOut, address, memIn, clk, read, write);

initial
begin
	address = 128; write = 0; read = 1;
	repeat (11)
	begin
	#1;
		if (memOut[31:26] == 0)
			$display("%0d %0d %0d %0d %0d", memOut[31:26], memOut[25:21], memOut[20:16], memOut[15:11], memOut[5:0]);
		else if (memOut[31:26] == 2)
			$display("%0d %0d", memOut[31:26], memOut[25:0]);
		else
			$display("%0d %0d %0d %0d", memOut[31:26], memOut[25:21], memOut[20:16], memOut[15:0]);

		address = address + 4;
	end

	$finish;

end	
endmodule 
