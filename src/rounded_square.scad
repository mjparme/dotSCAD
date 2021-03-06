/**
* rounded_square.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-rounded_square.html
*
**/

include <__private__/__is_float.scad>;
include <__private__/__frags.scad>;
include <__private__/__pie_for_rounding.scad>;
include <__private__/__half_trapezium.scad>;
include <__private__/__trapezium.scad>;

module rounded_square(size, corner_r, center = false) {
    is_flt = __is_float(size);
    x = is_flt ? size : size[0];
    y = is_flt ? size : size[1];       
    
    position = center ? [0, 0] : [x / 2, y / 2];
    points = __trapezium(
        length = x, 
        h = y, 
        round_r = corner_r
    );

    translate(position) 
        polygon(points);

    // hook for testing
    test_rounded_square(position, points);
}

// override it to test
module test_rounded_square(position, points) {
}