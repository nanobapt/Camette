use <raspberry_pi.scad>
use <camera+support.scad>
use <hardware.scad>
use <tools.scad>
use <openhardwarefinal.scad>

raspSize = [105, 80,14.5];

boxThickness = 1;
boxRadius = 2;

module drawRaspBox(boxSize, rbox, rbias){
	cylinderCenterX = (boxSize[0]-rbox*8-boxRadius)/2;
union(){
difference(){
	union(){
		// design the round 1
		translate([rbox+cylinderCenterX, -rbox/2-rbias, 0])
		difference(){
			cylinder(h=boxSize[2], r=rbox+rbias, $fn=50);
			translate([-2*rbox,-3*rbox,-1])cube([rbox*4, 5*rbox/2+rbox+rbias, boxSize[2]+2]);
		}
		// design the round 2
		translate([((rbox)*3+cylinderCenterX), -rbox/2-rbias, 0])
		difference(){
			cylinder(h=boxSize[2], r=rbox+rbias, $fn=50);
			translate([-2*rbox,-3*rbox,-1])cube([rbox*4, 5*rbox/2+rbox+rbias, boxSize[2]+2]);
		}
		// design the round 3
		translate([(rbox)*5+cylinderCenterX, -rbox/2-rbias, 0])
		difference(){
			cylinder(h=boxSize[2], r=rbox+rbias, $fn=50);
			translate([-2*rbox,-3*rbox,-1])cube([rbox*4, 5*rbox/2+rbox+rbias, boxSize[2]+2]);
		}
		// design the round 4
		translate([(rbox)*7+cylinderCenterX, -rbox/2-rbias, 0])
		difference(){
			cylinder(h=boxSize[2], r=rbox+rbias, $fn=50);
			translate([-2*rbox,-3*rbox,-1])cube([rbox*4, 5*rbox/2+rbox+rbias, boxSize[2]+2]);
		}

		//design the box
		difference(){
		roundedRect(boxSize, boxRadius);
			translate([boxThickness,boxThickness,-boxThickness]) 
			roundedRect([boxSize[0]-boxThickness*2,boxSize[1]-boxThickness*2,boxSize[2]-boxThickness+1], boxRadius);
		}


	}

	translate([rbox+cylinderCenterX,-rbox/2-rbias, -boxThickness]) cylinder(h=boxSize[2]+2, r=(rbox-boxThickness+rbias), $fn=50);
	translate([3*(rbox)+cylinderCenterX,-rbox/2-rbias, -boxThickness]) cylinder(h=boxSize[2]+2, r=(rbox-boxThickness+rbias), $fn=50);
	translate([5*(rbox)+cylinderCenterX,-rbox/2-rbias, -boxThickness]) cylinder(h=boxSize[2]+2, r=(rbox-boxThickness+rbias), $fn=50);
	translate([7*(rbox)+cylinderCenterX,-rbox/2-rbias, -boxThickness]) cylinder(h=boxSize[2]+2, r=(rbox-boxThickness+rbias), $fn=50);

}

}

}

module drawBottomBox(){
	rfinger = (raspSize[0]/4-boxThickness)/2;
	tmpBoxSize = [raspSize[0]+rfinger/2+boxThickness, raspSize[1]+boxThickness, raspSize[2]+boxThickness]; 

	drawRaspBox(tmpBoxSize, rfinger, 0);
	rinsidefinger = ((raspSize[0])/4-boxThickness)/2;
	translate([boxThickness, boxThickness, -2*boxThickness]) drawRaspBox([tmpBoxSize[0]-2*boxThickness,tmpBoxSize[1]-2*boxThickness, tmpBoxSize[2]+2*boxThickness], rinsidefinger, boxThickness/2);
}

module drawTopBox(){
// Top box
	rfinger = (raspSize[0]/4-boxThickness)/2;
	tmpBoxSize = [raspSize[0]+rfinger/2+boxThickness, raspSize[1]+boxThickness, raspSize[2]+boxThickness];
	// design fisheye support
	translate([-1.5,0,0]) difference(){
		color("black")translate([raspSize[0]+6*boxThickness+2.5, raspSize[1]-14.5-1.5-8*boxThickness/2-1, raspSize[2]-12.5-1.5-1])rotate([0,90,0]) cylinder(h=4, r=7.5+3*boxThickness, $fn=50);
		translate([raspSize[0]+6*boxThickness+2.5-0.1, raspSize[1]-14.5-1.5-8*boxThickness/2-1, raspSize[2]-12.5-1.5-1])rotate([0,90,0]) cylinder(h=4.5, r=7.5, $fn=50);
	}
	difference(){
		color("red")rotate([0,180,0]) mirror() drawRaspBox(tmpBoxSize, rfinger, 0);		
	}
}

// Draw box with different cam/rapsberry support
module drawEntireTopBox(){
	rSmooth=15;
	smoothThickness = 3;
	angle=15;

	difference(){
	union(){
		drawTopBox();		
			// camette support
			translate([7*raspSize[0]/8+2*boxThickness, rSmooth+3*rfinger/4, -raspSize[2]-1])
			cylinder(h=2*boxThickness+2, r=rSmooth+3);
			translate([35+22, 26+28.5, -raspSize[2]-1]) cylinder(r=25, h=3);
			//camera
			translate([raspSize[0]-2*boxThickness, raspSize[1]-24-6*boxThickness, raspSize[2]-boxThickness]) rotate([-90,90,-90]){
				//drawCamera();
				drawTopCameraSupport();
			}
	}
		union(){
			// Raspberry
			translate([3*boxThickness, 56+rfinger/2+boxThickness+0.5,raspSize[2]-boxThickness-3]) rotate([180,0,0]) raspberrypi();
			// Logo
			translate([35, 26, -raspSize[2]-3.5]) scale([0.19, 0.19]) dxf_linear_extrude(file="logo_camera.dxf", height=3, convexity=1);
			// camera eye
			translate([raspSize[0]+4*boxThickness, raspSize[1]-14.5-1.5-8*boxThickness/2-1, raspSize[2]-12.5-1.5-1]) rotate([0,90,0]) cylinder(h=4*boxThickness, r=4, $fn=50);
			// camette support smooth gear
			//color("orange")translate([3*raspSize[0]/4+2*boxThickness, rSmooth+rfinger/2, -raspSize[2]-boxThickness-2]) smoothGear(angle, rSmooth, 3+1);
			color("orange") translate([7*raspSize[0]/8+2*boxThickness, rSmooth+3*rfinger/4, -raspSize[2]-2]) scale([0.18,0.18,1.0]) openHardware_intrude(4);

		}
	}
}

module drawEntireBottomBox(){
	rSmooth=15;
	smoothThickness = 3;
	angle=15;

	difference(){
		union(){
			color("blue") drawBottomBox(); 
			translate([80+3*boxThickness, 50+rfinger/2+boxThickness,raspSize[2]-9]) cube([10,10,10]);
			// camette support
// camette support
			translate([7*raspSize[0]/8+2*boxThickness, rSmooth+3*rfinger/4, raspSize[2]-boxThickness-2])
			cylinder(h=2*boxThickness+2, r=rSmooth+3);
			
			// sensor support
			translate([raspSize[0]-2*boxThickness, raspSize[1]-24-6*boxThickness, raspSize[2]-boxThickness]) rotate([-90,90,-90]){
				//drawCamera();
				drawBottomCameraSupport();
			}
		}

		union(){
			// Raspberry
			translate([3*boxThickness, 56+rfinger/2+boxThickness+0.5,raspSize[2]-boxThickness-3]) rotate([180,0,0]) raspberrypi();
translate([35,15, -raspSize[2]-3.5]) scale([0.2, 0.2]) dxf_linear_extrude(file="logo_camera.dxf", height=3, convexity=1);
			// camera eye
			translate([raspSize[0]+4*boxThickness, raspSize[1]-14.5-1.5-8*boxThickness/2-1, raspSize[2]-12.5-1.5-1]) rotate([0,90,0]) cylinder(h=4*boxThickness, r=4, $fn=50);
			// camette support smooth gear
			color("orange") translate([7*raspSize[0]/8+2*boxThickness, rSmooth+3*rfinger/4, raspSize[2]-2]) scale([0.18,0.18,1.0]) openHardware_intrude(4);
			
		}
	}
}

rfinger = (raspSize[0]/4-boxThickness)/2;


color("red") drawEntireTopBox();
color("blue") drawEntireBottomBox();
rfinger = (raspSize[0]/4-boxThickness)/2;
translate([3*boxThickness, 56+rfinger/2+boxThickness+0.5,raspSize[2]-boxThickness-3]) rotate([180,0,0]) raspberrypi();
