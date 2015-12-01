`timescale 1ns / 1ps


//this code was generated by cReComp
module adder(

input [0:0] clk,


input [0:0] rst,
input [0:0] req,
output [0:0] busy,
output [0:0] finish,

input [3:0] para_0,
input [3:0] para_1,
output [7:0] result
);

// //copy this instance to top module
//adder adder
//(
//.clk(bus_clk),
// .rst(rst),
// .req(req),
// .busy(busy),
// .finish(finish)
// .rst(rst),
// .para_0(para_0),
// .para_1(para_1),
// .result(result)
//);
parameter INIT 	= 0, 
		READY 	= 1,
		PROCESS = 2,
		FINISH 	= 3;

reg [3:0] hs_state;
reg finish_flag;
reg [7:0] result_;

//for handshake control
always @(posedge clk) begin
	if (rst)
		hs_state <= INIT;
	else
		case (hs_state)
			INIT:					hs_state <= READY;
			READY:		if(req)		hs_state <= PROCESS;
			PROCESS:	if(finish_flag)hs_state <= FINISH;
			FINISH:					hs_state <= READY;
		endcase
end

assign busy = (hs_state == PROCESS);
assign finish = (finish_flag == 1);

always @(posedge clk) begin
	if (rst) begin
/*user define port*/
		finish_flag <= 0;
	end
	else if (hs_state == PROCESS) begin
/*user define process*/	
		result_ = para_0 + para_1;
		finish_flag <= 1;
	end
	else if (hs_state == FINISH) begin
/*user define finish action*/
		finish_flag <= 0;
	end
	else begin
/*user define action*/	
	end
end

assign result = result_;

endmodule
