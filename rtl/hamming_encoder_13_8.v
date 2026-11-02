`timescale 1ns/1ps
module hamming_encoder_13_8 (
    input wire [7:0] data_in,
    output reg [12:0] codeword
);
    always @* begin
        codeword = 13'b0;
        codeword[2]  = data_in[0];
        codeword[4]  = data_in[1];
        codeword[5]  = data_in[2];
        codeword[6]  = data_in[3];
        codeword[8]  = data_in[4];
        codeword[9]  = data_in[5];
        codeword[10] = data_in[6];
        codeword[11] = data_in[7];

        codeword[0] = codeword[2] ^ codeword[4] ^ codeword[6] ^
                      codeword[8] ^ codeword[10];
        codeword[1] = codeword[2] ^ codeword[5] ^ codeword[6] ^
                      codeword[9] ^ codeword[10];
        codeword[3] = codeword[4] ^ codeword[5] ^ codeword[6] ^
                      codeword[11];
        codeword[7] = codeword[8] ^ codeword[9] ^ codeword[10] ^
                      codeword[11];

        codeword[12] = ^codeword[11:0];
    end
endmodule
