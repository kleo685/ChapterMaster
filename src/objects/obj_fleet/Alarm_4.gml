
with(obj_p_ship){instance_destroy();}
with(obj_p_th){instance_destroy();}
with(obj_en_ship){instance_destroy();}
with(obj_en_in){instance_destroy();}
with(obj_al_ship){instance_destroy();}
with(obj_al_in){instance_destroy();}
with(obj_fleet_controller){instance_destroy();}
with(obj_p_round){instance_destroy();}
with(obj_en_round){instance_destroy();}
with(obj_al_round){instance_destroy();}
with(obj_p_assra){instance_destroy();}
with(obj_en_husk){instance_destroy();}

instance_activate_all();
obj_controller.combat=0;
instance_activate_object(obj_turn_end);
// instance_activate_object(obj_star_select);
// show_message(obj_turn_end.current_battle);


if (player_started=0){
    with(obj_turn_end){
        current_battle+=1;
        alarm[0]=1;
    }
}
if (player_started=1){
    var taxt;taxt="";

    taxt=string(global.chapter_name)+" engage and destroy a";
    if (enemy[1]=2) or (enemy[1]=4) or (enemy[1]=5) or (enemy[1]=6) then taxt+="n";
    taxt+=" "+string(obj_controller.faction[enemy[1]]);
    taxt+=" fleet at "+string(ene_fleet.name)+".";scr_event_log("",taxt);
    
    if (instance_exists(obj_star_select)) then with(obj_star_select){
        alarm[1]=1;player_fleet=0;
        var i;i=-1;repeat(15){i+=1;en_fleet[i]=0;}
    }
    if (instance_exists(pla_fleet)){
        pla_fleet.acted=2;
        if (capital+frigate+escort=0) then with(pla_fleet){instance_destroy();}
    }
    if (enemy[1]!=4) and (obj_controller.faction_status[enemy[1]]!="War"){
        obj_controller.audiences+=1;obj_controller.audien[obj_controller.audiences]=enemy[1];
        obj_controller.audien_topic[obj_controller.audiences]="declare_war";
        obj_controller.disposition[enemy[1]]-=20;
    }
}

if (view_x+view_y>0){
    obj_controller.x=view_x;
    obj_controller.y=view_y;
}




// show_message(obj_turn_end.current_battle);
with(obj_controller){instance_activate_all();}
instance_destroy();
