

all: plate.dxf top.dxf

%.dxf: battleboard.scad
	openscad -o $@ -D"mode=\"export$*\"" $<

clean:
	rm plate.dxf
	rm top.dxf

.PHONY: all clean
