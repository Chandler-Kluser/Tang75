out/pxmat_tn9k.fs: out/pnr.json
	gowin_pack -d GW1N-9C -o out/pxmat_tn9k.fs out/pnr.json

out/pnr.json: out/pxmat_tn9k.json
	nextpnr-gowin --freq 27 --device GW1NR-LV9QN88PC6/I5 --family GW1N-9C --cst cst/pxmat_tn9k.cst --top pxmat_tn9k --json $< --write out/pnr.json

out/pxmat_tn9k.json:
	mkdir -p out
	yosys -s script/yosys.txt