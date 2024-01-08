DAHLIA=fuse

all: lorentz.test.cpp lorentz.hls.cpp

%.fuse: %.fuse.m4
	m4 $< > $@

%.hls.cpp: %.fuse
	$(DAHLIA) $< -n lorentz -o $@

%.hls.h: %.fuse
	$(DAHLIA) $< -n lorentz --header -o $@

%.test.cpp: %.fuse test.data.json
	$(DAHLIA) run $< -o $@
	./$@.o test.data.json > actual.json
	diff <(jq --sort-keys . expect.json) <(jq --sort-keys . actual.json)

synthesis: lorentz.hls.cpp
	vitis_hls build_hls.tcl

clean:
	rm -rf _headers
	rm -f *.test.cpp *.hls.cpp

.PHONY: clean generate synthesis
