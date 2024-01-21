#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <Vpxmat_tn9k.h>

#define MAX_TIME 5000000

vluint64_t sim_time = 0;
u_int8_t reset_pulse_width = 2;

int main() {
    Vpxmat_tn9k* dut = new Vpxmat_tn9k;
    Verilated::traceEverOn(true);
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    dut->trace(m_trace,5);
    m_trace->open("out/output.vcd");
    dut->rst=1;
    while(sim_time<=MAX_TIME){
        dut->clk^=1;
        dut->eval();
        m_trace->dump(sim_time);
        if (reset_pulse_width!=0) {
            dut->rst=0;
            reset_pulse_width--;
        } else dut->rst=1;
        sim_time++;
    }
    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
    return 0;
}
