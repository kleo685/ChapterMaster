

image_angle=direction;
if (cooldown1>0) then cooldown1-=1;

var dist, range;
if (instance_exists(target)){


    dist=point_distance(x,y,target.x,target.y);
    range=100+max(sprite_get_width(target.sprite_index),sprite_get_height(target.sprite_index));
    
    if (action="close"){speed=4;direction=turn_towards_point(direction,x,y,target.x,target.y,8);}
    if (dist<range) and (dist>100) and (action="close") then action="shoot";
    if (action="shoot") and (dist>range) then action="close";
    if (dist<80) and (action="shoot") then action="bank";
    if (action="bank") then direction=turn_towards_point(direction,x,y,0,room_height/2,4);
    if (action="bank") and (dist>300) then action="close";
    
    
    if (action="shoot") and (cooldown1<=0){
        var bull;cooldown1=30;
        bull=instance_create(x,y,obj_p_round);bull.direction=self.direction;
        bull.speed=20;bull.image_xscale=0.5;bull.image_yscale=0.5;bull.dam=3;
    }
    
    
}


if (!instance_exists(target)){

if (instance_exists(obj_en_in)){
    var n, ins;
    n = floor(random(instance_number(obj_en_in))) // get a random whole number based on obj amount
    ins = instance_find( obj_en_in , n ) // find that n'th instance of that type
    target=ins;
}


if (!instance_exists(obj_en_in)){
    var n, ins;
    n = floor(random(instance_number(obj_en_ship))) // get a random whole number based on obj amount
    ins = instance_find( obj_en_ship , n ) // find that n'th instance of that type
    target=ins;
}

}




if (hp<=0){instance_create(x,y,obj_explosion);instance_destroy();}

