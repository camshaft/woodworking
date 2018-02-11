feet = 12;

table_width = feet * 6;
table_depth = feet * 3;
table_height = 34 + 1/8;
shelf_height = 12;
leg_height = table_height - 3/4;

module tbf(length, center = true) {
  cube([length, 3.5, 1.5], center);
};
module tbs(length, center = true) {
  cube([length, 5.5, 1.5], center);
};
module ply(width, length, center = true) {
  cube([width, length, 3 / 4], center);
};

module frame() {
// front
  translate([0, -(table_depth / 2) + .75, 0])
  rotate([90, 0, 0])
  tbf(table_width);
// back
  translate([0, (table_depth / 2) - .75, 0])
  rotate([90, 0, 0])
  tbf(table_width);
// joists
  translate([-(table_width / 2) + .75, 0, 0])
  rotate([90, 0, 90])
  tbf(table_depth - 3);

  translate([-(table_width / 4) + .75, 0, 0])
  rotate([90, 0, 90])
  tbf(table_depth - 3);

  translate([0, 0, 0])
  rotate([90, 0, 90])
  tbf(table_depth - 3);

  translate([(table_width / 4) - .75, 0, 0])
  rotate([90, 0, 90])
  tbf(table_depth - 3);

  translate([(table_width / 2) - .75, 0, 0])
  rotate([90, 0, 90])
  tbf(table_depth - 3);
};

module leg() {
  //translate([2.3, 3.2, 1.5])
  rotate([0, 90, 0])
  tbf(leg_height);
  translate([1,2+1/3,0])
  rotate([90, 90, 0])
  tbf(leg_height);
};

// TOP
  translate([0, 0, leg_height - 1.75])
  frame();

// ply
  translate([0, 0, table_height - 3/8])
  ply(table_width, table_depth);

// BOTTOM
  translate([0, 0, shelf_height - 1.75 - 3/4])
  frame();

// ply
  translate([0, 0, shelf_height - 3/8])
  ply(table_width, table_depth);

leg_offset = 4.6;

  // legs
  translate([-table_width / 2 + leg_offset, -table_depth / 2 + leg_offset/2, leg_height / 2])
  rotate([0, 0, 90])
  leg();

  translate([table_width / 2 - leg_offset, -table_depth / 2 + leg_offset/2, leg_height / 2])
  rotate([180, 0, 90])
  leg();

  translate([-table_width / 2 + leg_offset, table_depth / 2 - leg_offset/2, leg_height / 2])
  rotate([180, 0, -90])
  leg();

  translate([table_width / 2 - leg_offset, table_depth / 2 - leg_offset/2, leg_height / 2])
  rotate([0, 0, -90])
  leg();
