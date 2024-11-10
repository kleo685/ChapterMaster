
if (hide=true) then exit;

if (cooldown>=0) and (cooldown<=40) then cooldown-=1;
if (instance_exists(obj_controller)){if (obj_controller.zoomed=1) then with(obj_controller){scr_zoom();}}


if keyboard_check_pressed(ord("1")) and (cooldown<=0) then press=1;
if keyboard_check_pressed(ord("2")) and (cooldown<=0) then press=2;
if keyboard_check_pressed(ord("3")) and (cooldown<=0) then press=3;
if (press=1) and (option1="") then press=0;
if (press=2) and (option2="") then press=0;
if (press=3) and (option3="") then press=0;
if (press!=0) and (cooldown>0){
    press=0;
    exit;
}

if (type!=6) and (master_crafted=1) then master_crafted=0;

if (type=9.1) and (obj_controller.stc_wargear_un+obj_controller.stc_vehicles_un+obj_controller.stc_ships_un<=0){
    obj_controller.cooldown=10;instance_destroy();exit;
}

if (image="fuklaw") and (save>0){
    if (press=1){
        var del;del=obj_saveload.save[self.save];
        if (file_exists("save"+string(del)+".ini")){
            file_delete("save"+string(del)+".ini");
            if (file_exists("save"+string(del)+"log.ini")){file_delete("save"+string(del)+"log.ini");}
            if (file_exists("screen"+string(del)+".png")){file_delete("screen"+string(del)+".png");}
            with(obj_saveload){instance_destroy();}
            var news=instance_create(0,0,obj_saveload);
            news.menu=woopwoopwoop;
            news.top=owner;
            news.alarm[4]=1;
            
            instance_destroy();
        }
    }
    if (press=2){instance_destroy();}
    exit;
}



if (room_get_name(room)="Main_Menu") and (title="Tutorial"){
    if (press=2){// 1: yes, 2: no (without disabling)
        obj_main_menu_buttons.fading=1;
        obj_main_menu_buttons.crap=3;
        obj_main_menu_buttons.cooldown=9999;
        instance_destroy();
    }
    if (press=3){ini_open("saves.ini");ini_write_real("Data","tutorial",1);ini_close();}
    
    if (press>=2){
        obj_main_menu_buttons.fading=1;
        obj_main_menu_buttons.crap=self.press;
        obj_main_menu_buttons.cooldown=9999;
        instance_destroy();
    }
    exit;
}




if (image="debug_banshee") and (cooldown<=0){
    if (planet=2){
        if (press=1) or (press=3){
            if (press=1) then amount=7;
            if (press=3) then amount=9;
            with(obj_star){
                if (choose(0,1,1)=1) and (owner != eFACTION.Eldar) and (owner!=1){
                    var fleet;
                    fleet=instance_create(x,y,obj_en_fleet);
                    fleet.owner=obj_popup.amount;
                    if (obj_popup.amount=7){fleet.sprite_index=spr_fleet_ork;fleet.capital_number=3;present_fleet[7]+=1;}
                    if (obj_popup.amount=9){
                        if (present_fleet[1]=0) then vision=0;
                        fleet.sprite_index=spr_fleet_tyranid;fleet.capital_number=3;fleet.frigate_number=6;fleet.escort_number=16;present_fleet[9]+=1;
                    }
                    fleet.image_index=4;
                    fleet.orbiting=id;
                }
            }
            instance_destroy();
        }
        if (press=2){
            with(obj_star){
                if (choose(0,1,1)=1) and (owner != eFACTION.Eldar) and (owner!=1){
                    var h;h=0;repeat(4){h+=1;if (p_type[h]!="Dead") and (p_type[h]!=""){p_traitors[h]=5;p_chaos[h]=4;}}
                }
            }
            instance_destroy();
        }
    }
    if (planet=5){
        if (press=1){
            var fleet,tar;tar=instance_nearest(x,y,obj_star);
            fleet=instance_create(tar.x,tar.y,obj_en_fleet);
            fleet.owner = eFACTION.Ork;fleet.sprite_index=spr_fleet_ork;
            fleet.capital_number=2;fleet.frigate_number=5;
            tar.present_fleet[7]+=1;fleet.image_index=4;
            fleet.orbiting=id;instance_destroy();
        }
        if (press=2){
            var fleet,tar;tar=instance_nearest(x,y,obj_star);
            fleet=instance_create(tar.x,tar.y,obj_en_fleet);
            fleet.owner = eFACTION.Tau;fleet.sprite_index=spr_fleet_tau;
            fleet.capital_number=2;fleet.frigate_number=5;
            tar.present_fleet[8]+=1;fleet.image_index=4;
            fleet.orbiting=id;instance_destroy();
        }
        if (press=3) then instance_destroy();
    }
    if (planet=3){
        if (press=1){
            var fleet,tar;tar=instance_nearest(x,y,obj_star);
            fleet=instance_create(tar.x,tar.y,obj_en_fleet);
            fleet.owner = eFACTION.Imperium;fleet.sprite_index=spr_fleet_imperial;
            fleet.capital_number=2;
            fleet.frigate_number=5;
            tar.present_fleet[2]+=1;
            fleet.image_index=4;
            fleet.orbiting=id;
            instance_destroy();
        }
        if (press=2){
            var fleet,tar;tar=instance_nearest(x,y,obj_star);
            fleet=instance_create(tar.x,tar.y,obj_en_fleet);
            fleet.owner = eFACTION.Chaos;fleet.sprite_index=spr_fleet_chaos;
            fleet.capital_number=2;fleet.frigate_number=5;
            tar.present_fleet[10]+=1;fleet.image_index=4;
            fleet.orbiting=id;
            instance_destroy();
        }
        if (press=3){
            planet=5;cooldown=30;
            text="Ork, Tau, Cancel?";
            option1="Ork";
            option2="Tau";
            option3="Cancel";
            press=0;exit;
        }
    }
    if (planet=1){
        if (press=1){planet=2;cooldown=30;text="Select a faction";option1="Orks";option2="Chaos";option3="Tyranids";press=0;exit;}
        if (press=2){planet=3;cooldown=30;text="Imperium, Heretic, or Xeno?";option1="Imperium";option2="Heretic";option3="Xeno";press=0;exit;}
        if (press=3){
            var flit1,flit2,onceh;onceh=0;
            flit1=instance_nearest(x,y,obj_p_fleet);
            flit2=instance_nearest(x,y,obj_en_fleet);
            
            if (instance_exists(flit1)) and (instance_exists(flit2)){
                if (point_distance(x,y,flit1.x,flit1.y)>point_distance(x,y,flit2.x,flit2.y)) then with(flit2){instance_destroy();}
                else with(flit1){instance_destroy();}
                onceh=1;
            }
            if (onceh=0) and (!instance_exists(flit1)) and (instance_exists(flit2)){
                if (point_distance(x,y,flit2.x,flit2.y)<=40) then with(flit2){instance_destroy();}onceh=1;
            }
            if (onceh=0) and (instance_exists(flit1)) and (!instance_exists(flit2)){if (point_distance(x,y,flit1.x,flit1.y)<=40) then with(flit1){instance_destroy();}onceh=1;}
            
            instance_destroy();
        }
    }
    exit;
}







if ((title="Inquisition Mission") or (title="Inquisition Recon")) and (title!="Artifact Located") and (obj_controller.demanding=1) then demand=1;



if (image="chaos_messenger") and (title="Chaos Meeting"){
    if (mission="meeting_1") or (mission="meeting_1t"){
        if (option1=""){
            option1="Die, heretic!";
            option2="Very well.  Lead the way.";
            option3="I must take care of an urgent matter first.  (Exit)";
            exit;
        }
        if (option1!=""){
            if (press=1){
                with(obj_star){
                    var i=0;
                    repeat(planets){
                        remove_planet_problem(i, "meeting");
                        remove_planet_problem(i, "meeting_trap");
                    }
                }
                obj_controller.disposition[10]-=10;
                text="The heretic is killed in a most violent fashion.  With a lack of go-between the meeting cannot proceed.";
                option1="";option2="";option3="";mission="";// image="";
                if (obj_controller.blood_debt=1){
                    obj_controller.penitent_current+=1;
                    obj_controller.penitent_turn=0;
                    obj_controller.penitent_turnly=0;
                }
                with(obj_temp_meeting){instance_destroy();}
                cooldown=20;
                exit;
            }
            else if (press=2) and (mission="meeting_1"){
                obj_controller.complex_event=true;obj_controller.current_eventing="chaos_meeting_1";
                text="mission_star signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before mission_star all enter an ordinary-looking structure.  Down, within the basement, mission_star then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until mission_star find yourself within a hall.  Within this hall, waiting for mission_star, are several dozen Chaos Terminators, a Greater Daemon of Tzeentch and Slaanesh, and Chaos Lord "+string(obj_controller.faction_leader[eFACTION.Chaos])+".";
                option1="";option2="";option3="";mission="cslord1";image="";img=0;image_wid=0;size=3;
                cooldown=20;exit;
            }
            else if (press=2) and (mission="meeting_1t"){
                with(obj_star){
                    remove_star_problem("meeting");
                    remove_star_problem("meeting_trap");
                }
                obj_controller.complex_event=true;
                obj_controller.current_eventing="chaos_trap";
                text="mission_star signal your readiness to the heretic.  Nearly twenty minutes of following the man passes before mission_star all enter an ordinary-looking structure.  Down, within the basement, mission_star then pass into the entrance of a tunnel.  As the trek downward continues more and more heretics appear- cultists, renegades that appear to be from the local garrison, and occasionally even the fallen of your kind.  Overall the heretics seem well supplied and equip.  This observation is interrupted as your group enters into a larger chamber, revealing a network of tunnels and what appears to be ancient catacombs.  Bones of the ancient dead, the forgotten, litter the walls and floor.  And the chamber seems to open up wider, and wider, until mission_star find yourself within a hall.  Within this hall, waiting for mission_star, are several dozen Chaos Terminators, a handful of Helbrute, and many more Chaos Space Marines.  The Chaos Lord is nowhere to be seen.  It is a trap.";
                option1="";option2="";option3="";mission="cslord1t";image="";img=0;image_wid=0;size=3;
                cooldown=20;exit;
            }
            if (press=3) and (instance_exists(obj_turn_end)){
                if (number!=0) then obj_turn_end.alarm[1]=4;
                with(obj_temp_meeting){instance_destroy();}
                instance_destroy();
            }
        }
    }
}


if (title="Scheduled Event"){
    if (option1=""){option1="Yes!";option2="No.";exit;}
    
    if (press=1) and (!instance_exists(obj_event)){
        instance_create(0,0,obj_event);
        if (obj_controller.fest_planet=0) then obj_controller.fest_attend=scr_event_dudes(1,0,"",obj_controller.fest_sid);
        if (obj_controller.fest_planet=1) then scr_event_dudes(1,1,obj_controller.fest_star,obj_controller.fest_wid);
        hide=true;cooldown=6000;title="Scheduled Event:2";
        exit;
    }
    if (press=2){
        obj_controller.fest_repeats-=1;
        if (obj_controller.fest_repeats<=0){
            obj_controller.fest_scheduled=0;
            
            instance_create(0,0,obj_event);
            if (obj_controller.fest_planet=0) then obj_controller.fest_attend=scr_event_dudes(1,0,"",obj_controller.fest_sid);
            if (obj_controller.fest_planet=1) then scr_event_dudes(1,1,obj_controller.fest_star,obj_controller.fest_wid);
            
            with(obj_event){
                var ide=0;
                repeat(700){ide+=1;
                    if (attend_corrupted[ide]=0) and (attend_id[ide]>0){
                        if (string_count("Chaos",obj_ini.artifact_tags[obj_controller.fest_display])>0){
                            obj_ini.TTRPG[attend_co[ide],attend_id[ide]].corruption+=choose(1,2,3,4);
                        }
                        if (string_count("Daem",obj_ini.artifact_tags[obj_controller.fest_display])>0){
                            obj_ini.TTRPG[attend_co[ide],attend_id[ide]].corruption+=choose(6,7,8,9);
                        }
                        attend_corrupted[ide]=1;
                    }
                }
            }
            with(obj_event){instance_destroy();}
            
            var p1,p2,p3;
            p1=obj_controller.fest_type;p3="";
            p2=obj_controller.fest_planet;
            
            if (p2>0) then p3=string(obj_controller.fest_star)+" "+scr_roman(obj_controller.fest_wid);
            if (p2<=0) then p3=+" the vessel '"+string(obj_ini.ship[obj_controller.fest_sid])+"'";
            
            scr_alert("green","event",string(p1)+" on "+string(p3)+" ends.",0,0);
            scr_event_log("green",string(p1)+" on "+string(p3)+" ends.");
        }
        obj_controller.cooldown=10;if (number!=0) then obj_turn_end.alarm[1]=4;instance_destroy();
    }
}
if (title="Scheduled Event:2") then exit;


if (image="inquisition") and (loc="contraband"){
    demand=0;
    option1="Hand over all Chaos and Daemonic Artifacts";
    option2="Over your dead body";
    var arti;
    if (press=1){
        var contraband=[];
        for (var i=0;i<array_length(obj_ini.artifact_struct);i++){
            if (obj_ini.artifact!=""){
                arti=obj_ini.artifact_struct[i];
                if (arti.inquisition_disaprove()){
                    array_push(contraband, i);
                }
            }
        }
        for (i=0;i<array_length(contraband);i++){
            delete_artifact(contraband[i]);
        }
        obj_controller.cooldown=10;option1="";
        option2="";
        loc="";
        text="All Chaos and Daemonic Artifacts present have been handed over to the Inquisitor.  They remain seething, but your destruction has been stalled.  Or so mission_star imagine.";
        exit;        
    }
    
    if (press=2){
        obj_controller.cooldown=10;
        if (number!=0) then obj_turn_end.alarm[1]=4;
        instance_destroy();
    }
}




if (title="Planetary Governor Assassinated") and (option1!="") and (cooldown<=0){
    if (new_target=0) and (instance_exists(obj_temp6)){
        new_target=instance_nearest(obj_temp6.x,obj_temp6.y,obj_star);
        with(obj_temp6){instance_destroy();}
    }
    
    if (press>0){
        var randa,randa2;randa=floor(random(100))+1;randa2=floor(random(100))+1;
        if (string_count("Shitty",obj_ini.strin2)>0) then randa-=20;
    }
    
    if (press=1){
        new_target.dispo[planet]=min(obj_ini.imperium_disposition,obj_controller.disposition[2])+choose(-1,-2,-3,-4,0,1,2,3,4);
        if (randa<=3) then new_target.dispo[planet]=min(new_target.dispo[planet],choose(1,2,3,4,5,6)*3);
        if (randa>=95) then new_target.dispo[planet]=max(new_target.dispo[planet],60+choose(1,2,3,4,5,6)*3);
        scr_event_log("","Planetary Governor of "+string(new_target.name)+" "+scr_roman(planet)+" assassinated.  The next in line takes over.", new_target.name);
        text="The next in line for rule of "+string(new_target.name)+" "+scr_roman(planet)+" has taken over their rightful position of Planetary Governor.";
        option1="";option2="";option3="";
        with(obj_ground_mission){instance_destroy();}
        cooldown=30;exit;
    }
    if (press=2){
        new_target.dispo[planet]=70+floor(random_range(5,15))+1;
        scr_event_log("","Planetary Governor of "+string(new_target.name)+" "+scr_roman(planet)+" assassinated.  A more suitable Governor is installed.");
        if (randa2<=(10*estimate)){
            var v=0,ev=0;
            repeat(99){v+=1;if (ev=0) and (obj_controller.event[v]="") then ev=v;}
            obj_controller.event[ev]="governor_assassination_1|"+string(new_target.name)+"|"+string(planet)+"|";
            obj_controller.event_duration[ev]=((choose(1,2,3,4,5,6)+choose(1,2,3,4,5,6))*6)+choose(-3,-2,-1,0,1,2,3);
        }
        text="Many of the successors for "+string(new_target.name)+" "+scr_roman(planet)+" are removed or otherwise made indisposed.  Your chapter ensures that the new Planetary Governor is sympathetic to your plight and more than willing to heed your advice.  A powerful new ally may be in the making.";
        option1="";option2="";option3="";
        with(obj_ground_mission){instance_destroy();}
        cooldown=30;exit;
    }
    if (press=3){
        new_target.dispo[planet]=101;
        scr_event_log("","Planetary Governor of "+string(new_target.name)+" "+scr_roman(planet)+" assassinated.  One of your Chapter Serfs take their position.");
        if (randa2<=(25*estimate)){
            var v=0,ev=0;
            repeat(99){v+=1;if (ev=0) and (obj_controller.event[v]="") then ev=v;}
            obj_controller.event[ev]="governor_assassination_2|"+string(new_target.name)+"|"+string(planet)+"|";
            obj_controller.event_duration[ev]=(choose(1,2)*6)+choose(-3,-2,-1,0,1,2,3);
        }
        text=$"All of the successors for {planet_numeral_name(planet,new_target)} are removed or otherwise made indisposed.  Paperwork is slightly altered.  Rather than any sort of offical one of your Chapter Serfs is installed as the Planetary Governor.  The planet is effectively under your control.";
        if (new_target.p_first[planet]!=3) then new_target.p_owner[planet]=1;
        option1="";option2="";option3="";
        with(obj_ground_mission){instance_destroy();}
        cooldown=30;exit;
    }
}
/*
var he;he=instance_create(argument0.x,argument0.y,obj_temp6);
var pip;pip=instance_create(0,0,obj_popup);
pip.title="Planetary Governor Assassinated";
pip.text=txt;

pip.option1="Allow the official successor to become Planetary Governor.";
pip.option2="Ensure that a sympathetic successor will be the one to rule.";
pip.option3="Remove all successors and install a loyal Chapter Serf.";

// Result-  this is the multiplier for the chance of discovery with the inquisition, can also be used to determine
// the new Governor disposition if they are the official successor
if (aroll<=chance){// Discovered
    pip.estimate=2;
}
if (aroll>chance){// Success
    pip.estimate=1;
}
*/



if (image="ruins_fort"){
    if (press=1) and (obj_controller.requisition>=1000){
        obj_controller.requisition-=1000;
        text="Resources have been spent on the planet to restore the fortress.  The planet's defense rating has increased to 5 (";
        option1="";
        option2="";
        option3="";
        text+=string(star_system.p_fortified[planet])+"+";
        text+=string(5-star_system.p_fortified[planet])+")";
        star_system.p_fortified[planet]=max(star_system.p_fortified[planet],5);
        cooldown=15;
        exit;
    }
    if (press=2){
        var req=floor(random_range(200,500))+1;
        image="";
        text="Much of the fortress is demolished in order to salvage adamantium and raw materials.  The opration has yielded "+string(req)+" requisition.";
        option1="";
        option2="";
        option3="";
        obj_controller.requisition+=req;
        cooldown=15;
        exit;
    }
    
    /*
    if (loot="fortress"){// Fortress
    var gene,pop;gene=floor(random_range(20,40))+1;pop=instance_create(0,0,obj_popup);
    pop.image="ruins_fort";pop.title="Ancient Ruins: Fortress";
    pop.text="Your battle brothers have found a massive, ancient fortress that has fallen into disrepair.  Gun batteries rusted, and walls covered in moss and undergrowth, it is a pale shadow of its former glory.  It is possible to repair the structure.  What is thy will?";
    pop.option1="Repair the fortress to boost planet defenses.  (1000 Req)";
    pop.option2="Salvage raw materials from the fortress.";
    }
    */
}

if (image="mechanicus") and (title="Mechanicus Mission") or (title="Mechanicus Mission Accepted"){
    if (option1="")and (title="Mechanicus Mission"){
        option1="Accept";
        option2="Refuse";
    }
    
    else if (press=1) and (option1!=""){
    
        if (string_count("tomb",mission)>0){
            with(obj_temp5){instance_destroy();}
            with(obj_star){if (name=obj_popup.loc) then instance_create(x,y,obj_temp5);}
            if (instance_exists(obj_temp5)){
                var tempy,eh,eh2,that,that2;tempy=instance_nearest(obj_temp5.x,obj_temp5.y,obj_star);eh=0;that=0;eh2=0;that2=0;
                repeat(4){
						eh+=1;
						var tomb_list =  search_planet_features(tempy.p_feature[eh], P_features.Necron_Tomb);
						if (tempy.p_owner[eh]<=5) and (array_length(tomb_list)>0){
							for (var tomb = 0;tomb<array_length(tomb_list);tomb++){
								if (tempy.p_feature[eh][tomb].awake == 0){
									that = eh
								}
							if (that !=0){break;}
						}
					}
				}
                
                with(obj_temp5){instance_destroy();}
                if (eh>0){
                    if (find_problem_planet(that, "", tempy)>0){
                        add_new_problem(that, "mech_tomb1",17, tempy);
                        text="The Adeptus Mechanicus await your forces at "+string(tempy.name)+" "+scr_roman(that)+".  They are expecting at least two squads of Astartes and have placed the testing on hold until their arrival.  mission_star have 16 months to arrive.";
                        scr_event_log("","Mechanicus Mission Accepted: At least two squads of marines are expected at "+string(tempy.name)+" "+scr_roman(that)+" within 16 months.", tempy.name); 
                        new_star_event_marker("green");
                        title="Mechanicus Mission Accepted";
                        option1="";option2="";cooldown=15;exit;
                    }
                }
            }
        }
    
    
        if (string_count("raider",mission)>0) or (string_count("bionics",mission)>0) or (string_count("mech_mars",mission)>0){
           
            var mission_star = star_by_name(obj_popup.loc);
            if (instance_exists(mission_star)){
                var forge_planet = scr_get_planet_with_type(mission_star, "Forge");
                if (mission_star.p_owner[eh]=3 && forge_planet){
                    mission_loc=planet_numeral_name(forge_planet,mission_star);
                    if (string_count("raider",mission)){
                        add_new_problem(forge_planet, "mech_raider", 49, mission_star, {"completion":0});
                        text=$"The Adeptus Mechanicus await your forces at {mission_loc}.  They are expecting six {obj_ini.role[100][16]}s and a Land Raider.";
                        scr_event_log("",$"Mechanicus Mission Accepted: Six of your {obj_ini.role[100][16]}s and a Land Raider are to be stationed at {mission_loc} for 24 months.", mission_star.name);                         
                    } else if (string_count("bionics",mission)){
                        add_new_problem(forge_planet, "mech_bionics", 49, mission_star, {"completion":0});
                        text=$"The Adeptus Mechanicus await your forces at {mission_loc}.  They are expecting ten Astartes with bionics.";
                        scr_event_log("",$"Mechanicus Mission Accepted: Ten Astartes with bionics are to be stationed at {mission_loc} for 24 months for testing purposes.", mission_star.name);                         
                    } else if (string_count("mars",mission)){
                        add_new_problem(forge_planet, "mech_mars", 13, mission_star);
                        text=$"The Adeptus Mechanicus await your {obj_ini.role[100][16]}s at {mission_loc}.  They are willing to hold on the voyage for up to 12 months.";
                        scr_event_log("",$"Mechanicus Mission Accepted: {obj_ini.role[100][16]}s are expected at {mission_loc} within 12 months, for the voyage to Mars.", tempy.name);                         
                    }
                    with (mission_star){
                        new_star_event_marker("green")
                    }
                    cooldown=15;
                    title="Mechanicus Mission Accepted";
                    option1="";
                    option2="";
                    option3="";
                    exit;
                }
            }
        }
        // Other missions here
    }
    else if (press=2) and (option2!=""){
        obj_controller.cooldown=10;
        if (number!=0) then obj_turn_end.alarm[1]=4;
        instance_destroy();
    }    
}


if (image="geneseed_lab"){
    if (press=1){
        image="";text=string(estimate)+" gene-seed has been added to the chapter vaults.";
        option1="";
        option2="";
        option3="";
        obj_controller.gene_seed+=estimate;
        with(obj_ground_mission){instance_destroy();}
        cooldown=15;exit;
    }
    if (press=2){
        var req;req=floor(random_range(200,500))+1;
        image="";
        text="Technological components have been salvaged, granting "+string(req)+" requisition.";
        option1="";
        option2="";
        option3="";
        obj_controller.requisition+=req;
        with(obj_ground_mission){
            instance_destroy();
        }
        cooldown=15;
        exit;
    }
    if (press=3){
        with(obj_ground_mission){instance_destroy();}
        obj_controller.cooldown=15;
        cooldown=15;
        instance_destroy();
        exit;
    }
}


if (image="ancient_ruins" && woopwoopwoop && move_to_next_stage()) {
    instance_deactivate_all(true);
    instance_activate_object(obj_ground_mission);
    instance_activate_object(obj_popup);
    var _explore_feature = obj_ground_mission.explore_feature;
    _explore_feature.suprise_attack();
    woopwoopwoop=0;
    show_debug_message("ruins combat");
    instance_destroy(self.id);
    instance_destroy();
    exit;
}else if (image="ancient_ruins" && option1!="" && instance_exists(obj_ground_mission)){
    if (press=1){// Begin
		var _ruins = obj_ground_mission.explore_feature;
        var ruins_battle=0,ruins_fact=0,ruins_disp=0,ruins_reward=0,dice,battle_threat=0;
        
        _ruins.determine_race()
        
        dice=floor(random(100))+1;
        var shit_luck = array_contains(obj_ini.dis,"Shitty Luck")
        var pass_mark = shit_luck ? 66 : 50;
        ruins_battle = dice<=pass_mark;
        
        // ruins_battle=1;
        
        if (ruins_battle=1){
            dice=floor(random(100))+1;
            if (shit_luck) then dice+=10;
            
            battle_threat=4;
            if (dice>0) and (dice<=60) then battle_threat=1;
            if (dice>60) and (dice<=90) then battle_threat=2;
            if (dice>90) and (dice<=99) then battle_threat=3;
            
            if (_ruins.ruins_race==1) or (_ruins.ruins_race=2) or (_ruins.ruins_race=10) then ruins_battle=choose(10,10,10,10,11,11,12);
            if (_ruins.ruins_race==5) then ruins_battle=10;
            if (_ruins.ruins_race==6) then ruins_battle=choose(6,6,10,10,10,12);
            if (ruins_battle==1) then ruins_battle = choose(6,10, 12);
            obj_ground_mission.ruins_race=_ruins.ruins_race;
            obj_ground_mission.ruins_battle=ruins_battle;
            obj_ground_mission.battle_threat=battle_threat;
            
            option1="";
            option2="";
            option3="";
            text="Your marines descended into the ancient ruins, mapping them out as they go.  They quickly determine the ruins were once ";
            if (_ruins.ruins_race=1) then text+="a Space Marine fortification from earlier times.";
            if (_ruins.ruins_race=2) then text+="golden-age Imperial ruins, lost to time.";
            if (_ruins.ruins_race=5) then text+="a magnificent temple of the Imperial Cult.";
            if (_ruins.ruins_race=6) then text+="Eldar colonization structures from an unknown time.";
            if (_ruins.ruins_race=10) then text+="golden-age Imperial ruins, since decorated with spikes and bones."; 
			if (_ruins.failed_exploration == 1){
				text+= "mission_star see the scarring in the walls and round impacts where your brothers died to clense this place of it's foul inhabitants";
			}			
            text+="  Unfortunantly, it's too late before your Battle Brothers discern the ruins are still inhabited.  Shapes begin to descend upon them from all directions, masked in the shadows.";
            
            cooldown=15;
            woopwoopwoop=1;
            exit;
        }
        if (ruins_battle=0){
            var obj=obj_ground_mission.obj;
            instance_activate_object(obj_star);
            scr_ruins_reward(star_by_name(obj_ground_mission.battle_loc),obj_ground_mission.num,obj_ground_mission.explore_feature);
            instance_destroy();
            exit;
        }
    }
    if (press=2){// Nothing
        obj_controller.cooldown=10;
        obj_controller.menu=1;
        // obj_controller.managing=manag;
        with(obj_controller){
            var i;i=-1;man_size=0;selecting_location="";selecting_types="";selecting_ship=0;sel_uid=0;
            reset_manage_arrays();
            alll=0;
            update_general_manage_view();
        }
        with(obj_ground_mission){
            instance_destroy();
        }
        instance_destroy();
        exit;
    }
    if (press=3){// Return to ship, exit
        scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
        var man_size,ship_id,comp,plan,i;
        i=0;ship_id=0;man_size=0;comp=0;plan=0;
        repeat(30){
            i+=1;
            if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;
        }i=0;
        obj_controller.menu=0;obj_controller.managing=0;
        obj_controller.cooldown=10;
        with(obj_ground_mission){instance_destroy();}
        instance_destroy();exit;
    }
}



if (image="stc"){
    if (ma_co>0) and (ma_id=0){
        if (press=1){
            obj_ground_mission.alarm[5]=1;
            obj_controller.cooldown=10;
            instance_destroy();
        }
        if (press=2){
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){
                i+=1;
                if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;
            }
            i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();exit;
        }
        if (press=3) then exit;
    }
    else if (ma_co>0) and (ma_id>0){
        if (press=1){
            obj_ground_mission.alarm[5]=1;
            obj_controller.cooldown=10;
            instance_destroy();
        }
        if (press=2){
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){i+=1;if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;}i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();exit;
        }
        if (press=3){
            obj_ground_mission.alarm[6]=1;
            obj_controller.cooldown=10;
            instance_destroy();
        }
    }
    else if (ma_co=0) and (ma_id>0) and (target_comp!=3){
        if (press=1){
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){i+=1;if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;}i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();exit;
        }
        if (press=2){
            obj_ground_mission.alarm[6]=1;
            obj_controller.cooldown=10;
            instance_destroy();
        }
        if (press=3) then exit;
    }
    if (ma_id>0) and (target_comp=3){
        if (press=1){
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){i+=1;if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;}i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();exit;
        }
        if (press=2) then exit;
        if (press=3) then exit;
    }
}




if (type=6){// Equipment
    if (target_comp=1) then target_role=sel1;
    if (target_comp=2) then target_role=sel2;
    if (target_comp=3) then target_role=sel3;
    if (target_comp=4) then target_role=sel4;
    if (target_comp=5) then target_role=sel5;
}

if (image="gene_bad"){
    option1="Dispose of ";
    if (obj_controller.gene_seed<=30) then option1+="100% of the gene-seed.";
    if (obj_controller.gene_seed>30) and (obj_controller.gene_seed<60) then option1+="50% of all gene-seed.";
    if (obj_controller.gene_seed>=60) then option1+="33% of all gene-seed.";
    option2="Tell the apothecaries to let it be.";option3="";
}

if ((title="Inquisition Mission") or (title="Inquisition Recon")) and (option1=""){option1="Accept";option2="Refuse";}
if (title="Inquisitor Located"){option1="Destroy their vessel";option2="Hear them out";}
if (title="Necron Tomb Excursion"){option1="Begin the Mission";option2="Not Yet";}
if (title="Necron Tunnels : 1"){option1="Continue";option2="Return to the surface";}
if (title="Necron Tunnels : 2"){option1="Continue";option2="Return to the surface";}
if (title="Necron Tunnels : 3"){option1="Continue";option2="Return to the surface";}

if (title="He Built It") and (option1="") and (string_count("submerged",text)=0){
    option1="Execute the heretic";
    option2="Move him to the Penitorium";
    option3="mission_star see no problem";
}




if (press=1) and (option1!="") or ((demand=1) and (mission!="") and (string_count("Inquisition",title)>0)) or ((demand=1) and (title="Inquisition Recon")){
    if (image="gene_bad"){
        var onceh;onceh=0;
        if (obj_controller.gene_seed<=30) and (onceh=0){obj_controller.gene_seed=0;}
        if (obj_controller.gene_seed>30) and (obj_controller.gene_seed<60) and (onceh=0){obj_controller.gene_seed=round(obj_controller.gene_seed*0.5);}
        if (obj_controller.gene_seed>=60) and (onceh=0){obj_controller.gene_seed=round(obj_controller.gene_seed*0.66);}
    }
    if (title="Inquisitor Located") or (title="Artifact Offered") or (title="Mercy Plea"){
        with(obj_en_fleet){if (trade_goods="male_her") or (trade_goods="female_her") then instance_destroy();}
        
        if (obj_controller.demanding=0) then obj_controller.disposition[4]+=1;
        if (obj_controller.demanding=1) then obj_controller.disposition[4]+=choose(0,0,1);
        
        if (title="Artifact Offered") or (title="Mercy Plea") then obj_controller.disposition[4]-=choose(0,1);
        
        title="Inquisition Mission Completed";image="exploding_ship";
        text="The Inquisitor's ship begans to bank and turn, to flee, but is immediately fired upon by your fleet.  The ship explodes, taking the Inquisitor with it.  The mission has been accomplished.";
        option1="";option2="";option3="";
        
        scr_event_log("","Inquisition Mission Completed: The radical Inquisitor has been purged.");
        
        exit;    
    }
    if (title="He Built It"){
        scr_kill_unit(ma_co,ma_id);
        var company_to_order = ma_co;
        with(obj_ini){scr_company_order(company_to_order);};
    }
    
    if (title="Necron Tomb Excursion"){
        instance_activate_all();
        var player_forces,penalty,roll;player_forces=0;penalty=0;roll=floor(random(100))+1;
        with(obj_star){if (name!=obj_popup.loc) then instance_deactivate_object(id);}
        if (!instance_exists(obj_temp8)) then instance_create(obj_star.x,obj_star.y,obj_temp8);
        player_forces=obj_star.p_player[planet];
        instance_activate_object(obj_star);cooldown=30;
        
        obj_temp8.stage+=1;
        obj_temp8.loc=loc;
        obj_temp8.wid=planet;
        
        title = $"Necron Tunnels : {obj_temp8.stage}";
        if (obj_temp8.stage=1){
            image="necron_tunnels_1";
            text="Your marines enter the massive tunnel complex, following the energy readings.  At first the walls are cramped and tiny, closing about them, but the tunnels widen at a rapid pace.";
            option1="Continue";
            option2="Return to the surface";
        }
        exit;
    }
    
    if (string_count("Necron Tunnels",title)>0 && instance_exists(obj_temp8)){
        var player_forces,penalty,roll,battle;player_forces=0;penalty=0;roll=floor(random(100))+1;battle=0;
        instance_activate_all();
        var mission_star = star_by_name(obj_temp8.loc);

        player_forces=obj_star.p_player[obj_temp8.wid];

        obj_temp8.popup=obj_turn_end.current_popup;
        
        // SMALL TEAM OF MARINES
        if (player_forces>6) then penalty=10;
        if (player_forces>10) then penalty=20;
        if (player_forces>=20) then penalty=30;
        if (player_forces>=40) then penalty=50;
        if (player_forces>=60) then penalty=100;
        roll+=penalty;
        
        // roll=30;if (string_count("3",title)>0) then roll=70;
        
        // Result
        if (roll<=60){
            obj_temp8.stage+=1;
            title= $"Necron Tunnels : {obj_temp8.stage}";
            
            if (obj_temp8.stage=2){
                image="necron_tunnels_2";
                text="The energy readings are much stronger, now that your marines are deep inside the tunnels.  What was once cramped is now luxuriously large, the tunnel ceiling far overhead decorated by stalactites.";
            }else if (obj_temp8.stage=3){
                image="necron_tunnels_3";
                text="After several hours of descent the entrance to the Necron Tomb finally looms ahead- dancing, sickly green light shining free.  Your marine confirms that the Plasma Bomb is ready.";
            }else if (obj_temp8.stage>=4){
                image="";
                title="Inquisition Mission Completed";
                text="Your marines finally enter the deepest catacombs of the Necron Tomb.  There they place the Plasma Bomb and arm it.  All around are signs of increasing Necron activity.  With half an hour set, your men escape back to the surface.  There is a brief rumble as the charge goes off, your mission a success.";
                option1="";
                option2="";
                option3="";
                
                if (obj_controller.demanding=0) then obj_controller.disposition[4]+=1;
                if (obj_controller.demanding=1) then obj_controller.disposition[4]+=choose(0,0,1);

                instance_activate_object(obj_star);
                mission_star = star_by_name(obj_controller.temp[200]);
                
                var ppp=0;
                remove_planet_problem(planet, "bomb", mission_star);
                mission_star.p_feature[planet][search_planet_features(mission_star.p_feature[planet], P_features.Necron_Tomb)[0]].sealed = 1;
                with(obj_temp8){instance_destroy();}
                instance_activate_object(obj_star);
                
                scr_event_log("",$"Inquisition Mission Completed: Your Astartes have sealed the Necron Tomb on {mission_star.name} {scr_roman(planet)}.", mission_star.name);
                scr_gov_disp(mission_star.name,planet,choose(3,4,5,6,7));
                var have_bomb=scr_check_equip("Plasma Bomb",self.loc,self.planet,1);
                exit;
            }
        }
        if (roll>60) and (roll<=82){// Necron Wraith attack
            battle=1;
        }
        if (roll>82) and (roll<=92){// Tomb Spyder attack
            battle=2;
        }
        if (roll>92) and (roll<=97){// Tomb Stalker
            battle=3;
        }
        if (roll>97){// Tomb World wakes up
            if (player_forces<=30) then battle=4;
            if (player_forces>30) then battle=5;
            if (player_forces>100) then battle=6;
        }
        
        if (battle>0){
            var that_one;
            instance_deactivate_all(true);
            instance_activate_object(obj_controller);
            instance_activate_object(obj_ini);
            instance_activate_object(obj_temp8);
            
            instance_create(0,0,obj_ncombat);
            scr_battle_roster(obj_temp8.loc,obj_temp8.wid,true);
            
            instance_activate_object(obj_star);
            with(obj_star){if (name!=obj_temp8.loc) then instance_deactivate_object(id);}
            
            
            that_one=instance_nearest(0,0,obj_star);
            instance_activate_object(obj_star);
            
            obj_ncombat.battle_object=that_one;instance_deactivate_object(obj_star);
            obj_ncombat.battle_loc=loc;
            obj_ncombat.battle_id=planet;
            obj_ncombat.dropping=0;
            obj_ncombat.attacking=0;
            obj_ncombat.enemy=13;
            obj_ncombat.threat=1;
            obj_ncombat.formation_set=1;
            
            if (battle=1)  {obj_ncombat.battle_special="wraith_attack";}
            else if (battle=2)  {obj_ncombat.battle_special="spyder_attack";}
            else if (battle=3)  {obj_ncombat.battle_special="stalker_attack";}
            else if (battle=4)  {obj_ncombat.battle_special="wake1_attack";}
            else if (battle=5)  {obj_ncombat.battle_special="wake2_attack";}
            else if (battle=6)  {obj_ncombat.battle_special="wake2_attack";}
            
            instance_destroy();
        }
        
        
    
        exit;
    }
    
    
    
    
    

    
    if (title="Inquisition Recon"){

        var mission_star,onceh;onceh=0;
        obj_controller.temp[200]=string(loc);
        var mission_star = star_by_name(obj_controller.temp[200]);
        if (add_new_problem(planet, "recon",estimate, mission_star)){
            title="Inquisition Mission Demand";
            text=$"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  mission_star are to land Astartes on {mission_star.name} {scr_roman(planet)} to investigate the planet within {estimate} months.";
            with (mission_star){
                new_star_event_marker("green");
            }
            scr_event_log("",$"Inquisition Mission Accepted: The Inquisition wish for Astartes to land on and investigate {mission_star.name} {scr_roman(planet)} within {estimate} months.", mission_star.name);            
        }
    }else if (mission!="") and (title="Inquisition Mission"){
        obj_controller.temp[200]=string(loc);
        var mission_star, onceh;mission_star=0;onceh=0;
        var mission_star=star_by_name(obj_controller.temp[200]);
        var mission_is_go =false;
        if (mission_star!="none"){
            var _estimate = estimate;
            var _planet = planet;
            var _mission = mission;
            with (mission_star){
                if (add_new_problem(_planet, _mission, _estimate)){
                    new_star_event_marker("green");
                    mission_is_go=true;               
                }
            }
            if (mission_is_go){
                if (demand){
                    title = "Inquisition Mission Demand";
                }

                if (mission=="purge"){
                    scr_event_log("",$"Inquisition Mission Accepted: The nobles of {mission_star.name} {scr_roman(planet)} must be selectively purged within {estimate} months.", mission_star.name);
                    if (demand){
                        text=$"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  mission_star are to selectively purge the Nobles on {mission_star.name} {scr_roman(onceh)} within {estimate} months.";
                    }               
                }
                else if (mission=="cleanse"){

                    scr_event_log("",$"Inquisition Mission Accepted: The mutants beneath {planet_numeral_name(planet,mission_star)} must be cleansed by fire within {estimate} months.",mission_star.name);
                    if (demand){
                        text=$"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  mission_star are to cleanse by fire the mutants in Hive {planet_numeral_name(planet,mission_star)} within {estimate} months.";
                    } 
                }else if (mission="inquisitor"){
                    scr_event_log("",$"Inquisition Mission Accepted: A radical Inquisitor enroute to {mission_star.name} must be removed.  Estimated arrival in {estimate} months.",mission_star.name);
                    if (demand){
                        text=$"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  A radical inquisitor is enroute to {mission_star.name}, expected within {estimate} months.  They are to be silenced and removed.";
                    }
                }
                
                if (mission="spyrer"){
                    scr_event_log("",$"Inquisition Mission Accepted: The Spyrer on {mission_star.name} {scr_roman(planet)} must be killed within {estimate} months.", mission_star.name);
                    if (demand){
                        text=$"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  An out of control Spyrer on Hive {mission_star.name} {scr_roman(onceh)} must be removed within {estimate} months.";
                    }
                }else if (mission="necron"){
                    
                    scr_event_log("",$"Inquisition Mission Accepted: mission_star have been given a Bomb to seal the Necron Tomb on {mission_star.name} {scr_roman(planet)}.", mission_star.name);
                    
                    image="necron_cave";
                    title="New Equipment";
                    fancy_title=0;
                    text_center=0;
                    text="mission_star have been provided with 1x Plasma Bomb in order to complete the mission.";
                    
                    if (demand){
                        text=$"The Inquisition demands that your Chapter demonstrate its loyalty.  mission_star have been given a Plasma Bomb to seal the Necron Tomb on {mission_star.name} {scr_roman(onceh)}.  It is expected to be completed within {estimate} months.";
                    }
                    option1="";
                    option2="";
                    option3="";
                    scr_add_item("Plasma Bomb",1);
                    obj_controller.cooldown=10;
                    if (demand) then demand=0;
                    exit;
                }
                
                else if (mission="tyranid_org"){

                    image="webber";
                    title="New Equipment";
                    fancy_title=0;
                    text_center=0;
                    text="mission_star have been provided with 4x Astartes Webbers in order to complete the mission.";
                    
                    
                    if (demand){
                        text="The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  mission_star are to capture a Gaunt organism and return it, unharmed- 4x Webbers have been provided for this purpose.";
                    }
                    
                    option1="";
                    option2="";
                    option3="";
                    scr_add_item("Webber",4);
                    obj_controller.cooldown=10;
                    scr_event_log("",$"Inquisition Mission Accepted: The Inquisition wishes for the capture of a particular strain Gaunt noticed on {mission_star.name} {scr_roman(planet)} is advisable.", mission_star.name);            
                    obj_controller.useful_info+="Tyr|";
                    if (demand) then demand=0;
                    exit;
                } else if (mission="ethereal"){
                    with(obj_star){
                        if (p_tau[1]>=4) or (p_tau[2]>=4) or (p_tau[3]>=4) or (p_tau[4]>=4){
                            new_star_event_marker("green");
                        }
                    }
                    scr_quest(0,"ethereal_capture",4,estimate);
                    obj_controller.useful_info+="Tau|";
                    
                    if (demand){title="Inquisition Mission Demand";
                    text=$"The Inquisition demands that your Chapter demonstrate its loyalty to the Imperium of Mankind and the Emperor.  mission_star are to capture the Tau Ethereal somewhere within the {mission_star.name} system.";}
                    if (mission_star.p_problem[planet,1]="recon") then scr_event_log("",$"Inquisition Mission Accepted: The Inquisition wish for mission_star to capture the Tau Ethereal somewhere within {mission_star.name}.", mission_star.name);
                }
            }
        }
        if (!mission_is_go){
            if (mission="artifact"){
                var last_artifact;
                scr_quest(0,"artifact_loan",4,estimate);
                if (obj_ini.fleet_type=ePlayerBase.home_world){
                    image="fortress";
                    if (obj_ini.home_type="Hive") then image="fortress_hive";
                    if (obj_ini.home_type="Death") then image="fortress_death";
                    if (obj_ini.home_type="Ice") then image="fortress_ice";
                    if (obj_ini.home_type="Lava") then image="fortress_lava";
                    if (obj_ini.icon_name="dorf1") then image="fortress_dorf";
                    if (obj_ini.icon_name="dorf2") then image="fortress_dorf";
                    if (obj_ini.icon_name="dorf3") then image="fortress_dorf";
                    last_artifact = scr_add_artifact("good","inquisition",0,obj_ini.home_name,2);
                }else if (obj_ini.fleet_type != ePlayerBase.home_world){
                    image="artifact_given";
                    last_artifact =scr_add_artifact("good","inquisition",0,obj_ini.ship[1],501);
                }
                
                title="New Artifact";
                fancy_title=0;
                text_center=0;
                text="The Inquisition has left an Artifact in your care, until it may be retrieved.  It has been stored ";
                if (obj_ini.fleet_type=ePlayerBase.home_world) then text+="within your Fortress Monastery.";
                if (obj_ini.fleet_type != ePlayerBase.home_world) then text+=$"upon your ship '{obj_ini.ship[1]}'.";
                scr_event_log("","Inquisition Mission Accepted: The Inquisition has left an Artifact in your care.");
                
                text+=$"  It is some form of {obj_ini.artifact[last_artifact]}.";
                option1="";
                option2="";
                option3="";
                obj_controller.cooldown=10;exit;
            }
        }
        
        if (demand){demand=0;option1="";option2="";option3="";exit;}// Remove multi-choices
    }
    
    
    if (image="inquisition") and (title="Investigation Completed"){
        obj_temp7.alarm[1]=1;instance_destroy();
    }
    
    if (image="artifact"){
        if (target_comp=2){
            obj_ground_mission.alarm[3]=1;
        }
        if (target_comp>2) and (target_comp!=7) and (target_comp<9){
            obj_controller.menu=20;
            obj_controller.cooldown=10;
            obj_controller.diplomacy=target_comp;
            obj_controller.trading_artifact=1;
            with(obj_controller){
                scr_dialogue("artifact");
            }
            instance_destroy();
        }
        if (target_comp=7) or (target_comp>=9){
            obj_ground_mission.alarm[4]=1;
            obj_controller.cooldown=10;
            instance_destroy();
        }
    }
    
    if (image="artifact2"){
        obj_ground_mission.alarm[4]=1;
        obj_controller.cooldown=10;
        instance_destroy();
    }
    
    obj_controller.cooldown=10;
    if (obj_controller.complex_event=false){
        if (number!=0) then obj_turn_end.alarm[1]=4;instance_destroy();
    }
}

if (press=2) and (option2!=""){
    if (image="gene_bad") then scr_loyalty("Mutant Gene-Seed","+");
    
    if (mission="spyrer") then obj_controller.disposition[4]-=2;
    if (title="Inquisition Recon") then obj_controller.disposition[4]-=2;
    if (image="inquisition") and (title="Investigation Completed"){
        with(obj_temp7){instance_destroy();}instance_destroy();
    }
    
    
    
    
    if (title="Artifact Offered"){
        with(obj_en_fleet){if (trade_goods="male_her") or (trade_goods="female_her") then instance_destroy();}
        if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.ship[1],501);
        if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.home_name,2);
        var i,last_artifact;i=0;last_artifact=0;
        repeat(100){if (last_artifact=0){i+=1;if (obj_ini.artifact[i]="") then last_artifact=i-1;}}
        option1="";option2="";option3="";
        title="Inquisition Mission Completed";
        text="Your ship sends over a boarding party, who retrieve the offered artifact- ";
        text+=" some form of "+string(obj_ini.artifact[last_artifact])+".  Once it is safely stowed away your ship is then ordered to fire.  The Inquisitor's own seems to hesitate an instant before banking away, but is quickly destroyed.";
        image="exploding_ship";
        option1="";option2="";option3="";
        scr_event_log("","Artifact recovered from radical Inquisitor.");
        scr_event_log("","Inquisition Mission Completed: The radical Inquisitor has been purged.");
        exit;
    }
    
    
    
    if (title="He Built It"){
        obj_ini.god[ma_co,ma_id]+=10;
        option1="";
        option2="";
        option3="";
    }
    
    
    
    if (title="Mercy Plea"){
        // If have any marines within the fleet on the ships
        
        var able,i;able=0;i=0;
        
        
        // Several things can happen when the ship is searched;
        // Full of demons, maybe remove a marine, fired upon and explodes
        
        exit;
        
    }
    
    if (title="Inquisitor Located"){
        var offer,gender,gender2;
        offer=choose(1,1,2,2,3);
        if (planet=1) then gender="he";if (planet=2) then gender="she";
        if (planet=1) then gender2="his";if (planet=2) then gender2="her";
        
        if (offer=1){
            title="Artifact Offered";
            text="The Inquisitor claims that this is a massive misunderstanding, and "+string(gender)+" wishes to prove "+string(gender2)+" innocence.  If mission_star allow their ship to leave "+string(gender)+" will give mission_star an artifact.";
            option1="Destroy their vessel";
            option2="Take the artifact and then destroy them";
            option3="Take the artifact and spare them";
            exit;
        }
        
        if (offer=2){
            title="Mercy Plea";
            text="The Inquisitor claims that "+string(gender)+" has key knowledge that would grant the Imperium vital power over the forces of Chaos.  If mission_star allow "+string(gender2)+" ship to leave the forces of Chaos within this sector will be weakened.";
            option1="Destroy their vessel";
            option2="Search their ship";
            option3="Spare them";
            exit;
        }
        
        if (offer=3){
            var gender2;
            if (planet=1) then gender2="his";if (planet=2) then gender2="her";
            with(obj_en_fleet){
                if (trade_goods="male_her") or (trade_goods="female_her"){
                    with(obj_p_fleet){if (action!="") then instance_deactivate_object(id);}
                    with(instance_nearest(x,y,obj_p_fleet)){scr_add_corruption(true,"1d3");}
                    instance_activate_object(obj_p_fleet);
                    instance_destroy();
                }
            }
            title="Inquisition Mission Completed";image="exploding_ship";
            text="mission_star allow communications.  As soon as the vox turns on mission_star hear a sickly, hateful voice.  They begin to speak of the inevitable death of your marines, the fall of all that is and ever shall be, and "+string(gender2)+" Lord of Decay.  Their ship is fired upon and destroyed without hesitation.";
            option1="";option2="";option3="";
            scr_event_log("","Inquisition Mission Completed: The radical Inquisitor has been purged.");
            exit;
        }
        exit;
    }
    
    if (image="artifact"){
        if (target_comp!=7) and (target_comp<9){
            obj_ground_mission.alarm[4]=1;
            obj_controller.cooldown=10;
            instance_destroy();
        }
        if (target_comp>=9) or (target_comp=7){// NOPE
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){i+=1;if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;}i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();exit;
        }
    }
    
    if (image="artifact2"){
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){i+=1;if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;}i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();exit;
    }
    
    obj_controller.cooldown=10;
    
    if (obj_controller.complex_event=false){
        if (number!=0) then obj_turn_end.alarm[1]=4;instance_destroy();
    }
}




if (press=3) and (option3!=""){
    if (title="Artifact Offered"){
        with(obj_en_fleet){
            if (trade_goods="male_her") or (trade_goods="female_her"){
                action_x=choose(room_width*-1,room_width*2);action_y=choose(room_height*-1,room_height*2);
                alarm[4]=1;trade_goods="|DELETE|";action_spd=256;action="";
            }
        }
        if (obj_ini.fleet_type != ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.ship[1],501);
        if (obj_ini.fleet_type=ePlayerBase.home_world) then scr_add_artifact("random","",4,obj_ini.home_name,2);
        var i,last_artifact;i=0;last_artifact=0;
        repeat(100){if (last_artifact=0){i+=1;if (obj_ini.artifact[i]="") then last_artifact=i-1;}}
        option1="";option2="";option3="";
        title="Inquisition Mission Completed";
        text="Your ship sends over a boarding party, who retrieve the offered artifact- ";
        text+=" some form of "+string(obj_ini.artifact[last_artifact])+".  As promised mission_star allow the Inquisitor to leave, hoping for the best.  What's the worst that could happen?";
        image="artifact_recovered";
        option1="";option2="";option3="";
        scr_event_log("","Artifact Recovered from radical Inquisitor.");
        scr_event_log("","Inquisition Mission Completed: The radical Inquisitor has been purged.");
        
        var v=0,ev=0;
        repeat(99){v+=1;if (ev=0) and (obj_controller.event[v]="") then ev=v;}
        obj_controller.event[ev]="inquisitor_spared1";obj_controller.event_duration[ev]=floor(random_range(6,18))+1;
        
        exit;
    }
    if (title="Mercy Plea"){
        with(obj_en_fleet){
            if (trade_goods="male_her") or (trade_goods="female_her"){
                action_x=choose(room_width*-1,room_width*2);action_y=choose(room_height*-1,room_height*2);
                trade_goods="|DELETE|";alarm[4]=1;action_spd=256;action="";
            }
        }
        title="Inquisition Mission Completed";
        text="mission_star allow the Inquisitor to leave, trusting in their words.  If they truly do have key information it is a risk mission_star are willing to take.  What's the worst that could happen?";
        image="artifact_recovered";
        option1="";option2="";option3="";
        
        scr_event_log("","Inquisition Mission Completed?: The radical Inquisitor has been allowed to flee in order to weaken the forces of Chaos, as they promised.");
        
        var v=0,ev=0;
        repeat(99){v+=1;if (ev=0) and (obj_controller.event[v]="") then ev=v;}
        obj_controller.event[ev]="inquisitor_spared2";obj_controller.event_duration[ev]=floor(random_range(6,18))+1;
        
        exit;
    }else if (image="artifact"){
        if (target_comp<9) and (target_comp!=7){// This returns the marines to the ship
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){
                i+=1;
                if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;
            }i=0;
        }
        
        if (target_comp!=3) and (target_comp!=4){
            // Here, have this gift
            var plan=instance_nearest(obj_ground_mission.x,obj_ground_mission.y,obj_star);
			var planet_arti = search_planet_features(plan.p_feature[obj_ground_mission.num], P_features.Artifact)
			if (array_length(planet_arti) >0){
				array_delete(plan.p_feature[obj_ground_mission.num], planet_arti[0], 1)
			}
            
            scr_return_ship(obj_ground_mission.loc,obj_ground_mission,obj_ground_mission.num);
            var man_size,ship_id,comp,plan,i;
            i=0;ship_id=0;man_size=0;comp=0;plan=0;
            repeat(30){i+=1;if (obj_ini.ship[i]=obj_ground_mission.loc) then ship_id=i;}i=0;
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            
            // Set disposition
            // 135
            
            obj_controller.menu=20;
            obj_controller.cooldown=10;
            obj_controller.diplomacy=target_comp;
            with(obj_controller){scr_dialogue("artifact_thanks");}
            obj_controller.force_goodbye=2;
            obj_controller.exit_all=1;
            
            // 135
            /*there should be a chance for things to go terribly wrong when mission_star give a gift
            
            Imperium: if chaos, increase the global corruption of imperial planets a bit?
            Imperium: if daemonic, the commander goes chaos after a few turns?
            Mechanicus: if daemonic vastly increases corruption on forge worlds?
            Ecclesiarchy: if daemonic they get really pissed at mission_star?
            Eldar: if daemonic they get really pissed at mission_star?
            Tau: if daemonic all their worlds get big corruption boosts?*/
            
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();
            exit;
        }
        
        if (target_comp=3) or (target_comp=4){// Not worth it, mang
            obj_controller.menu=0;obj_controller.managing=0;
            obj_controller.cooldown=10;
            with(obj_ground_mission){instance_destroy();}
            instance_destroy();
        }
    }
    
    obj_controller.cooldown=10;
    if (obj_controller.complex_event=false){
        if (number!=0) then obj_turn_end.alarm[1]=4;instance_destroy();
    }
}
if (image=="new_forge_master"){
    if (pathway==""){
        obj_controller.complex_event=true;
        techs = collect_role_group("forge");
        charisma_pick=0;
        experience_pick=0;
        talent_pick=0;
        for (i=1;i<array_length(techs);i++){
            if (techs[charisma_pick].charisma < techs[i].charisma){
                charisma_pick=i;
            }
            if (techs[experience_pick].experience < techs[i].experience){
                experience_pick=i;
            }
            if (techs[talent_pick].technology < techs[i].technology){
                talent_pick=i;
            }                
        }
        pathway="selection_options"
        option1="Popular Pick";
        option2="Talent Pick";
        option3="Experience Pick";        
    }else if (pathway=="selection_options"){
        if (press>0){
            var cur_tech;
            var skill_lack=0;
            var exp_lack=0;
            var dislike=0;
            var popularity_lack=0
            var pick="none";
            var charisma_test = 0;
            if (press>0 && press<4){
                if (press==1){
                    pick = techs[charisma_pick];
                } else if (press==2){
                    pick = techs[talent_pick];
                } else if (press==3){
                    pick = techs[experience_pick];
                }
                for (i=0;i<array_length(techs);i++){
                    if (i=charisma_pick) then continue;
                    cur_tech = techs[i];
                    charisma_test = global.character_tester.oppposed_test(pick,cur_tech, "charisma", 10);
                    if (charisma_test[0]!=1){
                        if (pick.technology<cur_tech.technology){
                            skill_lack++;
                            cur_tech.loyalty-=cur_tech.technology-pick.technology;
                        }
                         if (pick.experience<cur_tech.experience){
                            exp_lack++;
                            cur_tech.loyalty-=floor((cur_tech.experience-pick.experience)/200);
                        }
                        if (charisma_test[0]==2){
                            dislike++;
                            cur_tech.loyalty-=charisma_test[1];
                        }
                    }
                }
            }
            if (pick!="none"){
                pick.update_role("Forge Master");

                var likability;
                if (dislike<=5)  then likability = "He is generally well liked";
                if (dislike>5)  then likability = "He is not generally well liked";
                if (dislike>10)  then likability = "He mostly disliked";
                if (dislike==0)  then likability = "He is like by all of his tech brothers";
                text = $"{pick.name()} is selected as the new {pick.role()} {likability}."
                if (skill_lack>0 &&  skill_lack<6){
                    text+="There are some questions about his ability.";
                } else if (skill_lack>6){
                    text+="Many Question his Technical Talents.";
                }
                if (exp_lack>0 &&  exp_lack<6){
                    text+="A few have raised questions over his experience.";
                } else if (exp_lack>=6){
                    text+="There have been Many concerns over his experience.";
                }
                if (popularity_lack>1 &&  popularity_lack<6){
                    text+="He is not unanimously liked.";
                } else if (popularity_lack>=6){
                    text+="He is disliked by many.";
                }
                var lacks =  skill_lack+exp_lack+popularity_lack;       
                if (lacks<((array_length(techs)-1)/10)){
                    text+="Your choice Is almost unanimously respected";
                } else if (lacks<((array_length(techs)-1)/4)){
                    text+="While a few may have preferred another there are no serious concerns";
                } else if (lacks<((array_length(techs)-1)/2)){
                    text+="Your supporters are more than our detractors but many are unhappy";
                }else if (lacks<((array_length(techs)-1)*0.65)){
                    text+="Most are unhappy with the decision but your word is final";
                }
                reset_options();
                press=0
                pathway="end_splash";
                if (pick.company>0){
                    for (var i=1;i<500;i++){
                        if (obj_ini.name[0][i]=="") then break;
                    }
                    scr_move_unit_info(pick.company,0, pick.marine_number, i);
                }
            }
        }
    }
}else if (image=="tech_uprising"){

    if (pathway == ""){
        obj_controller.complex_event=true;
        pathway="heretic_choice";
        option1="Do Nothing";
        option2="Support the heretics";
        option3="Support the Cult mechanicus faithfuls";               
    } else  if (pathway == "heretic_choice"){
        if (press>0){
            pathway = "tech_aftermath";
        }
    }
    if (pathway == "tech_aftermath"){
        var tech,t,i, check_tech, location_techs, location_heretics, delete_positions, heretic_data=[0,0,0],loyal_data=[0,0,0];
        techs = collect_role_group("forge");
        var tech_count = array_length(techs);
        for (i=0; i<tech_count;i++){

            delete_positions=[];
            location_techs=[];
            location_heretics=[];
            tech = techs[i];
            if (tech.has_trait("tech_heretic")){
                array_push(location_heretics, tech);
            } else {
                array_push(location_techs, tech);
            }
            //loop techs to fins out which techs are in the same  location
            for (t=i+1;t<tech_count;t++){
                check_tech = techs[t].marine_location();
                if (same_locations(tech.marine_location(), check_tech)){

                    if (techs[t].has_trait("tech_heretic")){
                        array_push(location_heretics, techs[t]);
                        heretic_data[0]+=techs[t].weapon_skill;
                        heretic_data[1]+=techs[t].wisdom;
                        heretic_data[2]+=techs[t].ballistic_skill;
                    } else {
                        array_push(location_techs, techs[t]);
                        loyal_data[0]+=techs[t].weapon_skill;
                        loyal_data[1]+=techs[t].wisdom;
                        loyal_data[2]+=techs[t].ballistic_skill;
                    }
                    array_push(delete_positions, t);
                }
            }
            if (array_length(location_heretics)>0 &&
                array_length(location_techs)>0){
                var purge_target = "none";
                if (press==1){
                    var tal;
                    var heretic_tally=0;
                    var loyal_tally=0;
                    for (tal=0;tal<3;tal++){
                        if (heretic_data[tal]>loyal_data[0]){
                            heretic_tally++;
                        } else if (heretic_data[tal]<loyal_data[0]){
                            loyal_tally++;
                        }
                    }
                    if (heretic_tally>loyal_tally){
                        purge_target =location_techs;
                    } else if (loyal_tally<heretic_tally){
                        purge_target =location_heretics;
                    }
                    if (purge_target=="none"){
                        purge_target=choose(location_heretics,location_techs);
                    }
                } else if (press==2){
                    purge_target=location_techs;
                }else if (press==3){
                    purge_target=location_heretics;
                }
                if (purge_target!="none"){
                    for (tal=0;tal<array_length(purge_target);tal++){
                        kill_and_recover(purge_target[tal].company,purge_target[tal].marine_number);
                    }
                }
            }
            if (array_length(delete_positions)>0){
                for (t=0;t<array_length(delete_positions);t++){
                    array_delete(techs, delete_positions[t],1);
                    tech_count--;
                }
            }
        }
        if (press==1){
            text="With neither faction receiving your favor it is not long until the BloodLetting begins. Within a month a brutal civil war engulfs the Tech ranks with losses suffered on both sides";
        } else if (press==2){
            text="With your full support the so called 'heretics' who have seen through the lies of the bureaucracy of Mars eliminate those who will not be swayed to see the truth.";
            obj_controller.tech_status = "heretics";
        } else if(press==3){
            text="The extremists and heretics that have been allowed to grow like a cancer in the Armentarium are rooted out and disposed of.";
        }
        reset_options();
        press=0;
        pathway="end_splash";
    }
}
if (pathway="end_splash"){
    option1="Continue";
   if (press == 1){
    obj_controller.complex_event=false;
    if (instance_exists(obj_turn_end)){
        if (number!=0) then obj_turn_end.alarm[1]=4;
        instance_destroy();
    }
    instance_destroy();
   }
}
/* */
/*  */
