.PHONY: all lib clean sim

all: out/pxmat_tn9k.fs

out/pxmat_tn9k.fs: out/pnr.json
	gowin_pack -d GW1N-9C -o out/pxmat_tn9k.fs out/pnr.json

out/pnr.json: out/pxmat_tn9k.json
	nextpnr-gowin --freq 27 --device GW1NR-LV9QN88PC6/I5 --family GW1N-9C --cst cst/pxmat_tn9k.cst --top pxmat_tn9k --json $< --write out/pnr.json

out/pxmat_tn9k.json:
	mkdir -p out
	yosys -s script/yosys.txt

sim: lib | out
	verilator -Wno-WIDTHEXPAND -DVERILATOR=1 -Iobj_dir -O3 --trace --exe --top-module pxmat_tn9k --build -cc sim/pxmat_tn9k.cpp src/pxmat_tn9k.v
	./obj_dir/Vpxmat_tn9k

lib: src/pxmat_tn9k.sv | obj_dir
	verilator -Wno-WIDTHEXPAND -Wno-MULTITOP -DVERILATOR=1 -Iobj_dir --cc $<

obj_dir:
	mkdir -p obj_dir

out:
	mkdir -p out

clean:
	rm -rf obj_dir
	rm -rf out
	rm -rf impl

flash: out/pxmat_tn9k.fs
	sudo openFPGALoader -b tangnano9k $<