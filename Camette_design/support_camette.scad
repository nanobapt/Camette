use <openhardwarefinal.scad>
use <MOLETTE.scad>
use <camette_box.scad>

raspSize = [105, 80,14.5+2];
supportHeight = 3;

module pied_support(angle){
	difference(){
		union(){
			hull(){
				cylinder(r=16, h=supportHeight, $fn=50);
				translate([0, 90, 0])
					cylinder(r=6, h=supportHeight, $fn=50);
			}
			translate([0, 90, supportHeight]) cylinder(r=6, h=supportHeight, $fn=50);
		}
		union(){
			translate([0,90*0.6/2,-1])scale([0.6,0.6,1.0])hull(){
				cylinder(r=16, h=supportHeight+2, $fn=50);
				translate([0, 90, 0])
					cylinder(r=6, h=supportHeight+2, $fn=50);
			}
			translate([0, 90, -1]) cylinder(r=1.7, h=2*supportHeight+2, $fn=50);
			rotate([0,0,angle]) translate([0,0,-1])scale([0.18,0.18,1.0]) openHardware_intrude(3);
		}			
	}

	rotate([0,0,angle]) translate([0,0,3]) scale([0.18,0.18,1.0]) openHardware_extrude(2);
}

module pied_support_droit(){
	pied_support(180-90+62.6);
}

module pied_support_gauche(){
	pied_support(-90-62.6);
}

module socle(){
	translate([0,raspSize[2]-3,0])rotate([90,0,0]) 
		difference(){
			union(){
				cylinder(r=6, h=raspSize[2]*2-6, $fn=50);
				translate([-6, 0, 0]) rotate([0, 0, -90])
					cube([10, 6*2,raspSize[2]*2-6]);
			}
			translate([0,0,-1]) cylinder(r=1.7, h=raspSize[2]*2-4, $fn=50);
		}
		translate([20,0,0]) hull(){
			translate([0, 0, -10])
				cylinder(r=40, h=1, $fn=50);
			translate([0, 0, -13])
				cylinder(r=45, h=1, $fn=50);
		}

		translate([40,-34,-9])rotate([0,0,90])scale([0.25,0.25,0.25]) linear_extrude(height = 1) import("camette.dxf");
}

//translate([0,-raspSize[2]-3,0])rotate([-90,0,0]) translate([0,-90,0]) 
//	pied_support_droit();
//translate([0,(raspSize[2]-supportHeight)+6, 0])rotate([-90,0,180]) translate([0,-90,0]) 
//	pied_support_gauche();
socle();

