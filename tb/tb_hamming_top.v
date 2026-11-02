`timescale 1ns/1ps
module tb_hamming_top;
    reg [7:0] ui;
    reg [7:0] uio;
    wire [7:0] uo;

    hamming_top dut (.ui(ui), .uo(uo), .uio(uio));

    always #5  uio[0] = ~uio[0];
    always #7  uio[1] = ~uio[1];
    always #11 uio[2] = ~uio[2];

    task send_byte(input [7:0] d);
        begin
            @(negedge uio[0]);
            ui = d;
            uio[4] = 1'b1;
            @(negedge uio[0]);
            uio[4] = 1'b0;
        end
    endtask

    initial begin
        ui = 0;
        uio = 8'b0;
        uio[3] = 1'b1;
        #40;
        uio[3] = 1'b0;

        send_byte(8'hA5);
        send_byte(8'h5A);
        send_byte(8'h3C);

        #500;
        $display("HAMMING TOP TEST COMPLETE");
        $finish;
    end
endmodule
