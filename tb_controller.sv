`timescale 1ns/1ps;
module tb_mem_controller;
    logic clk = 0;
    logic rst_n;
    logic wr;
    logic rd;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic done;

    ram_controller_top dut (.*);

    // Тактовый генератор
    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        wr = 0;
        rd = 0;
        data_in = 8'h00;
        #100;
        #12 rst_n = 1;                // снимаем общий сброс

        // ----- Три операции записи (адреса 0,1,2) -----
        @(posedge clk);
        wr <= 1; data_in <= 8'hAA;
        @(posedge clk);               // запись AA по addr=0
        wr <= 0;
        $display("Write 0xAA");

        @(posedge clk);
        wr <= 1; data_in <= 8'hBB;
        @(posedge clk);               // запись BB по addr=1
        wr <= 0;
        $display("Write 0xBB");

        @(posedge clk);
        wr <= 1; data_in <= 8'hCC;
        @(posedge clk);               // запись CC по addr=2
        wr <= 0;
        $display("Write 0xCC");

        // Сброс адреса (память не сбрасывается)
        rst_n = 0;
        #20;
        rst_n = 1;
        @(posedge clk);               // теперь addr=0

        // ----- Первое чтение (ожидаем AA) -----
        rd = 1;
        @(posedge clk);               // переход в READ, RAM выдаёт mem[0]=AA
        #2;
        $display("Read data_out = 0x%02h (expected 0xAA)", data_out);
        rd = 0;
        @(posedge clk);               // возврат в IDLE, addr становится 1

        // ----- Второе чтение (ожидаем BB) -----
        rd = 1;
        @(posedge clk);               // RAM выдаёт mem[1]=BB
        #2;
        $display("Read data_out = 0x%02h (expected 0xBB)", data_out);
        rd = 0;
        @(posedge clk);               // addr становится 2

        // ----- Третье чтение (ожидаем CC) -----
        rd = 1;
        @(posedge clk);               // RAM выдаёт mem[2]=CC
        #2;
        $display("Read data_out = 0x%02h (expected 0xCC)", data_out);
        rd = 0;
        @(posedge clk);               // addr становится 3

        #20 $finish;
    end
endmodule