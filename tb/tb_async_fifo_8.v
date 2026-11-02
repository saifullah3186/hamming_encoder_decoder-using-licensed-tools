`timescale 1ns/1ps
module tb_async_fifo_8;
    reg wr_clk=0, rd_clk=0, wr_rst=1, rd_rst=1;
    reg [7:0] wr_data;
    reg wr_en, rd_en;
    wire [7:0] rd_data;
    wire full, empty;

    async_fifo_8 dut (
        .wr_clk(wr_clk), .wr_rst(wr_rst), .wr_data(wr_data),
        .wr_en(wr_en), .full(full),
        .rd_clk(rd_clk), .rd_rst(rd_rst), .rd_data(rd_data),
        .rd_en(rd_en), .empty(empty)
    );

    always #5 wr_clk = ~wr_clk;
    always #7 rd_clk = ~rd_clk;

    task write_byte(input [7:0] d);
        begin
            @(posedge wr_clk);
            wr_data <= d;
            wr_en <= 1'b1;
            @(posedge wr_clk);
            wr_en <= 1'b0;
        end
    endtask

    initial begin
        wr_data=0; wr_en=0; rd_en=0;
        #30;
        wr_rst=0; rd_rst=0;

        write_byte(8'hA5);
        write_byte(8'h5A);
        write_byte(8'h12);
        write_byte(8'h34);

        repeat(8) @(posedge rd_clk);
        repeat(4) begin
            @(posedge rd_clk);
            rd_en <= 1'b1;
            @(posedge rd_clk);
            rd_en <= 1'b0;
            $display("FIFO READ = %02h", rd_data);
        end

        #30;
        $display("ASYNC FIFO 8 TEST COMPLETE");
        $finish;
    end
endmodule
