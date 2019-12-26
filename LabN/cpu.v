module yMux1(z, a, b, c);

	output z;
	input a, b, c;
	wire notC, upper, lower;
   
	not my_not(notC, c);
	and upperAnd(upper, a, notC);
	and lowerAnd(lower, c, b);
	or my_or(z, upper, lower);
   
endmodule

module yMux(z, a, b, c);
   
	parameter SIZE = 2;
	output [SIZE-1:0] z;
	input [SIZE-1:0] a, b;	
	input c;
   
	yMux1 mine[SIZE-1:0] (z, a, b, c);
   
endmodule

module yMux4to1(z, a0, a1, a2, a3, c);

	parameter SIZE = 2;
	output [SIZE-1:0] z;
	input [SIZE-1:0] a0, a1, a2, a3;
	input [1:0] c;
	wire [SIZE-1:0] zLo, zHi;
   
	yMux #(SIZE) lo(zLo, a0, a1, c[0]);
	yMux #(SIZE) hi(zHi, a2, a3, c[0]);
	yMux #(SIZE) final(z, zLo, zHi, c[1]);
   
endmodule

module yAdder1(z, cout, a, b, cin);

	output z, cout;
	input a, b, cin;
	wire tmp, outL, outR;

	xor left_xor(tmp, a, b);
	xor right_xor(z, cin, tmp);
	and left_and(outL, a, b);
	and right_and(outR, tmp, cin);
	or my_or(cout, outR, outL);

endmodule

module yAdder(z, cout, a, b, cin);

	output [31:0] z;
	output cout;
	input [31:0] a, b;
	input cin;
	wire [31:0] in, out;
	
	yAdder1 mine[31:0] (z, out, a, b, in);
	
	assign in[0] = cin;
	assign in[31:1] = out[30:0];
	assign cout = out[31];

endmodule

module yArith(z, cout, a, b, ctrl);

	output [31:0] z;
	output cout;
	input [31:0] a, b;
	input ctrl;
	wire [31:0] notB, tmp;
	wire cin;
	
	not my_not[31:0] (notB, b);
	yMux #(32) my_mux1(tmp, b, notB, ctrl);
	yAdder my_adder(z, cout, a, tmp, cin);
	assign cin = ctrl;
	
endmodule

module yAlu(z, zero, a, b, op);
   
	input [31:0] a, b;
	input [2:0] op;
	output [31:0] z;
	output zero;
	wire [31:0] andout, orout, Arithout, slt, tmp;
	wire [15:0] z16;
	wire [7:0] z8;
	wire [3:0] z4;
	wire [1:0] z2;
	wire cout1, cout2, z1;
   
	assign slt[31:1] = 0;
	   
	xor my_xor(condition, a[31], b[31]);
	yArith my_Arith1(tmp, cout1, a, b, 1);
	yMux #(1) mux2(slt[0], tmp[31], a[31], condition); 
	   
	and my_and[31:0] (andout, a, b);
	or my_or[31:0] (orout, a, b);
	yArith my_Arith2(Arithout, cout2, a, b, op[2]);
	yMux4to1 #(32) my_Mux(z, andout, orout, Arithout, slt, op[1:0]);
	   
	or or16[15:0] (z16, z[15:0], z[31:16]);
	or or8[7:0] (z8, z16[7:0], z16[15:8]);
	or or4[3:0] (z4, z8[3:0], z[7:4]);
	or or2[1:0] (z2, z4[3:2], z4[1:0]);
	or or1(z1, z2[1], z2[0]);
	not not1(zero, z1);
	   
endmodule

module yIF(ins, PCp4, PCin, clk);

	output [31:0] ins, PCp4;
	input [31:0] PCin;
	input clk;
	wire [31:0] address, memIn;
	wire zero;
	   
	register #(32) PC(address, PCin, clk, 1);
	mem intructions(ins, address, memIn, clk, 1, 0);
	yAlu add4(PCp4, zero, address, 4, 010);
	
endmodule

module yID(rd1, rd2, imm, jTarget, ins, wd, RegDst, RegWrite, clk);

	output [31:0] rd1, rd2, imm;
	output [25:0] jTarget;
	input [31:0] ins, wd;
	input RegDst, RegWrite, clk;
	wire [15:0] zeros, ones;
	wire [4:0] rn1, rn2, rd, wn;
	   
	assign zeros = 16'h0000;
	assign ones = 16'hffff;
	   
	assign rn1 = ins[25:21];
	assign rn2 = ins[20:16];
	assign rd = ins[15:11];
	assign jTarget = ins[25:0];
	   
	assign imm[15:0] = ins[15:0];
	yMux #(16) se(imm[31:16], zeros, ones, ins[15]);
	   
	yMux #(5) wAddress(wn, rn2, rd, RegDst);
	   
	rf RF(rd1, rd2, rn1, rn2, wn, wd, clk, RegWrite);
	   
endmodule

module yEX(z, zero, rd1, rd2, imm, op, ALUSrc);
	
	output [31:0] z;
	output zero;
	input [31:0] rd1, rd2, imm;
	input [2:0] op;
	input ALUSrc;
	wire [31:0] B;
	wire zero;
	   
	yMux #(32) srcB(B, rd2, imm, ALUSrc);
	yAlu main_Alu(z, zero, rd1, B, op);
	   
endmodule

module yDM(memOut, exeOut, rd2, clk, memRead, memWrite);

	output [31:0] memOut;
	input [31:0] exeOut, rd2;
	input clk, memRead, memWrite;
	   
	mem DateMem(memOut, exeOut, rd2, clk, memRead, memWrite);
	
	endmodule
	
	module yWB(wb, exeOut, memOut, Mem2Reg);
	output [31:0] wb;
	input [31:0] exeOut, memOut;
	input Mem2Reg;
	   
	yMux #(32) mux_wb(wb, exeOut, memOut, Mem2Reg);
	   
endmodule

module yPC(PCin, PCp4, INT, entryPoint, imm, jTarget, zero, branch, jump);

	output [31:0] PCin;
	input [31:0] PCp4, entryPoint, imm;
	input [25:0] jTarget;
	input INT, zero, branch, jump;
	wire [31:0] immX4, bTarget, choiceA, jAddress, choiceB;
	wire doBranch, zf;
	   
	assign immX4[31:2] = imm[29:0];
	assign immX4[1:0] = 2'b00;
	yAlu myALU(bTarget, zf, PCp4, immX4, 3'b010);
	and (doBranch, branch, zero);
	yMux #(32) mux1(choiceA, PCp4, bTarget, doBranch);
	   
	assign jAddress[31:28] = PCp4[31:28];
	assign jAddress[27:2] = jTarget;
	assign jAddress[1:0] = 2'b00;
	yMux #(32) mux2(choiceB, choiceA, jAddress, jump);
	   
	yMux #(32) mux3(PCin, choiceB, entryPoint, INT);
	   
endmodule

module yC1(rtype, lw, sw, jump, branch, opCode);

	output rtype, lw, sw, jump, branch;
	input [5:0] opCode;
	wire not0, not1, not2, not3, not4, not5;
	wire lw, sw, branch, jump, rtype;
	   
	not (not0, opCode[0]);
	not (not1, opCode[1]);
	not (not2, opCode[2]);
	not (not3, opCode[3]);
	not (not4, opCode[4]);
	not (not5, opCode[5]);
	   
	and (lw, opCode[0], opCode[1], not2, not3, not4, opCode[5]);
	and (sw, opCode[0], opCode[1], not2, opCode[3], not4, opCode[5]);
	and (branch, not0, not1, opCode[2], not3, not4, not5);
	and (jump, not0, opCode[1], not2, not3, not4, not5);
	and (rtype, not0, not1, not2, not3, not4, not5);
	   
endmodule

module yC2(RegDst, ALUSrc, RegWrite, Mem2Reg, MemRead, MemWrite, rtype, lw, sw, branch);

	output RegDst, ALUSrc, RegWrite, Mem2Reg, MemRead, MemWrite;
	input rtype, lw, sw, branch;
	   
	assign RegDst = rtype;
	nor (ALUSrc, rtype, branch);
	nor (RegWrite, sw, branch);
	assign Mem2Reg = lw;
	assign MemRead = lw;
	assign MemWrite = sw;
	   
endmodule

module yC3(ALUop, rtype, branch);

	output [1:0] ALUop;
	input rtype, branch;
	   
	assign ALUop[0] = branch;
	assign ALUop[1] = rtype;
	   
endmodule

module yC4(op, ALUop, fnCode);

	output [2:0] op;
	input [5:0] fnCode;
	input [1:0] ALUop;
	wire op0temp, op2temp;
	   
	or (op0temp, fnCode[0], fnCode[3]);
	and (op[0], op0temp, ALUop[1]);
	nand (op[1], fnCode[2], ALUop[1]);
	and (op2temp, fnCode[1], ALUop[1]);
	or (op[2], op2temp, ALUop[0]);
	   
endmodule
   
module yChip(ins, rd2, wb, entryPoint, INT, clk);

	output [31:0] ins, rd2, wb;
	input [31:0] entryPoint;
	input INT, clk;
	wire [31:0] PCin, wd, rd1, imm, PCp4, z, memOut;
	wire [25:0] jTarget;
	wire [5:0] opCode, fnCode;
	wire [2:0] op;
	wire [1:0] ALUop;
	wire zero, rtype, lw, sw, jump, branch, RegDst, ALUSrc, RegWrite, Mem2Reg, MemRead, MemWrite;
	   
	yPC myPC(PCin, PCp4, INT, entryPoint, imm, jTarget, zero, branch, jump);
	yIF myIF(ins, PCp4, PCin, clk);
	yID myID(rd1, rd2, imm, jTarget, ins, wd, RegDst, RegWrite, clk);
	yEX myEX(z, zero, rd1, rd2, imm, op, ALUSrc);
	yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite);
	yWB myWB(wb, z, memOut, Mem2Reg);
	assign wd = wb;
	   
	assign opCode = ins[31:26];
	yC1 myC1(rtype, lw, sw, jump, branch, opCode);
	yC2 myC2(RegDst, ALUSrc, RegWrite, Mem2Reg, MemRead, MemWrite, rtype, lw, sw, branch);
	               
	assign fnCode = ins[5:0];
	yC3 myC3(ALUop, rtype, branch);
	yC4 myC4(op, ALUop, fnCode);
	   
endmodule

