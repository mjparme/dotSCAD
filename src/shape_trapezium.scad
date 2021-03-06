/**
* shape_trapezium.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-shape_trapezium.html
*
**/

include <__private__/__is_float.scad>;
include <__private__/__frags.scad>;
include <__private__/__pie_for_rounding.scad>;
include <__private__/__half_trapezium.scad>;
include <__private__/__trapezium.scad>;

function shape_trapezium(length, h, corner_r = 0) = 
    __trapezium(
        length = length, 
        h = h, 
        round_r = corner_r
    );
    