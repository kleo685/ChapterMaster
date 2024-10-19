if (button_id = 1) {
    wid = 142 * scaling;
    hei = 43 * scaling;
} else if (button_id = 2) {
    wid = 142 * scaling;
    hei = 43 * scaling;
} else if (button_id = 3) {
    wid = 115 * scaling;
    hei = 43 * scaling;
} else if (button_id = 4) {
    wid = 108 * scaling;
    hei = 42 * scaling;
}

x2 = x + wid;
y2 = y + hei;

highlighted = false;
if (button_id > 0) {
    if (scr_hit(x, y, x2, y2)) {
        highlighted = true;
    }
}

if (point_and_click([x, y, x2, y2])) {
    if (target > 10) {
        obj_ingame_menu.effect = target;
    } else if (target = 9) {
        with(obj_saveload) {
            instance_destroy();
        }
        instance_destroy();
    }
}

draw_set_alpha(1);

if (button_id = 1) then draw_sprite_ext(spr_ui_but_1, 0, x, y, scaling, scaling, 0, c_white, 1);
if (button_id = 2) then draw_sprite_ext(spr_ui_but_2, 0, x, y, scaling, scaling, 0, c_white, 1);
if (button_id = 3) then draw_sprite_ext(spr_ui_but_3, 0, x, y, scaling, scaling, 0, c_white, 1);
if (button_id = 4) then draw_sprite_ext(spr_ui_but_4, 0, x, y, scaling, scaling, 0, c_white, 1);

draw_set_blend_mode(bm_add);
// draw_set_alpha(highlight*2);
if (button_id = 1) and(highlight > 0) then draw_sprite_ext(spr_ui_hov_1, 0, x, y, scaling, scaling, 0, c_white, highlight * 2);
if (button_id = 2) and(highlight > 0) then draw_sprite_ext(spr_ui_hov_2, 0, x, y, scaling, scaling, 0, c_white, highlight * 2);
if (button_id = 3) and(highlight > 0) then draw_sprite_ext(spr_ui_hov_3, 0, x, y, scaling, scaling, 0, c_white, highlight * 2);
if (button_id = 4) and(highlight > 0) then draw_sprite_ext(spr_ui_hov_4, 0, x, y, scaling, scaling, 0, c_white, highlight * 2);
draw_set_blend_mode(bm_normal);
// draw_set_alpha(1);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_font(fnt_cul_14);
draw_text_transformed(x + (sprite_width / 2) * scaling, y + (sprite_height / 5) * scaling, string_hash_to_newline(button_text), scaling, scaling, 0);


if (scanline_enabled) {
    var line_y = y + (hei * 0.1);
    var line_height = hei * 0.8;

    draw_set_alpha(0.15);

    if (line_x > 0) and (button_id <= 2) {
        draw_line(x + line_x, line_y, x + line_x, line_y + line_height);
    }

    draw_set_alpha(1);
}