function screen_fade_in() {
    instance_create_depth(0, 0, -9999, obj_screen_fade)
    obj_screen_fade.fading_in = true;
    show_debug_message("Fading-in switched ON! 1");
}

function screen_fade_out(cycle_end_function = undefined, cycle_end_function_args = []) {
    instance_create_depth(0, 0, -9999, obj_screen_fade)
    obj_screen_fade.fading_out = true;
    obj_screen_fade.cycle_end_function = cycle_end_function;
    obj_screen_fade.cycle_end_function_args = cycle_end_function_args;
}

function set_interaction_cooldown(cooldown = 60) {
    instance_create_depth(0, 0, -9999, obj_interaction_cooldown)
    obj_interaction_cooldown.interaction_cooldown = cooldown * (room_speed / 30);
}
