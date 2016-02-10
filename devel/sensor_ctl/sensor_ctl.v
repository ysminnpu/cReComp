`timescale 1ns / 1ps
module sensor_ctl(
input clk,
input rst_32,
input [31:0] din_32,
input [0:0] wr_en_32,
input [0:0] rd_en_32,
output [31:0] dout_32,
output [0:0] full_32,
output [0:0] empty_32,
inout [0:0] sig_out
);
// //copy this instance to top module
//sensor_ctl sensor_ctl(
//.clk(bus_clk),
//.rst_32(!user_w_write_32_open && !user_r_read_32_open),
//.din_32(user_w_write_32_data),
//.wr_en_32(user_w_write_32_wren),
//.rd_en_32(user_r_read_32_rden),
//.dout_32(user_r_read_32_data),
//.full_32(user_w_write_32_full),
//.empty_32(user_r_read_32_empty),
//
// .sig_out(sig_out)
//);
parameter INIT_32 = 0,
	IDLE_32 = 1,
	READY_RCV_32 = 2,
	RCV_DATA_32_0 = 3,
	POSE_32	= 4,
	READY_SND_32 = 5,
	SND_DATA_32_0 = 6,
	CYCLE_END_32 = 7;
// state register
reg [2:0] state_32;

// for input fifo
wire [31:0] rcv_data_32;
reg rcv_en_32;
wire data_empty_32;
// for output fifo
wire [31:0] snd_data_32;
reg snd_en_32;
wire data_full_32;

////fifo 32bit
fifo_32x512 input_fifo_32(
	.clk(clk),
	.srst(rst_32),
	.din(din_32),
	.wr_en(wr_en_32),
	.full(full_32),
	.dout(rcv_data_32),
	.rd_en(rcv_en_32),
	.empty(data_empty_32)
	);
	
fifo_32x512 output_fifo_32(
	.clk(clk),
	.srst(rst_32),
	.din(snd_data_32),
	.wr_en(snd_en_32),
	.full(data_full_32),
	.dout(dout_32),
	.rd_en(rd_en_32),
	.empty(empty_32)
	);
//user wire
wire [0:0] busy_sensor;
wire [0:0] finish_sensor;


//for 32bbit FIFO
reg [31:0] req_in;
wire [31:0] sensor_data;


//instance for sonic_sensor
sonic_sensor uut(
.clk(clk),
.rst(rst_32),
.req(req_in),
.busy(busy_sensor),
.sig(sig_out),
.out_data(sensor_data),
.finish(finish_sensor)
);

always @(posedge clk)begin
	if(rst_32)
		state_32 <= 0;
	else
		case (state_32)
			INIT_32: 		state_32 <= IDLE_32;
/*idle state*/
			IDLE_32: 		state_32 <= READY_RCV_32;
			READY_RCV_32: if(data_empty_32 == 0) 	state_32 <= RCV_DATA_32_0;
/*read state*/
			RCV_DATA_32_0:  		state_32 <= POSE_32;
			POSE_32: 		if(busy_sensor==0 && finish_sensor) state_32 <= READY_SND_32;
			READY_SND_32: 	if(data_full_32 == 0)	state_32 <= SND_DATA_32_0;
/*write state*/
			SND_DATA_32_0: 		state_32 <= CYCLE_END_32;
			CYCLE_END_32:										state_32 <= IDLE_32;
	default: state <= INIT_32;
		endcase
end

/*read block for fifo_32*/

always @(posedge clk)begin
	if(rst_32)begin
/*user defined init*/
		req_in <= 0;
	end
	else if (rcv_en_32)begin
/*user defined rcv*/
		req_in <= rcv_data_32[31:0];
	end
	else begin
/*user defined init*/
		req_in <= 0;
	end
end

always @(posedge clk)begin
	if(rst_32)begin
		snd_en_32 <= 0;
		rcv_en_32 <= 0;
	end
	else case (state_32)
/*en action*/
			READY_RCV_32: if(data_empty_32 == 0) 	rcv_en_32 <= 1;
			POSE_32: rcv_en_32 <= 0;
			READY_SND_32: 	if(data_full_32 == 0)	snd_en_32 <= 1;
			SND_DATA_32_0: snd_en_32 <= 0;
	endcase
end


/*user assign*/
assign snd_data_32[31:0] = sensor_data;


endmodule