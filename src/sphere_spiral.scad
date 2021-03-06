/**
* sphere_spiral.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-sphere_spiral.html
*
**/ 

function sphere_spiral(radius, za_step, z_circles = 1, begin_angle = 0, end_angle = 0, vt_dir = "SPI_DOWN", rt_dir = "CT_CLK") = 
    [
        for(a = [begin_angle:za_step:90 * z_circles - end_angle]) 
            let(
                ya = vt_dir == "SPI_DOWN" ? (-90 + 2 * a / z_circles) : (90 + 2 * a / z_circles),
                za = (rt_dir == "CT_CLK" ? 1 : -1) * a,
                ra = [0, ya, za]
            )
            [rotate_p([radius, 0, 0], ra), ra]
    ];