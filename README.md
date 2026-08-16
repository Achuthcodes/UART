# UART Communication System

Implemented a complete UART communication system in Verilog HDL with:

- 8-bit parallel data input/output
- Serial TX/RX communication
- Baud-rate generator
- TX and RX FIFOs
- FSM-based transmitter and receiver control
- Multi-byte data transmission and reception

## Verification

The design was simulated using Icarus Verilog and GTKWave. 
The simulation verifies the complete data path:

Parallel Input → TX FIFO → UART Transmitter → Serial TX → UART Receiver → RX FIFO → Parallel Output

Multi-byte transmission was successfully verified through waveform analysis.
