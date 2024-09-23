
if (obj_controller.cooldown<=0){
    var x2,y2,wid,hei;
    x2=__view_get( e__VW.XView, 0 )+x1;
    y2=__view_get( e__VW.YView, 0 )+y1;
    
    if (header=3){wid=177;hei=200;}
    if (header=2){wid=175;hei=200;}
    if (header=1){wid=150;hei=320;}
    
    if point_in_area(x2,y2,x2+wid,y2+hei){
        obj_controller.cooldown=8000;
        obj_controller.managing=manage;
        var new_manage = manage;
        with(obj_controller){
            switch_view_company(new_manage);
        }
    }
}

