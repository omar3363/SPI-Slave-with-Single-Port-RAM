# 🟢 SPI Slave with Single-Port RAM (FPGA Project)

This project was developed as a **team effort** by 
[@omar3363](https://github.com/omar3363) 
and 
[@nairaahmedd16](https://github.com/nairaahmedd16).  

It implements an **SPI Slave** connected to a **single-port synchronous RAM**.  
The design is verified using simulation on **QuestaSim**, linting with **QuestaLint**, and synthesized/implemented on **Xilinx Vivado** for FPGA deployment.  

---

## 📂 Repository Structure

```
.
├── src/        # All Verilog source code files (RTL + wrappers)
│   ├── sync_RAM.v
│   ├── sync_SPI.v
│   ├── SPI_Wrapper.v
│   └── SPI_tb.v
│
├── linting/    # Linting results
│   └── QuestaLint screenshots (no errors/warnings)
│
├── fpga/       # FPGA synthesis & implementation results
│   ├── Vivado synthesis reports
│   ├── Timing analysis (Gray vs One-Hot vs Sequential encoding)
│   ├── Device utilization reports
│
├── dv/         # Design Verification
│   ├── SPI_tb.do   # QuestaSim do file
│   ├── Waveform captures (write/read operations)
│   └── Simulation logs
│
└── docs/       # Project Documentation
    ├── SPI_project.pdf        # Full project specification
    ├── Project_Report.pdf     # Report
```

---

## 🛠️ Features

- **SPI Slave FSM**
  - Supports commands:
    - `00`: Load Write Address
    - `01`: Write Data
    - `10`: Load Read Address
    - `11`: Read Data
  - FSM designed with **Gray encoding** (best timing results on FPGA).
- **Single-Port Synchronous RAM**
  - 256 × 8-bit memory.
  - Controlled through SPI commands.
- **Wrapper Module**
  - Connects the SPI FSM with RAM seamlessly.
- **Directed Testbench**
  - Simulates full write → read cycle.
  - Verified using QuestaSim waveform checks.

---

## 🧪 Verification Flow

1. **Simulation**  
   - Verified with **QuestaSim** (`SPI_tb` testbench + `.do` file).
   - Observed waveforms for write and read operations.
   - Confirmed correct data transfer through `MOSI`/`MISO`.

2. **Linting**  
   - Verified with **QuestaLint** (no errors/warnings).

3. **Synthesis & Implementation**  
   - Performed on **Xilinx Vivado**.  
   - Tried **3 FSM encodings**: Gray, One-Hot, Sequential.  
   - ✅ **Gray encoding** chosen (best setup/hold slack).  

4. **FPGA Deployment**  
   - Constraints:  
     - `rst_n`, `SS_n`, `MOSI` → 3 switches.  
     - `MISO` → 1 LED.  
   - Debug core added for signal monitoring.  
   - Bitstream successfully generated.

---

## 📊 Results

- **Simulation:** Successful write/read transactions observed.  
- **Linting:** No errors in QuestaLint.  
- **Synthesis:** Gray encoding gave the best timing results.  
- **Implementation:** Device utilization within limits, timing met.  
- **Bitstream:** Successfully generated and tested on FPGA.  

---

## 📚 Documentation

Full project details, specifications, and requirements are available in:
- [`docs/SPI_project.pdf`](docs/SPI_project.pdf)

---

## 🔮 Future Improvements
- Extend the SPI protocol to support burst read/write.  
- Support multiple RAM banks with chip-select signals.  
- Add SystemVerilog testbench with random stimulus.  
- Automate waveform checks with self-checking testbench.  

---

## 👥 Authors

- [@omar3363](https://github.com/omar3363)  
- [@nairaahmedd16](https://github.com/nairaahmedd16)
