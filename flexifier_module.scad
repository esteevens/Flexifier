$fn=50;
/*
 * Desk Organizer Generator library
 * License: Creative Commons - Non Commercial - Share Alike License 4.0 (CC BY-NC-SA 4.0)
 * Copyright: Luca Monari 2023
 * URL: https://github.com/lmonari5/desk_organizer_generator.git

The program uses the honeycomb library from Gael Lafond, from https://www.thingiverse.com/thing:2484395.

To add a hinge try:
```
difference(){
  linear_extrude(height = HEIGHT) // extrude the svg
    translate(v=[X_TRAN,Y_TRAN,0]) // translate the svg image
      rotate(a=[0,0,Z_DEG]) // rotate the svg image
        scale([X_SCALE,Y_SCALE,1]) // scale the X and Y axis of the svg
            import(file = "YOUR_PATH/YOUR_FILE.svg", center = true);

translate([X_TRAN_HINGE,Y_TRAN_HINGE,0])
rotate([0,0,ROTATE_HINGE])
diff_hinge(HEIGHT_HING, hinge_h_thick=HINGE_THICKNESS, break=CUT_THICKNESS, break_len=CUT_LENGTH);
};

translate([X_TRAN_HINGE, Y_TRAN_HINGE,0])
rotate([0,0,ROTATE_HINGE])
uni_hinge(HEIGHT_HING, hinge_h_thick=HINGE_THICKNESS, break=CUT_THICKNESS);
*/

module uni_hinge(height, hinge_diam=5, hinge_h_thick=5, vert_tolerance=0.8, break=4, hor_tolerance=0.4, chamfer_multi=6){
chamfer = break/10*chamfer_multi;
hinge_pin_diam = (hinge_diam-vert_tolerance)/3;
// external hinge
translate([0,0,height/2]) rotate([90,0,0])
linear_extrude(hinge_h_thick)
difference(){
// external circle
union(){
circle(d=hinge_diam);
// squared cornern hing
translate([0,-hinge_diam/2,0])
square([(hinge_pin_diam+vert_tolerance)/2+chamfer*sqrt(2), hinge_diam]);};
// internal hole + tolerance
circle(d=hinge_pin_diam+vert_tolerance);};
// internal pin
translate([0,hor_tolerance, height/2]) rotate([90,0,0])
cylinder(h=hinge_h_thick+hor_tolerance*2, d=hinge_pin_diam);
};

module diff_hinge(height, hinge_diam=5, hinge_h_thick=5, hor_tolerance=0.4, vert_tolerance=0.8, break=4, chamfer_multi=6, break_len=200){
chamfer = break/10*chamfer_multi;
hinge_pin_diam = (hinge_diam-vert_tolerance)/3;
hinge_v_thick = (height-hinge_pin_diam-vert_tolerance)/2;
// line break
linear_extrude(height)
translate([(hinge_pin_diam+vert_tolerance)/2,-break_len/2-hinge_h_thick/2,0])
square([break/2, break_len]);
//chamfer bottom and top
for (i=[0, height]){
translate([(hinge_pin_diam+vert_tolerance)/2+break/4,-break_len/2-hinge_h_thick/2,i])
translate([-chamfer*sqrt(2)/2,0,0])
rotate([0, 45, 0])
linear_extrude(chamfer)
square([chamfer, break_len]);};
// square for difference
translate([-hor_tolerance/2,+hor_tolerance,height/2]) rotate([90,0,0])
linear_extrude(hinge_h_thick+hor_tolerance*2)
square([hinge_diam+hor_tolerance, height], center=true);
};

module uni_ball(height, ball_diam=5, tolerance=0.4, break=3){
// internal ball left
translate([-ball_diam/2, 0, height/2]) sphere(r=(ball_diam-tolerance)/2);
// internal ball right
translate([ball_diam/2+break/2, 0, height/2]) sphere(r=(ball_diam-tolerance)/2);
// connection cylinder
translate([break/4, 0,height/2])  rotate([90, 0, 90])cylinder(h=ball_diam+ball_diam/2+break/2-tolerance*2,r=ball_diam/4-tolerance, center=true);
};

module diff_ball(height, ball_diam=5, break=4, break_len=200){
// adding hole offset
hole_offest = (height - ball_diam)/2;
// line break
linear_extrude(height+1)
translate([0,-break_len/2,0])
square([break/2, break_len]);
// external ball left
translate([-ball_diam/2, 0, height/2])
sphere(r=ball_diam/2);
// external ball right
translate([ball_diam/2+break/2, 0, height/2]) sphere(r=ball_diam/2);
// connection hole
translate([break/4, 0, hole_offest]) linear_extrude(ball_diam) square([ball_diam+ball_diam/2+break/2, ball_diam/2], center=true);
};
