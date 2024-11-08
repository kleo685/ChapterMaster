yam = 0;
if (instance_exists(obj_controller)) {
    obj_controller.cooldown = 8000;
    yam = 999;
}
fading = 0;
effect = 0;
settings = 0;

ini_open("saves.ini");
master_volume = ini_read_real("Settings", "master_volume", 1);
effect_volume = ini_read_real("Settings", "effect_volume", 1);
music_volume = ini_read_real("Settings", "music_volume", 1);
large_text = ini_read_real("Settings", "large_text", 0);
settings_heresy = ini_read_real("Settings", "settings_heresy", 0);
settings_fullscreen = ini_read_real("Settings", "fullscreen", 1);
settings_window_data = ini_read_string("Settings", "window_data", "fullscreen");
ini_close();

// create the buttons
var butt;

if (room_get_name(room) != "Main_Menu") {
    butt = instance_create(821, 256, obj_new_button);
    butt.sprite_index = spr_ui_but_1;
    butt.depth = -20010;
    butt.button_text = "Save";
    butt.button_id = 1;
    butt.scaling = 1.5;
    butt.target = 11;

    butt = instance_create(821, 336, obj_new_button);
    butt.sprite_index = spr_ui_but_1;
    butt.depth = -20010;
    butt.button_text = "Load";
    butt.button_id = 1;
    butt.scaling = 1.5;
    butt.target = 12;

    butt = instance_create(821, 416, obj_new_button);
    butt.sprite_index = spr_ui_but_1;
    butt.depth = -20010;
    butt.button_text = "Options";
    butt.button_id = 1;
    butt.scaling = 1.5;
    butt.target = 13;

    // butt = instance_create(821, 496, obj_new_button);
    // butt.sprite_index = spr_ui_but_1;
    // butt.depth = -20010;
    // butt.button_text = "Exit";
    // butt.button_id = 1;
    // butt.scaling = 1.5;
    // butt.target = 14;

    butt = instance_create(821, 666, obj_new_button);
    butt.sprite_index = spr_ui_but_1;
    butt.depth = -20010;
    butt.button_text = "Return";
    butt.button_id = 1;
    butt.scaling = 1.5;
    butt.target = 15;
}

if (room_get_name(room) = "Main_Menu") {
    with(obj_new_button) {
        instance_destroy();
    }
    settings = 1;

    butt = instance_create(653, 664, obj_new_button);
    butt.sprite_index = spr_ui_but_1;
    butt.depth = -20010;
    butt.button_text = "Exit";
    butt.button_id = 1;
    butt.scaling = 1.5;
    butt.target = 25;
}