

all: keyplate.dxf splitbottom.dxf arcadeplate.dxf front.dxf back.dxf bottom.dxf

%.dxf: battleboard.scad
	openscad -o $@ -D"mode=\"export$*\"" $<

clean:
	rm plate.dxf
	rm top.dxf

.PHONY: all clean
