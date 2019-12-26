module Engine(z, a, b);
output z;
input [1:0] a, b;
output aa, bb, nbb;
	
	not (nb, b[0]);
	and (z, a[0], nb);
	
	

	//assign z = (a > b) ? 1 : 0; 

endmodule
