var stop;
stop = 0;

// if (follow_control = true) && instance_exists(obj_controller) {}
/*
if (button_id == 1) {
    wid = 142 * scaling;
    hei = 43 * scaling;
    if (mouse_y >= view_yview[0] + y) && (mouse_y <= view_yview[0] + y + hei) {
        if (mouse_x >= view_xview[0] + x) && (mouse_x <= view_xview[0] + x + wid) {
            if (mouse_x >= view_xview[0] + x + (134 * scaling)) {
                var dif1, dif2;
                dif1 = mouse_x - (view_xview[0] + x + (134 * scaling));
                dif2 = dif1 * 1.25;
                if (mouse_y < view_yview[0] + y + dif2) {
                    stop = 1;
                }
            }
            if (stop == 0) {
                highlighted = true;
            }
        }
    }
}
*/

if (highlighted == true) && instance_exists(obj_ingame_menu) {
    if (obj_ingame_menu.fading > 0) && (target >= 10) {
        highlighted = false;
    }
}
if (highlighted == true) && (highlight < 0.5) {
    highlight += 0.02;
}
if (highlighted == false) && (highlight > 0) {
    highlight -= 0.04;
}

if (scanline_enabled) {
    var freq;
    freq = 150;
    if (line_x > 0) {
        line_x += delta_time/10000;
    }
    if (line_x > wid * 0.95) {
        line_x = 0;
    }
    if (line_x == 0) && (floor(random(freq)) == 3) {
        line_x = 1;
    }
}

