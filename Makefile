
plate.dxf: battleboard.scad
	openscad -o $@ -D"mode=\"exportplate\"" $<
