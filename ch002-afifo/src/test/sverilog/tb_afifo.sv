module tb_afifo;

    logic reset_complete = '0;
    logic [2:0] wr_data, rd_data;
    logic wr_push, rd_pop;

    logic wr_clock = '0;
    initial forever #2ns wr_clock = ~ wr_clock;
    logic rd_clock = '0;
    initial forever #3ns rd_clock = ~ rd_clock;

    logic wr_reset = '1;
    logic rd_reset = '1;
    initial begin
        #10ns;
        wr_reset = '0;
        rd_reset = '0;
        #50ns;
        reset_complete = '1;
    end
    initial begin
    end

    always_ff @(posedge wr_clock or posedge wr_reset) begin
        if (wr_reset) begin
            wr_push <= '0;
            wr_data <= '0;
        end
        else if (reset_complete) begin
            wr_push <= $random();
            wr_data <= $random();
        end
    end

    always_ff @(posedge rd_clock or posedge rd_reset) begin
        if (rd_reset) begin
            rd_pop <= '0;
        end
        else if (reset_complete) begin
            rd_pop <= $random();
        end
    end

    logic wr_full, rd_empty;
    logic rd_underflow, rd_valid;
    logic wr_overflow, wr_ack;

    AsyncFIFO fifo ( .* );

    logic [3:0] fifo_rd_data;
    logic fifo_wr_full, fifo_rd_empty;
    logic fifo_rd_underflow, fifo_rd_valid;
    logic fifo_wr_overflow, fifo_wr_ack;

    xilinx_bram_fifo xilinx_fifo (
        .wr_clk         (wr_clock),
        .wr_rst         (wr_reset),
        .rd_clk         (rd_clock),
        .rd_rst         (rd_reset),
        .din            (wr_data),
        .wr_en          (wr_push),
        .rd_en          (rd_pop),
        .dout           (fifo_rd_data),
        .full           (fifo_wr_full),
        .almost_full    (),
        .wr_ack         (fifo_wr_ack),
        .overflow       (fifo_wr_overflow),
        .empty          (fifo_rd_empty),
        .almost_empty   (),
        .valid          (fifo_rd_valid),
        .underflow      (fifo_rd_underflow),
        .rd_data_count  (),
        .wr_data_count  ()
    );

endmodule
