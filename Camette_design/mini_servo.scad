$fn=50;

module miniServo_noir(){
	color("black"){
		cube([22, 11, 21.2]);
		translate([11/2,11/2,-4]) cylinder(h=4, r=11/2);
		translate([-7, 0, 12]) cube([7, 11, 4]);
//		difference(){
			translate([(22-31.6)/2, 0, 0]) cube([31.6,11, 2.2]);
			union(){
				translate([(22-31.6)/4, 11/2, -0.4]) cylinder(r=1.05, h=13);
				translate([-(22-31.6)/4+22, 11/2, -0.4]) cylinder(r=1.05, h=13);
//			}
		}
	}
}

module miniServo_transparent(){
	color("gray"){
		cube([21, 11.2, 14]);
		translate([0,0,-5]) cube([21, 11.2, 5]);
		translate([-7, 0, 9]) cube([7, 11.2, 2]);
		//difference(){
			translate([(21-30)/2, 0, 0]) cube([30, 11.2, 0.8]);
			union(){
				translate([(21-30)/4, 11.2/2, -0.4]) cylinder(r=1.05, h=13);
				translate([-(21-30)/4+22, 11.2/2, -0.4]) cylinder(r=1.05, h=13);
		//	}
		}
	}
}


miniServo_transparent();
translate([0, -15, 0]) miniServo_noir();
