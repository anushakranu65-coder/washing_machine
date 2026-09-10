

module tb_washing_machine;

    reg clk;
    reg reset;
    reg start;
    reg water_full;
    reg water_empty;

    wire water_valve;
    wire motor;
    wire drain_pump;
    wire spin;
    wire done;

    washing_machine DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .water_full(water_full),
        .water_empty(water_empty),
        .water_valve(water_valve),
        .motor(motor),
        .drain_pump(drain_pump),
        .spin(spin),
        .done(done)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk         = 0;
        reset       = 1;
        start       = 0;
        water_full  = 0;
        water_empty = 1;

        // Reset
        #20;
        reset = 0;

        // Start washing machine
        #10;
        start = 1;

        // Water filling
        #30;
        water_full = 1;
        water_empty = 0;

        // WASH
        #80;

        // Drain water
        water_full  = 0;
        water_empty = 1;

        // RINSE
        #80;

        // Drain again
        water_empty = 1;

        // Wait for spin and completion
        #100;

        // Stop/start released
        start = 0;

        #30;

        $stop;

    end

endmodule
