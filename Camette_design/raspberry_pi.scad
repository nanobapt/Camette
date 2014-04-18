
//everything in mm

use <pin_headers.scad>;

width = 56.5;
length = 86;
height = 1.5;

color([0,1,0]) import("pi.STL");


module ethernet ()
{
//ethernet port
color("silver")
translate([length-20,1.5,height]) cube([21.2,16,13.3]);
}

module usb ()
{
//usb port
color("silver")
translate([length-9.5,25-1,height]) cube([17.3+30,15,16]);
}

module composite ()
{
//composite port
translate([length-43.6-1,width-12,height+1]){
        color("yellow")
        cube([10,10,13]);
        translate([5,24,8])
        rotate([90,0,0])
        color("silver")
        cylinder(h = 15, r = 5);
}
}

module audio ()
{
//audio jack
translate([length-26,width-11.5,height]){
        color("yellow")
        cube([12,11.5,13]);
        translate([6,11.5,8])
        rotate([-90,0,0])
        color("silver")
        cylinder(h = 10.5, r = 4.15);
}
}


module gpio ()
{
//headers
//rotate([0,0,180])
//translate([-1,-width+6,height])
//off_pin_header(rows = 13, cols = 2);
translate([0,56-17-5, 0]) cube([40, 10, 30]);
}

module hdmi ()
{
  color ("yellow") translate ([37.1,-1,height]) cube([15.1,11.7,8-height]);
}

module power ()
{
  translate ([-10.8,0.8,height-3]) cube ([15.6, 12,8.4-height]);
}

module sd ()
{
  color ([0,0,0]) translate ([0.9, 15.2,-5.2+height ]) cube ([16.8, 28.5, 5.2-height]);
  color ([.2,.2,.7]) translate ([-17.3,17.7,-2.9-0.5]) cube ([32, 24+1, 3] );
}

module mhole ()
{
  cylinder (r=3/2, h=height+.2, $fs=0.1);
}


module raspberrypi(){
//translate([-length/2,width/2 + 10,0])
{
difference () {
   color([0.2,0.5,0])
   linear_extrude(height = height)
   translate([0,-0.5,0])square([length,width]); //pcb
   translate ([25.5, 18,-0.1]) mhole ();
   translate ([length-5, width-12.5, -0.1]) mhole ();
}

ethernet ();
usb ();
composite ();
audio ();
gpio ();
hdmi ();
power ();
sd ();
}
}

raspberrypi();