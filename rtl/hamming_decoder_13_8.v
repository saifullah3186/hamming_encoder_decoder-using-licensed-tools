`timescale 1ns/1ps
module hamming_decoder_13_8 (
    input wire [12:0] codeword_in,
    output reg [7:0] data_out,
    output reg single_error,
    output reg double_error
);
    reg [3:0] syndrome;
    reg parity;

    reg [12:0] corrected;

    always @* begin
        syndrome[0] = codeword_in[0] ^ codeword_in[2] ^
                      codeword_in[4] ^ codeword_in[6] ^
                      codeword_in[8] ^ codeword_in[10];

        syndrome[1] = codeword_in[1] ^ codeword_in[2] ^
                      codeword_in[5] ^ codeword_in[6] ^
                      codeword_in[9] ^ codeword_in[10];

        syndrome[2] = codeword_in[3] ^ codeword_in[4] ^
                      codeword_in[5] ^ codeword_in[6] ^
                      codeword_in[11];

        syndrome[3] = codeword_in[7] ^ codeword_in[8] ^
                      codeword_in[9] ^ codeword_in[10] ^
                      codeword_in[11];

        parity = ^codeword_in;
        corrected = codeword_in;

        single_error = 1'b0;
        double_error = 1'b0;

        if (parity) begin
            if (syndrome != 0) begin
                corrected[syndrome-1] = ~corrected[syndrome-1];
                single_error = 1'b1;
            end
            else begin
                corrected[12] = ~corrected[12];
                single_error = 1'b1;
            end
        end
        else if (syndrome != 0) begin
            double_error = 1'b1;
        end

        data_out[0] = corrected[2];
        data_out[1] = corrected[4];
        data_out[2] = corrected[5];
        data_out[3] = corrected[6];
        data_out[4] = corrected[8];
        data_out[5] = corrected[9];
        data_out[6] = corrected[10];
        data_out[7] = corrected[11];
    end
endmodule
