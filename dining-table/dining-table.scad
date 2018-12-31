feet = 12;

table_width = 7 * feet;
table_depth = 4 * feet;
table_height = 30;
table_thickness = 2;
breadboard_width = 6;
leg_thickness = 2;
leg_width = 5;
leg_separation = 8;
truss_height = 5;
truss_thickness = 1;
truss_extension = 3;
foot_height = 4;
foot_thickness = 4;

leg_height = table_height - table_thickness;
leg_offset = leg_height / 2;
truss_offset = leg_height / 2;
foot_width = table_depth - leg_offset;

// table top
translate([0, 0, leg_height + table_thickness / 2])
cube([table_width - breadboard_width * 2, table_depth, table_thickness], true);

// breadboards
module breadboard() {
  translate([table_width / 2 - breadboard_width / 2 + 0.1, 0, leg_height + table_thickness / 2])
    cube([breadboard_width, table_depth, table_thickness], true);
}

module x_leg() {
  rotate([90, 0, 90])
    translate([0, leg_height / 2, table_width / 2 - leg_offset - leg_thickness / 2])
    cube([leg_width, leg_height, leg_thickness], true);
}

module sloped(cube, slope_width, slope_height, center = true) {
  x = cube[0];
  y = cube[1];
  z = cube[2];
  rotate([90, 0, 0])
  linear_extrude(height = z, center = false)
  translate([
    center ? -x / 2 : 0,
    center ? -y / 2 : 0,
    center ? -z / 2 : 0
  ])
  polygon([
    [0, 0],
    [0, slope_height],
    [slope_width, y],
    [x - slope_width, y],
    [x, slope_height],
    [x, 0]
  ]);
}

module wedge(cube, slope_width, slope_height, center = true) {
  x = cube[0];
  y = cube[1];
  z = cube[2];
  rotate([90, 0, 0])
  linear_extrude(height = z, center = false)
  translate([
    center ? -x / 2 : 0,
    center ? -y / 2 : 0,
    center ? -z / 2 : 0
  ])
  polygon([
    [0, 0],
    [0, slope_height],
    [slope_width, y],
    [x, y],
    [x, 0]
  ]);
}

module leg_wedge() {
  wedge_dims = [truss_height * 2, truss_extension - 1, truss_thickness / 2];
  translate([table_width / 2 - leg_offset + wedge_dims[1] / 2, leg_separation / 2 + leg_width / 2 - wedge_dims[2] / 2, truss_offset])
  rotate([0, 270, 180])
  wedge(wedge_dims, wedge_dims[0] - 2, 1);
}

module table_wedge() {
  dims = [4, (leg_thickness * 2 + foot_thickness) * 1.5, truss_thickness / 2];
  translate([table_width / 2 - leg_offset - 1, 0, leg_height - 1])
  rotate([90, 0, -90])
  sloped(dims, dims[0] / 5, 1);
}

module foot() {
  translate([table_width / 2 - leg_offset - leg_thickness / 2 - foot_thickness / 2, 0, foot_height / 2])
  rotate([0, 0, 90])
  sloped([foot_width, foot_height, foot_thickness], 5, 1);
}

module glide() {
  glide_height = foot_height / 1.5;
  translate([table_width / 2 - leg_offset - leg_thickness / 2 - foot_thickness / 2, 0, leg_height - glide_height / 2])
  rotate([180, 0, 90])
  sloped([foot_width / 2, glide_height, leg_thickness], 2.5, 1);
}

module leg() {
  leg_separation_x = leg_separation / 2 + leg_width / 2;
  translate([0, leg_separation_x, 0])
  x_leg();
  translate([0, -leg_separation_x, 0])
  x_leg();
  foot();
  translate([0, 0, leg_height])
    rotate([180, 0, 0])
    foot();
  glide();
  translate([foot_thickness + leg_thickness, 0, 0])
  glide();
  leg_wedge();
  mirror([0, 1, 0]) leg_wedge();
  table_wedge();
}

module truss() {
  translate([0, leg_separation / 2 + leg_width / 2, truss_offset])
  rotate([90, 0, 0])
  cube([table_width - leg_offset * 2 + leg_thickness * 2 + truss_extension * 2, truss_height, truss_thickness], true);
}

breadboard();
mirror([1, 0, 0]) breadboard();

leg();
mirror([1, 0, 0]) leg();

truss();
mirror([0, 1, 0]) truss();
