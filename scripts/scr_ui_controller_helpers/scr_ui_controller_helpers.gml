function screen_fade_in() {
    instance_create_depth(0, 0, -9999, obj_screen_fade)
    obj_screen_fade.fading_in = true;
    show_debug_message("Fading-in switched ON! 1");
}

function screen_fade_transition(func, func_args = []) {
    instance_create_depth(0, 0, -999999, obj_screen_fade)
    obj_screen_fade.fading_out = true;
    obj_screen_fade.cycle_end_function = func;
    obj_screen_fade.cycle_end_function_args = func_args;
}

function set_interaction_cooldown(cooldown = 60) {
    instance_create_depth(0, 0, -9999, obj_interaction_cooldown)
    obj_interaction_cooldown.interaction_cooldown = cooldown * (room_speed / 30);
}
