//-----------------------------------------------------------------------------
// Nelson Neves: nelson.s.neves@gmail.com
//-----------------------------------------------------------------------------
// disable $fn and $fa, do not change these
$fn=0;
$fa = 0.01;
// use $fs to control the number of facets globally // fine ~ 0.1 coarse ~ 1.0
$fs = 0.3;
//-----------------------------------------------------------------------------

module openHardware_extrude(oHeight){
	scale(v = [1.0, 1.0, 1.0]) {
		translate([-78.9,-71.2+5])
     		linear_extrude(height = oHeight) import("openhardwarefinal0_petit.dxf");

	}
}
//-----------------------------------------------------------------------------
module openHardware_intrude(oHeight){
	scale(v = [1.0, 1.0, 1.0]) {
		translate([-80, -76.6+11]) 
    		  linear_extrude(height = oHeight) import("openhardwarefinal0_grossi.dxf");
	}
}

difference(){
	cylinder(r=15, h=3);	
	translate([0,0,1])scale([0.15,0.15,1.0]) openHardware_intrude(3);
}

translate([30,0,0])
	scale([0.15,0.15,1.0])openHardware_extrude(3);
