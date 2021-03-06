/**
* along_with.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-along_with.html
*
**/ 
 
include <__private__/__angy_angz.scad>;
include <__private__/__is_float.scad>;
include <__private__/__to3d.scad>;

// Becuase of improving the performance, this module requires m_rotation.scad which doesn't require in dotSCAD 1.0. 
// For backward compatibility, I directly include m_rotation here.
include <m_rotation.scad>;

module along_with(points, angles, twist = 0, scale = 1.0) {
    leng_points = len(points);
    leng_points_minus_one = leng_points - 1;
    twist_step_a = twist / leng_points;
        
    function scale_step() =
        let(s =  (scale - 1) / leng_points_minus_one)
        [s, s, s];

    scale_step_vt = __is_float(scale) ? 
        scale_step() :
        [
            (scale[0] - 1) / leng_points_minus_one, 
            (scale[1] - 1) / leng_points_minus_one,
            scale[2] == undef ? 0 : (scale[2] - 1) / leng_points_minus_one
        ]; 

    // get rotation matrice for sections

    identity_matrix = [
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1]
    ];    

    function local_ang_vects(j) = 
        j == 0 ? [] : local_ang_vects_sub(j);
    
    function local_ang_vects_sub(j) =
        let(
            vt0 = points[j] - points[j - 1],
            vt1 = points[j + 1] - points[j],
            a = acos((vt0 * vt1) / (norm(vt0) * norm(vt1))),
            v = cross(vt0, vt1)
        )
        concat([[a, v]], local_ang_vects(j - 1));

    function cumulated_rot_matrice(i, rot_matrice) = 
        let(
            leng_rot_matrice = len(rot_matrice),
            leng_rot_matrice_minus_one = leng_rot_matrice - 1,
            leng_rot_matrice_minus_two = leng_rot_matrice - 2
        )
        leng_rot_matrice == 0 ? [identity_matrix] : (
            leng_rot_matrice == 1 ? [rot_matrice[0], identity_matrix] : (
                i == leng_rot_matrice_minus_two ? 
               [
                   rot_matrice[leng_rot_matrice_minus_one], 
                   rot_matrice[leng_rot_matrice_minus_two] * rot_matrice[leng_rot_matrice_minus_one]
               ] 
               : cumulated_rot_matrice_sub(i, rot_matrice)
            )
        );

    function cumulated_rot_matrice_sub(i, rot_matrice) = 
        let(
            matrice = cumulated_rot_matrice(i + 1, rot_matrice),
            curr_matrix = rot_matrice[i],
            prev_matrix = matrice[len(matrice) - 1]
        )
        concat(matrice, [curr_matrix * prev_matrix]);

    // align modules

    module align_with_pts_angles(i) {
        translate(points[i]) 
            rotate(angles[i])
                rotate(twist_step_a * i) 
                        scale([1, 1, 1] + scale_step_vt * i) 
                            children(0);
    }

    module align_with_pts_init(a, s) {
        angleyz = __angy_angz(points[0], points[1]);
        rotate([0, -angleyz[0], angleyz[1]])
            rotate([90, 0, -90])
                rotate(a)
                    scale(s) 
                        children(0);
    }
    
    module align_with_pts_local_rotate(j, init_a, init_s, cumu_rot_matrice) {
        if(j == 0) {  // first child
            align_with_pts_init(init_a, init_s) 
                children(0);
        }
        else {
            multmatrix(cumu_rot_matrice[j - 1])
                align_with_pts_init(init_a, init_s) 
                    children(0);
        }
    } 

    if(angles != undef) {
        if($children == 1) { 
            for(i = [0:leng_points_minus_one]) {
                align_with_pts_angles(i) children(0);
            }
        } else {
            for(i = [0:min(leng_points, $children) - 1]) {
                align_with_pts_angles(i) children(i);
            }
        }
    }
    else {
        cumu_rot_matrice = cumulated_rot_matrice(0, [
            for(ang_vect = local_ang_vects(leng_points - 2)) 
                m_rotation(ang_vect[0], ang_vect[1])
        ]);

        translate(points[0])
            align_with_pts_local_rotate(0, 0, [1, 1, 1], cumu_rot_matrice)
                children(0); 

        if($children == 1) { 
            for(i = [0:leng_points - 2]) {
                translate(points[i + 1])
                    align_with_pts_local_rotate(i, i * twist_step_a, [1, 1, 1] + scale_step_vt * i, cumu_rot_matrice)
                        children(0);          
            }          
        } else {
            for(i = [0:min(leng_points, $children) - 2]) {
                translate(points[i + 1])
                    align_with_pts_local_rotate(i, i * twist_step_a, [1, 1, 1] + scale_step_vt * i, cumu_rot_matrice)
                        children(i + 1);   
            }
        }
    }
}