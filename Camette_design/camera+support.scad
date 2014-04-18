boxThickness =2;

module drawCamera(){
	translate([0,-1,-1])cube([27, 26,2]);
	color("black") translate([8.5,5.5,1]) cube([8,8,6]);
	translate([21+3+0.5,-2, -1-6]) rotate([0, 0, 90]) color("brown") cube([9, 22, 6]);
}

module drawOneCameraSupport(){
	translate([0,-3*boxThickness,-2*boxThickness]) cube([8, 6*boxThickness, 4*boxThickness]);
	}

module drawTopCameraSupport(){
	difference(){
		color("red") union(){
			translate([25-2*boxThickness, 0,0]) drawOneCameraSupport();
			translate([25-2*boxThickness, 24,0]) drawOneCameraSupport();
		}
		drawCamera();
	}
}

module drawBottomCameraSupport(){
	difference(){
		color("red") union(){
			translate([-boxThickness,0,0]) drawOneCameraSupport();
			translate([-boxThickness,24,0]) drawOneCameraSupport();
		}
		drawCamera();
	}
}

module drawCameraSupport(){
	difference(){
		color("red") union(){
			//translate([-boxThickness,0,0]) drawOneCameraSupport();
			translate([25-2*boxThickness, 0,0]) drawOneCameraSupport();
			//translate([-boxThickness,24,0]) drawOneCameraSupport();
			translate([25-2*boxThickness, 24,0]) drawOneCameraSupport();
		}
		drawCamera();
	}
}

drawTopCameraSupport();
drawBottomCameraSupport();
drawCamera();
