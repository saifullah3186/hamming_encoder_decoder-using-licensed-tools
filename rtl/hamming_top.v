`timescale 1ns/1ps
module hamming_top(
    input  wire [7:0] ui,
    output wire [7:0] uo,
    input  wire [7:0] uio
);
    wire clk_in     = uio[0];
    wire clk_core   = uio[1];
    wire clk_out    = uio[2];
    wire reset      = uio[3];
    wire input_valid = uio[4];
    wire mode       = uio[5];
    wire output_ready = uio[6];
    wire error_inject = uio[7];

    wire [7:0] fifo_in_data;
    wire fifo_in_full, fifo_in_empty;
    wire [7:0] core_data;
    wire [12:0] codeword;
    wire [12:0] fifo_out_data;
    wire fifo_out_full, fifo_out_empty;
    wire [7:0] decoded_data;
    wire single_error, double_error;

    wire fifo_in_rd = !fifo_in_empty;
    wire fifo_out_wr = !fifo_out_full && !fifo_in_empty;
    wire [12:0] injected_codeword = codeword ^ (error_inject ? 13'b0000000000001 : 13'b0);

    async_fifo_8 u_fifo_in (
        .wr_clk(clk_in), .wr_rst(reset),
        .wr_data(ui), .wr_en(input_valid),
        .full(fifo_in_full),
        .rd_clk(clk_core), .rd_rst(reset),
        .rd_data(core_data), .rd_en(fifo_in_rd),
        .empty(fifo_in_empty)
    );

    hamming_encoder_13_8 u_encoder (
        .data_in(core_data),
        .codeword(codeword)
    );

    hamming_decoder_13_8 u_decoder (
        .codeword_in(injected_codeword),
        .data_out(decoded_data),
        .single_error(single_error),
        .double_error(double_error)
    );

    async_fifo_13 u_fifo_out (
        .wr_clk(clk_core), .wr_rst(reset),
        .wr_data({decoded_data, single_error, double_error, 3'b000}),
        .wr_en(fifo_out_wr),
        .full(fifo_out_full),
        .rd_clk(clk_out), .rd_rst(reset),
        .rd_data(fifo_out_data), .rd_en(output_ready),
        .empty(fifo_out_empty)
    );

    assign uo[3:0] = fifo_out_data[12:9];
    assign uo[4]   = fifo_out_data[8];
    assign uo[5]   = fifo_out_data[7];
    assign uo[6]   = fifo_out_data[6];
    assign uo[7]   = fifo_out_data[5];

endmodule
