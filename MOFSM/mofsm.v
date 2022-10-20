module mofsm(
    input      clk,
    input      rst,
    input      a,
    output reg b);

localparam     STATE_0 = 3'b000;
localparam     STATE_1 = 3'b001;
localparam     STATE_2 = 3'b011;
localparam     STATE_3 = 3'b010;
localparam     STATE_4 = 3'b110;

reg [2 : 0]    current_state;
reg [2 : 0]    next_state;

always@(*)
begin
    b = current_state == STATE_4 ? 1'b1 : 1'b0;
end

always@(posedge clk, posedge rst)
begin
    if(rst == 1'b1)
    begin
        current_state <= STATE_0;
    end else begin
        current_state <= next_state;
    end
end

always@(posedge clk)
begin
    case(current_state)
    STATE_0:
    begin
        if(a == 1)
        begin
            next_state = STATE_1;
        end else begin
            next_state = STATE_0;
        end
    end

    STATE_1:
    begin
        if(a == 0)
        begin
            next_state = STATE_2;
        end else begin
            next_state = STATE_1;
        end
    end

    STATE_2:
    begin
        if(a == 0)
        begin
            next_state = STATE_1;
        end else begin
            next_state = STATE_3;
        end
    end

    STATE_3:
    begin
        if(a == 0)
        begin
            next_state = STATE_2;
        end else begin
            next_state = STATE_4;
        end
    end

    STATE_4:
    begin
        if(a == 0)
        begin
            next_state = STATE_1;
        end else begin
            next_state = STATE_2;
        end
    end

    default:
    begin
        next_state = STATE_0;
    end
    endcase
end
endmodule
