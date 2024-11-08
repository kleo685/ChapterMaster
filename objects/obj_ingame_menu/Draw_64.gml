if (yam < 1) then exit;

if (settings = 1) {
    draw_set_color(0);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), 0);

    draw_set_alpha(1);
    // draw_sprite(spr_ingame_menu,1,476,114);
    scr_image("menu", 1, 476, 114, 562, 631);

    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    draw_set_font(fnt_cul_14);
    draw_text_transformed(763, 149, string_hash_to_newline("Settings"), 1.5, 1.5, 0);

    draw_set_halign(fa_left);
    draw_set_font(fnt_cul_18);
    draw_text(493, 224, string_hash_to_newline("Master Volume"));
    draw_text(493, 281, string_hash_to_newline("Effects Volume"));
    draw_text(493, 339, string_hash_to_newline("Music Volume"));
    draw_text(493, 423, string_hash_to_newline("Full Screen?:"));
    // draw_text(493,423+59,string_hash_to_newline("Large Text?:"));
    // draw_text(493,483+59,string_hash_to_newline("Heresy?:"));

    draw_set_color(0); // 264 long
    draw_rectangle(710, 224, 974, 254, 0);
    draw_rectangle(710, 282, 974, 312, 0);
    draw_rectangle(710, 338, 974, 368, 0);

    var bar, change_volume;
    bar = 0;
    change_volume = 0;
    draw_set_color(38144);
    if (master_volume > 0) then bar = (master_volume / 1.3) * 264;
    if (master_volume > 0) then draw_rectangle(710, 224, 710 + bar, 254, 0);
    if (effect_volume > 0) then bar = (effect_volume / 1.3) * 264;
    if (effect_volume > 0) then draw_rectangle(710, 282, 710 + bar, 312, 0);
    if (music_volume > 0) then bar = (music_volume / 1.3) * 264;
    if (music_volume > 0) then draw_rectangle(710, 338, 710 + bar, 368, 0);
    bar = 0;

    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_text(842, 227, string_hash_to_newline(string(floor(master_volume * 100)) + "%"));
    draw_text(842, 285, string_hash_to_newline(string(floor(effect_volume * 100)) + "%"));
    draw_text(842, 341, string_hash_to_newline(string(floor(music_volume * 100)) + "%"));

    draw_rectangle(710, 224, 974, 254, 1);
    draw_rectangle(710, 282, 974, 312, 1);
    draw_rectangle(710, 338, 974, 368, 1);

    draw_sprite_stretched(spr_creation_arrow, 0, 671, 223, 32, 32); // MV left
    draw_sprite_stretched(spr_creation_arrow, 1, 981, 223, 32, 32); // MV right
    draw_sprite_stretched(spr_creation_arrow, 0, 671, 281, 32, 32); // EV left
    draw_sprite_stretched(spr_creation_arrow, 1, 981, 281, 32, 32); // EV right
    draw_sprite_stretched(spr_creation_arrow, 0, 671, 339, 32, 32); // MV left
    draw_sprite_stretched(spr_creation_arrow, 1, 981, 339, 32, 32); // MV right

    bar = settings_fullscreen;
    draw_sprite(spr_creation_check, bar, 626, 426);
    // bar=large_text;draw_sprite(spr_creation_check,bar,622,426+59);
    // bar=settings_heresy;draw_sprite(spr_creation_check,bar,590,485+59);

    if (point_and_click([671, 223, 671 + 32, 223 + 32])) and(master_volume > 0) {
        change_volume = 1;
        master_volume -= 0.1;
    }
    if (point_and_click([671, 281, 671 + 32, 281 + 32])) and(effect_volume > 0) {
        change_volume = 1;
        effect_volume -= 0.1;
    }
    if (point_and_click([671, 339, 671 + 32, 339 + 32])) and(music_volume > 0) {
        change_volume = 1;
        music_volume -= 0.1;
    }
    if (point_and_click([981, 223, 981 + 32, 223 + 32])) and(master_volume < 1.3) {
        change_volume = 1;
        master_volume += 0.1;
    }
    if (point_and_click([981, 281, 981 + 32, 281 + 32])) and(effect_volume < 1.3) {
        change_volume = 1;
        effect_volume += 0.1;
    }
    if (point_and_click([981, 339, 981 + 32, 339 + 32])) and(music_volume < 1.3) {
        change_volume = 1;
        music_volume += 0.1;
    }

    if (point_and_click([626, 426, 626 + 32, 426 + 32])) {
        if (settings_fullscreen = 1) {
            settings_fullscreen = 0;
            window_set_fullscreen(false);
            change_volume = 2;
        } else if (settings_fullscreen = 0) {
            settings_fullscreen = 1;
            window_set_fullscreen(true);
            change_volume = 2;
        }
    }
    // if (scr_hit(622,426+59,622+32,426+32+59)=true){
    //     if (large_text=1) and (onceh=0){onceh=1;cooldown=8000;large_text=0;change_volume=2;}
    //     if (large_text=0) and (onceh=0){onceh=1;cooldown=8000;large_text=1;change_volume=2;}
    // }
    // if (scr_hit(590,485+59,590+32,485+32+59)=true){
    //     if (settings_heresy=1) and (onceh=0){onceh=1;cooldown=8000;settings_heresy=0;change_volume=2;}
    //     if (settings_heresy=0) and (onceh=0){onceh=1;cooldown=8000;settings_heresy=1;change_volume=2;}
    // }

    if (change_volume = 1) {
        if (audio_is_playing(snd_royal)) {
            var nope;
            nope = 0;
            if (master_volume = 0) or(music_volume = 0) then nope = 1;
            if (nope != 1) {
                audio_sound_gain(snd_royal, 0.25 * master_volume * music_volume, 0);
            }
            if (nope = 1) {
                audio_sound_gain(snd_royal, 0, 0);
            }
        }
        if (instance_exists(obj_controller)) {
            obj_controller.master_volume = master_volume;
            obj_controller.effect_volume = effect_volume;
            obj_controller.music_volume = music_volume;
            // obj_controller.large_text=large_text;
            // obj_controller.settings_heresy=settings_heresy;
            obj_controller.settings_fullscreen = settings_fullscreen;
        }
        if (instance_exists(obj_main_menu)) {
            if (audio_is_playing(global.sound)) and(audio_is_playing(snd_prologue)) {
                var nope;
                nope = 0;
                if (master_volume = 0) or(music_volume = 0) then nope = 1;
                if (nope != 1) {
                    audio_sound_gain(global.sound, 0.25 * master_volume * music_volume, 0);
                }
                if (nope = 1) {
                    audio_sound_gain(global.sound, 0, 0);
                }
            }
            if (!audio_is_playing(global.sound)) and(!audio_is_playing(snd_prologue)) and(master_volume > 0) and(music_volume > 0) {
                global.sound = audio_play_sound(snd_prologue, 0, true);
                audio_sound_gain(global.sound, 0.25 * master_volume * music_volume, 0);
            }

            obj_main_menu.master_volume = master_volume;
            obj_main_menu.effect_volume = effect_volume;
            obj_main_menu.music_volume = music_volume;
            // obj_main_menu.large_text=large_text;
            // obj_main_menu.settings_heresy=settings_heresy;
            obj_main_menu.settings_fullscreen = settings_fullscreen;
        }
    }
    if (change_volume > 0) {
        ini_open("saves.ini");
        ini_write_real("Settings", "master_volume", master_volume);
        ini_write_real("Settings", "effect_volume", effect_volume);
        ini_write_real("Settings", "music_volume", music_volume);
        // ini_write_real("Settings","large_text",large_text);
        // ini_write_real("Settings","settings_heresy",settings_heresy);
        ini_write_real("Settings", "fullscreen", settings_fullscreen);
        ini_close();
    }
}

if (instance_exists(obj_saveload)) or(settings = 1) then exit;

draw_set_color(0);
draw_set_alpha(0.75);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), 0);

draw_set_alpha(1);
// draw_sprite(spr_ingame_menu,0,476,114);
scr_image("menu", 0, 476, 114, 562, 631);

draw_set_color(c_gray);
draw_set_halign(fa_center);
draw_set_font(fnt_cul_14);
draw_text_transformed(929, 149, string_hash_to_newline("Menu"), 1.5, 1.5, 0);

if (room_get_name(room) != "Main_Menu") {
    if (point_and_click(draw_unit_buttons([0, 0], "Exit", [2,2], c_green,,,,true,))) {
        screen_fade_transition(function(){
            audio_stop_all();
            with(obj_ini) {
                instance_destroy();
            }
            room_goto(Main_Menu);
        });
    }
}