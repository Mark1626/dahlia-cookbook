DAHLIA=fuse

all: lorenz.test.cpp lorenz.hls.cpp

%.fuse: %.fuse.m4
	m4 $< > $@

%.hls.cpp: %.fuse
	$(DAHLIA) $< -n lorenz -o $@

%.hls.h: %.fuse
	$(DAHLIA) $< -n lorenz --header -o $@

%.test.cpp: %.fuse test.data.json
	$(DAHLIA) run $< -o $@
	./$@.o test.data.json > actual.json
	diff <(jq --sort-keys . expect.json) <(jq --sort-keys . actual.json)

synthesis: lorenz.hls.cpp
	vitis_hls build_hls.tcl

clean:
	rm -rf _headers
	rm -f *.test.cpp *.hls.cpp

.PHONY: clean generate synthesis
