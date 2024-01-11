DAHLIA=fuse

all: mandelbrot.test.cpp mandelbrot.hls.cpp

%.fuse: %.fuse.m4
	m4 $< > $@

%.hls.cpp: %.fuse
	$(DAHLIA) $< -n mandelbrot -o $@

%.hls.h: %.fuse
	$(DAHLIA) $< -n mandelbrot --header -o $@

%.test.cpp: %.fuse test.data.json
	$(DAHLIA) run $< -o $@
	./$@.o test.data.json > actual.json
# diff <(jq --sort-keys . expect.json) <(jq --sort-keys . actual.json)

synthesis: mandelbrot.hls.cpp
	vitis_hls build_hls.tcl

clean:
	rm -rf _headers
	rm -f *.test.cpp *.hls.cpp

.PHONY: clean generate synthesis
