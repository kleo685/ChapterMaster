if (fading_current < fading_length) {
    var fading_relative = fading_current / fading_length;
    if (fading_out) {
        draw_rectangle_color_simple(x, y, room_width, room_height, 0, 0, fading_relative);
    } else if (fading_in) {
        draw_rectangle_color_simple(x, y, room_width, room_height, 0, 0, 1 - fading_relative);
    }
    fading_current += 1;
    show_debug_message(fading_current);
} else {
    fading_in = 0;
    fading_out = 0;
    fading_length = 0;
}