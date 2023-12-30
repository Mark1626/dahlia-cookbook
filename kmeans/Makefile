all: kmeans.hls.cpp

%.hls.cpp: %.fuse
	fuse $< -o $@

%.fuse: %.fuse.m4
	m4 $< > $@

%.test.cpp: %.fuse

run:
	fuse run kmeans.fuse -o kmeans.cpp
