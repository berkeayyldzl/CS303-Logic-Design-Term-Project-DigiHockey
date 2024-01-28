`timescale 1ns / 1ps

module top_module(
    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output LEDA,
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,
    output b_out,
    output c_out,
    output d_out,
    output e_out,
    output f_out,
    output g_out,
    output p_out,
    output [7:0] an
);

    wire [6:0] ssd0,ssd1,ssd2,ssd3,ssd4,ssd5,ssd6,ssd7;
    wire btna_clean_out;
    wire btnb_clean_out;

  
  clk_divider clk_div_inst (
    .clk_in(clk),
    .rst(rst),
    .divided_clk(divided_clk)
  );

  debouncerA debouncerA_inst (
    .clk(divided_clk),
    .rst(rst),
    .noisy_in(BTNA),
    .clean_out(btna_clean_out)
  );

  debouncerB debouncerB_inst (
    .clk(divided_clk),
    .rst(rst),
    .noisy_in(BTNB),
    .clean_out(btnb_clean_out) 
  );

  ssd ssd_inst (
    .clk(clk),
    .rst(rst),
    .SSD7(ssd7),
    .SSD6(ssd6),
    .SSD5(ssd5),
    .SSD4(ssd4),
    .SSD3(ssd3),
    .SSD2(ssd2),
    .SSD1(ssd1),
    .SSD0(ssd0),

    .a_out(a_out),
    .b_out(b_out),
    .c_out(c_out),
    .d_out(d_out),
    .e_out(e_out),
    .f_out(f_out),
    .g_out(g_out),
    .p_out(p_out),
    .an(an)
  );

  hockey hockey_inst (
    .clk(divided_clk),
    .rst(rst),
    .BTNA(btna_clean_out),
    .BTNB(btnb_clean_out),
    .DIRA(DIRA),
    .DIRB(DIRB),
    .YA(YA),
    .YB(YB),
    .LEDA(LEDA),
    .LEDB(LEDB),
    .LEDX(LEDX),
    .SSD7(ssd7),
    .SSD6(ssd6),
    .SSD5(ssd5),
    .SSD4(ssd4),
    .SSD3(ssd3),
    .SSD2(ssd2),
    .SSD1(ssd1),
    .SSD0(ssd0)
  );

endmodule