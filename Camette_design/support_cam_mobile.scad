use <mini_servo.scad>
use <camera+support.scad>

$fn=50;

module supportServo(){
	difference(){
		translate([(22-31.6)/2, 0, 0 ]) cube([31.6, 13, 21.2]);
		translate([0,0, -2.2]) miniServo_noir();
	}

	//translate([0,0, -2.2])miniServo_noir();

	translate([0, -1, 0]) difference(){
	translate([(21-30)/2, 0, 21.2+11.2+2]) 
		rotate([90+180, 0, 0]) cube([30, 11.2+2, 14]);
	translate([0, -0.8, 21.2+11.2+2+0.2]) 
	rotate([90+180, 0, 0]) miniServo_transparent();
	}

	//translate([0, 14, 21.2]) 
	//rotate([90+180, 0, 0]) miniServo_transparent();
}

module supportCam(){
	//cube([25, 14, 1]);
	cube([25+5, 24, 2]);
	
	difference() {

		translate([25+3, 0, -6]) cube([2, 24,12]);
		translate([25+3, 12, -3]) rotate([0, 90, 0])cylinder(r=1, h=4);	
	}
	
	
	translate([0, 0, 2]) cube([2, 24,4]);
	translate([25+1, 0, 6]) cube([4, 24,2]);
	translate([0, 0, 6]) cube([4, 24,2]);
	translate([2, 0, 2]) cube([2, 2, 4]);
	translate([26, 0, 2]) cube([2, 2, 4]);
}

difference(){
	union(){
		cube([39.5, 9.5, 10]);
		translate([-2,-2, 9]) cube([39+4, 9+4, 1]);
	}

	union(){
		translate([1,1,0]) cube([39-2, 9-2, 10-1]);
		translate([39/2, 9/2, 8]) cylinder(r=1, h=3);
		translate([-2,-2, 8]) cube([16+2, 2, 4]);
	}
}

//supportCam();