

var i,xx,yy,x2,y2,cost,multiple;i=0;
xx=__view_get( e__VW.XView, 0 )+0;
yy=__view_get( e__VW.YView, 0 )+0;

x2=962;
y2=107;


if (mouse_x>=xx+1262) and (mouse_y>=yy+82) and (mouse_x<=xx+1417) and (mouse_y<yy+103) and (obj_controller.cooldown<=0){
    var onceh;onceh=0;obj_controller.cooldown=8000;
    if (target_comp>=1) and (onceh=0) then target_comp+=1;
    if (target_comp>obj_ini.companies) then target_comp=1;
    obj_controller.new_vehicles=target_comp;
}

draw_rectangle(xx+957,yy+76,xx+1062,yy+104,0);
draw_rectangle(xx+1068,yy+76,xx+1150,yy+104,0);
draw_rectangle(xx+1167,yy+76,xx+1255,yy+104,0);
draw_rectangle(xx+1487,yy+76,xx+1545,yy+104,0);

draw_set_color(c_black);

draw_text_transformed(xx+960,yy+76,string_hash_to_newline("Equipment"),0.6,0.6,0);
draw_text_transformed(xx+1070,yy+76,string_hash_to_newline("Armour"),0.6,0.6,0);
draw_text_transformed(xx+1170,yy+76,string_hash_to_newline("Vehicles"),0.6,0.6,0);
draw_text_transformed(xx+1490,yy+76,string_hash_to_newline("Ships"),0.6,0.6,0);


/* */
/*  */
