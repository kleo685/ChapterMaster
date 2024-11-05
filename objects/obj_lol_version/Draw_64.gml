
if (obj_main_menu.stage>2){
    var version_line;
    
    version_line = $"v{GM_version}";
    
    draw_set_alpha(0.6);
    draw_set_font(fnt_cul_14);
    draw_set_color(c_gray);
    draw_set_halign(fa_right);
    draw_text(1598, 878, version_line);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}
