if (interaction_cooldown == 0) {
    obj_ui_controller.interaction_forbid = false;
    instance_destroy();
} else {
    interaction_cooldown -= 1;
}