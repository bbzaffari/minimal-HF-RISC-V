TOP = tb

VHDL_BASE = ../..
SRC_BASE = ../..

VHD_SRC = \
	$(VHDL_BASE)/riscv/core_rv32e/bshifter.vhd \
	$(VHDL_BASE)/riscv/core_rv32e/alu.vhd \
	$(VHDL_BASE)/riscv/core_rv32e/reg_bank.vhd \
	$(VHDL_BASE)/riscv/core_rv32e/control.vhd \
	$(VHDL_BASE)/riscv/core_rv32e/datapath.vhd \
	$(VHDL_BASE)/riscv/core_rv32e/int_control.vhd \
	$(VHDL_BASE)/riscv/core_rv32e/cpu.vhd \
	$(VHDL_BASE)/devices/controllers/uart/uart.vhd \
	$(VHDL_BASE)/devices/peripherals/basic_soc.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/add_key.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/add_left.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/e_expansion_function.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/key_schedule.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s1_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s2_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s3_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s4_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s5_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s6_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s7_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s8_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/p_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/s_box.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/block_top.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/des_top.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/des_cipher_top.vhd \
	$(VHDL_BASE)/devices/controllers/tdes/tdes_top.vhd \
	$(VHDL_BASE)/riscv/sim/boot_ram.vhd \
	$(VHDL_BASE)/riscv/sim/ram.vhd \
	$(VHDL_BASE)/riscv/sim/tdes_tb.vhd

PROG_SRC = \
	$(SRC_BASE)/riscv/sim/boot.txt \
	$(SRC_BASE)/software/code.txt
	
TIME = 1ms


all:
# Command line simulation using the free ghdl
# run simulation with 'make ghdl-vcd TIME=10ms' to run for 10ms
ghdl:
	@ cp $(PROG_SRC) .
	@ mkdir -p simu
	ghdl -a --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work -fexplicit $(VHD_SRC)
	
ghdl-vcd: ghdl
	ghdl -r --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work -fexplicit $(TOP) --assert-level=failure --stop-time=$(TIME) --vcdgz=$(TOP).vcd.gz

ghdl-ghw: ghdl
	ghdl -r --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work -fexplicit $(TOP) --assert-level=failure --stop-time=$(TIME) --wave=$(TOP).ghw


# Display waveforms
wave-vcd:
	gtkwave $(TOP).vcd.gz --rcvar 'fontname_signals Monospace 12' --rcvar 'fontname_waves Monospace 12'
	
wave-ghw:
	gtkwave $(TOP).ghw


# Clean all generated files
clean:
	@ rm -rf simu work mylib
	@ rm -f $(TOP)
	@ rm -f $(TOP).vcd.gz
	@ rm -f $(TOP).vcd $(TOP).ghw
	@ rm -f *.txt *.ini *.vsim transcript
