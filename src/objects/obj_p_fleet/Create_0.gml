
owner  = eFACTION.Player;
capital_number=0;
frigate_number=0;
escort_number=0;
selected=0;
orbiting=0;
warp_able=true;
ii_check=choose(8,9,10,11,12);

var wop=instance_nearest(x,y,obj_star);
if (instance_exists(wop)) and (y>0) and (x>0){
    if (point_distance(x,y,wop.x,wop.y)<=40){
        orbiting=wop;wop.present_fleet[1]+=1;
    }
}


image_xscale=1.25;image_yscale=1.25;

var i=-1;
capital = array_create(50, "");
capital_num = array_create(50, 0);
capital_sel = array_create(50, 1);
capital_uid = array_create(50, 0);

frigate = array_create(100, "");
frigate_num = array_create(100, 0);
frigate_sel = array_create(100, 1);
frigate_uid = array_create(100, 0);

escort = array_create(100, "");
escort_num = array_create(100, 0);
escort_sel = array_create(100, 1);
escort_uid = array_create(100, 0);


image_speed=0;

fix=2;

capital_health=100;
frigate_health=100;
escort_health=100;

complex_route = [];
just_left=false;


action="";
action_x=0;
action_y=0;
action_spd=128;
action_eta=0;
connected=0;
acted=0;
hurssy=0;
hurssy_time=0;
