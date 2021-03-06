/**
* m_shearing.scad
*
* @copyright Justin Lin, 2019
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-m_shearing.html
*
**/

include <__private__/__m_shearing.scad>;

function m_shearing(sx = [0, 0], sy = [0, 0], sz = [0, 0]) = __m_shearing(sx, sy, sz);