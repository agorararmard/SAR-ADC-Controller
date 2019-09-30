// file: controller.v
// author: @amrgouhar

`timescale 1ns/1ns

module controller(go, clk, rst, cmp, sample, value, result, valid);
    parameter NOB = 8;
    
    input go;
    input clk;
    input rst;
    input [1:0]cmp;
    output reg sample;
    output reg valid;
    output reg [NOB-1:0]value;
    output reg [NOB-1:0] result;
    
    reg [NOB-1:0] first;
    reg [NOB-1:0] last;
    
    wire [NOB-1:0] mid = first + ((last-first) >> 1);
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            value <= {NOB{1'b0}};
            result <= {NOB{1'b0}};
            first <= {NOB{1'b0}};
            last <= {NOB{1'b1}};
            valid <= 1'b0;
            sample <= 1'b0;
        end
        else begin
            if(go) begin
                value <= mid;
                result <= {NOB{1'b0}};
                first <= {NOB{1'b0}};
                last <= {NOB{1'b1}};
                valid <= 1'b0;
                sample <= 1'b1;
            end
            else begin
            
                case(cmp)
                    2'b00:              //mid > result
                        begin
                            valid <= 1'b0;
                            last <= value;
                            value <= mid;
                        end
                    2'b01:
                        begin
                            valid <= 1'b0;
                            first <= value;
                            value <= mid;
                        end
                    default:
                        begin
                            valid <=1'b1;
                            result <= value;
                        end
                endcase
            end
        end
    end
    
endmodule

