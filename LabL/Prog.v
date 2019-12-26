module Prog;

   reg  [31:0] a, expect;
   reg         cin;
   wire [31:0] z;
   wire        cout;

   Engine engine(z,a);

   initial
     begin
  
          begin
             a = $random;

             expect = a*3;

             #1; // wait for z
             if (expect === z)
               $display("PASS: a=%d \n  b=%d \n   z=%d",a,b,  z);
             else
               $display("FAIL: a=%d \n     z=%d \n expect=%d" a, z, expect);

          //end
        $finish;
     end

endmodule // LabL



