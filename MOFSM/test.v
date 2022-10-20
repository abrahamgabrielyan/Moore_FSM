`timescale 1 ns / 100 ps

module test();

localparam                 TOTAL_TESTS     = 1;
localparam                 CLK_HALF_PERIOD = 5;

reg                        clk;
reg                        rst;
reg                        in;
wire                       out;

integer                    passed_tests_count;
integer                    failed_tests_count;
integer                    skipped_tests_count;
realtime                   start_capture;
realtime                   end_capture;
realtime                   all_tests_end;

reg data_out;

initial
begin
    clk                 <= 1'b1;
    data_out            <= 1'b0;
    passed_tests_count  <= 0;
    failed_tests_count  <= 0;
    skipped_tests_count <= 0;
end

always
begin
    #CLK_HALF_PERIOD clk = ~clk;
end

task check_output;
begin
    @(posedge clk);
    start_capture = $realtime;

    $display("\nTest check_output started. (Testing properly working output).");

    rst = 1'b1;
    in = 1'b0;

    repeat(5)@(posedge clk);
    rst = 1'b0;
    #2;
    in = 1'b1;

    repeat(1)@(posedge clk);
    #2;
    in = 1'b0;

    repeat(1)@(posedge clk);
    #2;
    in = 1'b1;

    repeat(1)@(posedge clk);
    #2;
    in = 1'b1;

    @(posedge clk);
    #2;

    if(out)
    begin
        $display("Test 'check_output' PASSED.");
        passed_tests_count = passed_tests_count + 1;
    end else begin
        $display("Test 'check_output' FAILED.");
        failed_tests_count = failed_tests_count + 1;
    end

    $display("Test check_output ended.");
    end_capture = $realtime;
    $display("Time elapsed for this test: %t", end_capture - start_capture);
end
endtask //check_output

initial
begin
    $dumpvars;
    $timeformat(-9, 3, " ns", 10);
    $display("\nStarting tests...");

    check_output;

    if(passed_tests_count + failed_tests_count != TOTAL_TESTS)
    begin
        skipped_tests_count = TOTAL_TESTS - (passed_tests_count + failed_tests_count);
    end

    all_tests_end = $realtime;

    $display("\nTOTAL TESTS: %0d, PASSED: %0d, FAILED: %0d, SKIPPED: %0d.",
                TOTAL_TESTS, passed_tests_count, failed_tests_count, skipped_tests_count);
    $display("Time elapsed for all tests: %0t\n", all_tests_end);

    #15 $finish;
end //end of initial block

//instantiation of module 'mofsm'
mofsm mofsm (.clk(clk),
             .rst(rst),
             .a(in),
             .b(out));

endmodule //test
