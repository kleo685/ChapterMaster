// Values for outsiders:
fading_out = false;
disable_full_animation = false;
fading_length = 60 * (room_speed / 30);
delay_length = 5 * (room_speed / 30);
cycle_end_function = undefined;
cycle_end_function_args = [];

// Internal values:
fading_in = false;
fading_paused = false;
fading_delay_current = 0;
fading_current = 0;
fading_relative = 0;

