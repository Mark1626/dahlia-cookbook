DAHLIA=~/Documents/opensource/mlir/dahlia/fuse

all: tsp.test.cpp tsp.hls.cpp

%.hls.cpp: %.fuse
	$(DAHLIA) $< -n tsp -o $@

%.hls.h: %.fuse
	$(DAHLIA) $< -n tsp --header -o $@

%.test.cpp: %.fuse test.data.json
	$(DAHLIA) run $< -o $@
	./$@.o test.data.json > actual.json
	diff <(jq --sort-keys . expect.json) <(jq --sort-keys . actual.json)

synthesis: tsp.hls.cpp
	vitis_hls build_hls.tcl

clean:
	rm -rf _headers
	rm -f *.test.cpp *.hls.cpp

.PHONY: clean generate synthesis
