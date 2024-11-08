if (fading_out) {
    obj_ui_controller.interaction_forbid = true;
    obj_cursor.image_alpha = 0;
    if (fading_current < fading_length) {
        var fading_relative = fading_current / fading_length;
        draw_rectangle_color_simple(x, y, room_width, room_height, 0, 0, fading_relative);
        fading_current += 1;
        // show_debug_message(fading_current);
    } else {
        fading_current = 0;
        fading_out = false;
        fading_paused = true;
        fading_delay_current = 0;
        if (cycle_end_function) != undefined {
            method_call(cycle_end_function, cycle_end_function_args);
        }
    }
}

if (fading_paused) {
    obj_cursor.image_alpha = 0;
    draw_rectangle_color_simple(x, y, room_width, room_height, 0, 0, 1);
    show_debug_message("I'm paused!");
    fading_delay_current += 1;
    if (fading_delay_current >= delay_length) {
        if (disable_full_animation) {
            show_debug_message("I'm destroyed!");
            instance_destroy();
        }
        show_debug_message("I'm unpaused!");
        fading_paused = false;
        fading_in = true;
        show_debug_message("Fading-in switched ON! 2");
    }
}

if (fading_in) {
    obj_ui_controller.interaction_forbid = true;
    obj_cursor.image_alpha = 0;
    if (fading_current < fading_length) {
        var fading_relative = 1 - (fading_current / fading_length);
        draw_rectangle_color_simple(x, y, room_width, room_height, 0, 0, fading_relative);
        fading_current += 1;
        // show_debug_message(fading_current);
    } else {
        fading_current = 0;
        fading_in = false;
        show_debug_message("Fading-in switched OFF!");
        obj_ui_controller.interaction_forbid = false;
        obj_cursor.image_alpha = 1;
        show_debug_message("I faded in!");
        instance_destroy();
    }
}