// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_fleet_advisor(){
	//TODO swap this xx yy stuff out for a surface
	var xx = __view_get(e__VW.XView, 0) + 0;
    var yy = __view_get(e__VW.YView, 0) + 0;
	draw_sprite(spr_rock_bg, 0, xx, yy);
    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
    draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);
    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

    if (menu_adept = 0) {
        scr_image("advisor", 6, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,6,xx+16,yy+43);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 66, "Flagship Bridge", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, $"Master of the Fleet {obj_ini.lord_admiral_name}", 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
        blurp = "Greetings, Chapter Master.\n\nYou requested a report?  Our fleet contains ";
    }
    if (menu_adept = 1) {
        scr_image("advisor", 0, xx + 16, yy + 43, 310, 828);
        // draw_sprite(spr_advisors,0,xx+16,yy+43);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 336 + 16, yy + 40, "Flagship Bridge", 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, $"Adept {obj_controller.adept_name}" , 0.6, 0.6, 0);
        draw_set_font(fnt_40k_14);
        blurp = "Your fleet contains ";
    }

    blurp += string(temp[37]) + " Capital Ships, ";
    blurp += string(temp[38]) + " Frigates, and ";
    blurp += string(temp[39]) + " Escorts";

    va = real(temp[41]);

    if (va >= 1) then blurp += ", none of which are damaged.";
    if (va < 1) then blurp += $".  Our most damaged vessel is the {temp[40]} - it has {min(99, round(va * 100))}% Hull Integrity.";

    va = real(temp[42]);
    if (va = 2) then blurp += "  Two of our ships are highly damaged.  You may wish to purchase a Repair License from the Sector Governerner.";
    if (va > 2) then blurp += "  Several of our ships are highly damaged.  It is advisable that you purchase a Repair License from the Sector Governer.";
    blurp += "\n\nHere are the current positions of our ships and their contents:";

    if (menu_adept = 1) {
        blurp = string_replace(blurp, "Our", "Your");
        blurp = string_replace(blurp, " our", " your");
        blurp = string_replace(blurp, "We", "You");
    }

    draw_text_ext(xx + 336 + 16, yy + 130, blurp, -1, 536);

    draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_text_transformed(xx + 1262, yy + 40, "Fleet", 0.6, 0.6, 0);

    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);

    var cn = obj_controller;

    // TODO: Probably a good idea to turn this whole interactive list/sheet generating logic into a constructor, that can be reused on many screens.
    // I have no passion for this atm.
    if (instance_exists(cn)) {
        var _header_offset = 80;
        var _row_height = 20;
        var _row_gap = 2;
        var _columns = {
            name: {
                w: 176,
                text: "Name",
                h_align: fa_left,
            },
            class: {
                w: 154,
                text: "Class",
                h_align: fa_left,
            },
            location: {
                w: 130,
                text: "Location",
                h_align: fa_left,
            },
            hp: {
                w: 44,
                text: "HP",
                h_align: fa_right,
            },
            carrying: {
                w: 84,
                text: "Carrying",
                h_align: fa_right,
            },
        };

        var _column_x = xx + 953; 
        var _columns_array = ["name", "class", "location", "hp", "carrying"];

        for (var i = 0; i < array_length(_columns_array); i++) {
            with(_columns[$ _columns_array[i]]) {
                x1 = _column_x;
                _column_x += w;
                x2 = x1 + w;
                y1 = yy + _header_offset;
                header_y = (y1 - 2);
                switch (h_align) {
                case fa_right:
                    header_x = x2;
                    break;
                case fa_center:
                    header_x = (x1 + x2) / 2;
                    break;
                case fa_left:
                default:
                    header_x = x1;
                    break;
                }
                draw_set_halign(h_align);
                draw_text(header_x, header_y, text);
            }
        }
        draw_set_halign(fa_left);

        for (var i = ship_current; i < ship_current + 34; i++) {
            if (obj_ini.ship[i] != "") {
                var _row_y = yy + _header_offset + (i * (_row_height + _row_gap));
                draw_rectangle(xx + 950, _row_y, xx + 1546, _row_y + _row_height, 1);

                var _goto_button = {
                    x1: _columns.location.x1 - 20,
                    y1: _row_y + 4,
                    sprite: spr_view_small,
                    click: function() {
                        return point_and_click([x1, y1, x2, y2]);
                    }
                };
                with(_goto_button) {
                    w = sprite_get_width(sprite);
                    h = sprite_get_height(sprite);
                    x2 = x1 + w;
                    y2 = y1 + h;
                    draw_sprite(sprite, 0, x1, y1);
                }

                with(_columns) {
                    name.contents = string_truncate(obj_ini.ship[i], _columns.name.w - 6);
                    class.contents = obj_ini.ship_class[i];
                    location.contents = obj_ini.ship_location[i];
                    hp.contents = $"{round(obj_ini.ship_hp[i] / obj_ini.ship_maxhp[i] * 100)}%";
                    carrying.contents = $"{obj_ini.ship_carrying[i]}/{obj_ini.ship_capacity[i]}";
                }

                for (var g = 0; g < array_length(_columns_array); g++) {
                    with(_columns[$ _columns_array[g]]) {
                        draw_set_halign(h_align);
                        switch (h_align) {
                            case fa_right:
                                draw_text(x2, _row_y, contents);
                                break;
                            case fa_center:
                                draw_text((x1 + x2) / 2, _row_y, contents);
                                break;
                            case fa_left:
                            default:
                                draw_text(x1, _row_y, contents);
                                break;
                            }
                    }
                }

                if scr_hit(xx + 950, _row_y, xx + 1546, yy + 100 + (i * (_row_height + _row_gap))) {
                    if (cn.temp[101] != obj_ini.ship[i]) {
                        cn.temp[101] = obj_ini.ship[i];
                        cn.temp[102] = obj_ini.ship_class[i];

                        cn.temp[103] = string(obj_ini.ship_hp[i]);
                        cn.temp[104] = string(obj_ini.ship_maxhp[i]);
                        cn.temp[105] = string(obj_ini.ship_shields[i] * 100);

                        cn.temp[106] = string(obj_ini.ship_speed[i]);

                        cn.temp[107] = string(obj_ini.ship_front_armour[i]);
                        cn.temp[108] = string(obj_ini.ship_other_armour[i]);

                        cn.temp[109] = string(obj_ini.ship_turrets[i]);

                        cn.temp[110] = obj_ini.ship_wep[i][1];
                        cn.temp[111] = obj_ini.ship_wep_facing[i][1];
                        cn.temp[112] = obj_ini.ship_wep[i][2];
                        cn.temp[113] = obj_ini.ship_wep_facing[i][2];
                        cn.temp[114] = obj_ini.ship_wep[i][3];
                        cn.temp[115] = obj_ini.ship_wep_facing[i][3];
                        cn.temp[116] = obj_ini.ship_wep[i][4];
                        cn.temp[117] = obj_ini.ship_wep_facing[i][4];

                        cn.temp[118] = $"{obj_ini.ship_carrying[i]}/{obj_ini.ship_capacity[i]}";
                        cn.temp[119] = "";
                        if (obj_ini.ship_carrying[i] > 0) then cn.temp[119] = scr_ship_occupants(i);
                    }
                    tooltip_draw($"Carrying ({cn.temp[118]}): {cn.temp[119]}");
                    if (_goto_button.click()) {
                        obj_controller.temp[40] = obj_ini.ship[i];
                        with(obj_p_fleet) {
                            for (var k = 0; k <= 40; k++) {
                                if (capital[k] == obj_controller.temp[40]) then instance_create(x, y, obj_temp7);
                                if (frigate[k] == obj_controller.temp[40]) then instance_create(x, y, obj_temp7);
                                if (escort[k] == obj_controller.temp[40]) then instance_create(x, y, obj_temp7);
                            }
                        }
                        if (instance_exists(obj_temp7)) {
                            obj_controller.x = obj_temp7.x;
                            obj_controller.y = obj_temp7.y;
                            obj_controller.menu = 0;
                            with(obj_fleet_show) {
                                instance_destroy();
                            }
                            instance_create(obj_temp7.x, obj_temp7.y, obj_fleet_show);
                            with(obj_temp7) {
                                instance_destroy();
                            }
                        }
                    }
                }
            }
        }

        if (cn.temp[101] != "") {
            draw_set_font(fnt_40k_30b);
            draw_set_halign(fa_center);
            draw_text_transformed(xx + 622, yy + 434, cn.temp[101], 0.75, 0.75, 0);
            draw_text_transformed(xx + 622, yy + 464, cn.temp[102], 0.5, 0.5, 0);

            draw_set_color(c_gray);
            draw_rectangle(xx + 488, yy + 492, xx + 756, yy + 634, 1);
            var ships = ["Battle Barge", "Strike Cruiser","Gladius","Hunter"];
            var ship_im = 0;
            for (var i=0;i<array_length(ships);i++){
                if (cn.temp[102]==ships[i]){
                    ship_im=i;
                    break;
                }
            }
            draw_set_color(c_white);
            draw_sprite(spr_ship_back_white, ship_im, xx + 488, yy + 492);

            draw_set_color(c_gray);
            draw_set_font(fnt_40k_14);
            draw_set_halign(fa_left);

            draw_text(xx + 383, yy + 655, $"Health: {cn.temp[103]}/{cn.temp[104]}");
            draw_text(xx + 588, yy + 655, $"Shields: {cn.temp[105]}" );
            draw_text(xx + 768, yy + 655, $"Armour: {cn.temp[107]},{cn.temp[108]}");

            draw_text(xx + 495, yy + 675, $"Speed: {cn.temp[106]}");
            draw_text(xx + 680, yy + 675, $"Turrets: {cn.temp[109]}");

            if (cn.temp[110] != "") {
                draw_text(xx + 383, yy + 705, $"-{cn.temp[110]} ({cn.temp[111]})");
            }
            if (cn.temp[112] != "") {
                draw_text(xx + 383, yy + 725, "-" + cn.temp[112] + " (" + string(cn.temp[113]) + ")");
            }
            if (cn.temp[114] != "") {
                draw_text(xx + 383, yy + 745, "-" + cn.temp[114] + " (" + string(cn.temp[115]) + ")");
            }
            if (cn.temp[116] != "") {
                draw_text(xx + 383, yy + 765, "-" + cn.temp[116] + " (" + string(cn.temp[117]) + ")");
            }

            draw_set_font(fnt_40k_12);
            // draw_text_ext(xx + 352, 775, $"Carrying ({cn.temp[118]}): {cn.temp[119]}", -1, 542);
            draw_set_font(fnt_40k_14);
        }
    }
    // 31 wide
    scr_scrollbar(1550, 100, 1577, 818, 34, ship_max, ship_current);
}