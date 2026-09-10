
module washing_machine (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire       water_full,
    input  wire       water_empty,

    output reg        water_valve,
    output reg        motor,
    output reg        drain_pump,
    output reg     

   spin,
    output reg        done
);

    // State definitions
    localparam IDLE  = 3'b000;
    localparam FILL  = 3'b001;
    localparam WASH  = 3'b010;
    localparam DRAIN = 3'b011;
    localparam RINSE = 3'b100;
    localparam SPIN  = 3'b101;
    localparam DONE  = 3'b110;

    reg [2:0] state;
    reg [3:0] count;

    // State register and timer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    count <= 0;
                    if (start)
                        state <= FILL;
                end

                FILL: begin
                    count <= 0;
                    if (water_full)
                        state <= WASH;
                end

                WASH: begin
                    if (count == 4'd5) begin
                        count <= 0;
                        state <= DRAIN;
                    end
                    else
                        count <= count + 1;
                end

                DRAIN: begin
                    count <= 0;
                    if (water_empty)
                        state <= RINSE;
                end

                RINSE: begin
                    if (count == 4'd5) begin
                        count <= 0;
                        state <= SPIN;
                    end
                    else
                        count <= count + 1;
                end

                SPIN: begin
                    if (count == 4'd5) begin
                        count <= 0;
                        state <= DONE;
                    end
                    else
                        count <= count + 1;
                end

                DONE: begin
                    count <= 0;
                    if (!start)
                        state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

    // Output control
    always @(*) begin

        water_valve = 1'b0;
        motor       = 1'b0;
        drain_pump  = 1'b0;
        spin        = 1'b0;
        done        = 1'b0;

        case (state)

            IDLE: begin
                // All outputs OFF
            end

            FILL: begin
                water_valve = 1'b1;
            end

            WASH: begin
                motor = 1'b1;
            end

            DRAIN: begin
                drain_pump = 1'b1;
            end

            RINSE: begin
                motor = 1'b1;
            end

            SPIN: begin
                spin = 1'b1;
                motor = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

        endcase
    end

endmodule
