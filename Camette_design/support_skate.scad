$fn=50;
ecrou_m3=3.2;
ep=5;
trou_m3=2;
raspSize = [105, 80,14.5+2];

module ecrou(){
	translate([0,0,ep])rotate([180,0,0]) union(){
		translate([0,0,-ep/2])cylinder(h=ep+10, r=trou_m3);
		translate([0,0,-ep/2])cylinder(h=ep, r=ecrou_m3, $fn=6);
	}
}

translate([-5,6,-10])rotate([-90, 0, 90])difference(){
	union(){
		cylinder(r=6, h=raspSize[2]*2-6, $fn=50);
		translate([-6, 0, 0]) rotate([0, 0, -90])
			cube([10, 6*2,raspSize[2]*2-6]);
	}
	translate([0,0,-1])cylinder(r=1.7, h=raspSize[2]*2-6+2);
}

difference(){
	union(){
		translate([-(raspSize[2]*2-6+5),0,0]) cube([60+raspSize[2]*2-6+5,60,5]);
		translate([0,0,23+5]) cube([60,60,5]);
		translate([0,0,13+5+23+5]) cube([60,60,5]);
		translate([-5,0,0]) cube([5,60, 13+5+23+5+5]);
	}

	union(){
		translate([30,10,0]) ecrou();
		translate([30,60-10,0]) ecrou();
		translate([30,10,13+5+23+10]) rotate([180,0,0]) ecrou();
		translate([30,60-10,13+5+23+10])rotate([180,0,0]) ecrou();
		translate([30,10,5+23]) rotate([180,0,0]) ecrou();
		translate([30,60-10,5+23]) rotate([180,0,0]) ecrou();
	}
}