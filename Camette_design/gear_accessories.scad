use <smoothGear.scad>

rSmooth=15;
smoothThickness = 3;
angle=15;

// camette support smooth gear
color("orange")translate([3*raspSize[0]/4+2*boxThickness, rSmooth+rfinger/2, raspSize[2]-1]) smoothGear(angle, rSmooth-0.5, (3+1));