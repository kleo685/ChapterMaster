
var i=0,new_exp, cur_exp, unit;
total_battle_exp_gain = 0;
if (obj_ncombat.defeat=0){
    for (i=0;i<array_length(unit_struct);i++){
        unit=unit_struct[i];
        if (is_struct(unit)){
            if (marine_dead[i]=0) and (obj_ncombat.player_max<obj_ncombat.enemy_max) and (ally[i]==false){
                new_exp=0;
                cur_exp=unit.experience;
                if (cur_exp>=40) then new_exp+=choose(0,0,1);
                if (cur_exp>=20) and (cur_exp<40) then new_exp+=choose(0,1);
                if (cur_exp<20) then new_exp+=1;
                
                if (obj_ncombat.enemy=10) and (obj_ncombat.threat=7){
                    if (cur_exp>=40) then new_exp+=choose(2,3,4);
                    if (cur_exp>=20) and (cur_exp<40) then new_exp+=choose(4,6,8);
                    if (cur_exp<20) then new_exp+=10;
                }
                if (new_exp>0){
                    unit.add_exp(new_exp);
                    obj_ncombat.total_battle_exp_gain+=new_exp;
                }
                if (unit.IsSpecialist("libs")) then unit.update_powers();
                // Need some kind of report here
            }
            
            if (marine_type[i]!="") and (marine_dead[i]==1) and (ally[i]=false){
                if (marine_type[i]=="Chapter Master"){
                    if (obj_ncombat.unit_recovery_score>0){
                        obj_ncombat.unit_recovery_score-=1;
                        unit.update_health(irandom(20)-10);
                        marine_dead[i]=0;
                        obj_ncombat.units_saved+=1;                
                    }
                }else if (marine_type[i]!=""){
                    if (obj_ncombat.unit_recovery_score>0){
                        obj_ncombat.unit_recovery_score-=1;
                        unit.update_health(irandom(20)-10);
                        marine_dead[i]=0;
                        obj_ncombat.units_saved+=1;
                        // show_message(string(marine_type[i])+" is saved by an apothecary");
                    }
                }
            }
        }
    }
    for (i=0;i<array_length(veh_dead);i++){    
        if (veh_type[i]!="") and (veh_dead[i]=1) and (veh_ally[i]=false){
            if (obj_controller.stc_bonus[3]=4) {
                var rand1, survival;onceh=0;
                survival=20;
                rand1=floor(random(100))+1;
                if (rand1<=survival) and (veh_dead[i]!=2){
                    veh_hp[i]=10;
                    veh_dead[i]=0;
                    obj_ncombat.vehicles_saved+=1;
                }
            } 
            if (veh_dead[i]==1 && obj_ncombat.vehicle_recovery_score>0) {
                obj_ncombat.vehicle_recovery_score-=1;
                veh_hp[i]=10;
                veh_dead[i]=0;
                obj_ncombat.vehicles_saved+=1;
            }
        }
    }
}

i=0;

 for (i=0;i<array_length(unit_struct);i++){
    if (marine_id[i]==0) then continue;
    unit=unit_struct[i];
    if (marine_dead[i]=0) and (marine_type[i]=="Death Company"){
        if( unit.role()!="Death Company"){
            unit.update_role("Death Company");
        }
    }
    if (unit.base_group=="astartes"){
        if (marine_dead[i]=0) and (unit.gene_seed_mutations.mucranoid==1) and (ally[i]=false){
            var muck=floor(random(200))+1;
            if (muck=50){    //slime is armour destroyed due to mucranoid
                if (array_contains(global.power_armour,unit.armour())){
                    unit.update_armour("", false, false);
                    obj_ncombat.mucra[marine_co[i]]=1;
                    obj_ncombat.slime+=1;
                }
            }
        }
    }
    
    if (ally[i]=false){
        if (marine_dead[i]=0) and (obj_ini.gear[marine_co[i],marine_id[i]]="Plasma Bomb") and (obj_ncombat.defeat=0) and (string_count("mech",obj_ncombat.battle_special)=0){
            if (obj_ncombat.plasma_bomb=0) and (obj_ncombat.enemy=13) and (awake_tomb_world(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id])==1){
                if (((obj_ncombat.battle_object.p_necrons[obj_ncombat.battle_id]-2)<3) and (obj_ncombat.dropping!=0)) or ((obj_ncombat.battle_object.p_necrons[obj_ncombat.battle_id]-1)<3){
                    obj_ncombat.plasma_bomb+=1;
                    obj_ini.gear[marine_co[i],marine_id[i]]="";
                }
            }
        }
        if (marine_dead[i]=0) and (obj_ini.gear[marine_co[i],marine_id[i]]="Exterminatus") and (obj_ncombat.dropping!=0) and (obj_ncombat.defeat=0){
            if (obj_ncombat.exterminatus=0){
                obj_ncombat.exterminatus+=1;
                unit.update_gear("", false,false);
            }
            // obj_ncombat.exterminatus+=1;scr_add_item("Exterminatus",1);
            // obj_ini.gear[marine_co[i],marine_id[i]]="";
        }
    }
    
    var destroy;destroy=0;
    if ((marine_dead[i]>0) or (obj_ncombat.defeat!=0)) and (marine_type[i]!="") and (ally[i]=false){

        var comm=false;
        if (unit.IsSpecialist("standard",true)){
            obj_ncombat.final_command_deaths+=1;
            var recent=true;
            if (is_specialist(unit.role, "trainee")){
                recent=false
            } else if (array_contains([string("Venerable {0}",obj_ini.role[100][6]), "Codiciery", "Lexicanum"], unit.role())){
                recent=false
            }
            if (recent=true) then scr_recent("death_"+string(marine_type[i]),string(obj_ini.name[marine_co[i],marine_id[i]]),marine_co[i]);            
        } else {
            obj_ncombat.final_deaths+=1;
        }
        // obj_ncombat.final_deaths+=1;
        
        // show_message("ded; increase final deaths");
        
        if (obj_controller.blood_debt=1){
            if (unit.role()==obj_ini.role[100][12]){
                obj_controller.penitent_current+=2
            } else {obj_controller.penitent_current+=4;}
            obj_controller.penitent_turn=0;
            obj_controller.penitent_turnly=0;
        }
        
        if  (obj_ini.race[marine_co[i],marine_id[i]]=1){
            var age=obj_ini.age[marine_co[i],marine_id[i]];
            if (age<=((obj_controller.millenium*1000)+obj_controller.year)-10) and (obj_ini.zygote=0) then obj_ncombat.seed_max+=1;
            if (age<=((obj_controller.millenium*1000)+obj_controller.year)-5) then obj_ncombat.seed_max+=1;
        }
        
        var last=0;
        for (var o=1;o<array_length(obj_ncombat.post_unit_lost);o++){
            if (obj_ncombat.post_unit_lost[o]=unit.role()){
                obj_ncombat.post_units_lost[o]+=1;
                break;
            }else if (obj_ncombat.post_unit_lost[o]=""){
                obj_ncombat.post_unit_lost[o]=marine_type[i];
                obj_ncombat.post_units_lost[o]=1;
                break;
            }
        }
        
        // Determine which companies to crunch
        obj_ncombat.crunch[marine_co[i]]=1;
        destroy=1;
    }
        
    if (marine_armour[i]="") and (marine_wep1[i]="") and (marine_wep2[i]="") and (marine_gear[i]="") and (marine_mobi[i]="") and (marine_type[i]!="") then destroy=2;
    
    if (destroy>0) and (marine_type[i]!="") and (ally[i]=false){// 135
        var wah=0,artif=false;
        repeat(5){
            wah+=1;
            artif=false;
            var eqp_chance, dece;
            eqp_chance=50;
            dece=floor(random(100))+1;
            if (obj_ncombat.defending=false) then eqp_chance-=10;
            if (obj_ncombat.dropping=1) then eqp_chance-=20;
            if (obj_ncombat.dropping=1) and (obj_ncombat.defeat=1) then dece=9999;
            if (marine_dead[i]=2) or (destroy=2) then dece=9999;
            if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;
            
            // if (wah=1){show_message(obj_ini.armour[marine_co[i],marine_id[i]]);}
            arti=!is_string(unit.armour(true));
            var arm_data = unit.get_armour_data();
            if (wah=1) and (is_struct(arm_data)){
                if (arm_data.has_tag("terminator")) then eqp_chance+=30;
                if (string_count("&",marine_armour[i])>0){
                    eqp_chance=90;
                    artif=true;
                }
                if (dece>eqp_chance){
                    var last=0;o=0;
                    repeat(50){
                        if (last=0){
                            o+=1;artif=false;
                            if (obj_ncombat.post_equipment_lost[o]=marine_armour[i]){
                                last=1;
                                obj_ncombat.post_equipments_lost[o]+=1;
                                artif=true;
                            }
                            if (obj_ncombat.post_equipment_lost[o]="") and (last=0){last=o;
                                obj_ncombat.post_equipment_lost[o]=marine_armour[i];
                                obj_ncombat.post_equipments_lost[o]=1;
                                artif=true;
                            }
                            if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                            
                            obj_ini.armour[marine_co[i],marine_id[i]]="";
                            // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                        }
                    }
                }
                if (dece<=eqp_chance) then scr_add_item(marine_armour[i],1);
            }
            if (wah=2) and (obj_ini.wep1[marine_co[i],marine_id[i]]!=""){
                if (string_count("&",marine_wep1[i])>0){eqp_chance=90;artif=true;}
                if (marine_wep1[i]="Company Standard") then eqp_chance=99;
                if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;
            
                if (dece>eqp_chance){
                    var last,o;last=0;o=0;
                    repeat(50){
                        if (last=0){
                            o+=1;artif=false;
                            
                            // show_message(string(o)+"]"+string(obj_ncombat.post_equipment_lost[o])+"   "+string(i)+"]"+string(marine_wep1[i]));
                            
                            if (string(obj_ncombat.post_equipment_lost[o])=marine_wep1[i]){last=1;obj_ncombat.post_equipments_lost[o]+=1;artif=true;}
                            if (string(obj_ncombat.post_equipment_lost[o])="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_wep1[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                            if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                            obj_ini.wep1[marine_co[i],marine_id[i]]="";
                            // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                        }
                    }
                }
                if (dece<=eqp_chance) then scr_add_item(marine_wep1[i],1);
            }
            if (wah=3) and (obj_ini.wep2[marine_co[i],marine_id[i]]!=""){
                if (string_count("&",marine_wep2[i])>0){eqp_chance=90;artif=true;}
                if (marine_wep2[i]="Company Standard") then eqp_chance=99;
                if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;
                
                if (dece>eqp_chance){
                    var last,o;last=0;o=0;
                    repeat(50){
                        if (last=0){
                            o+=1;artif=false;
                            if (string(obj_ncombat.post_equipment_lost[o])=marine_wep2[i]){last=1;obj_ncombat.post_equipments_lost[o]+=1;artif=true;}
                            if (string(obj_ncombat.post_equipment_lost[o])="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_wep2[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                            if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                            obj_ini.wep2[marine_co[i],marine_id[i]]="";
                            // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                        }
                    }
                }
                if (dece<=eqp_chance) then scr_add_item(marine_wep2[i],1);
            }
            if (wah=4) and (obj_ini.gear[marine_co[i],marine_id[i]]!=""){
                if (string_count("&",marine_gear[i])>0){eqp_chance=90;artif=true;}
                if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;
                
                if (obj_ini.gear[marine_co[i],marine_id[i]]="Exterminatus"){
                    if (obj_ncombat.defeat=0){
                        dece=0;
                        if (obj_ncombat.dropping!=0) then obj_ncombat.exterminatus+=1;
                    }
                    if (obj_ncombat.defeat!=0) then dece=9999;
                }
                
                if (dece>eqp_chance){
                    var last,o;last=0;o=0;
                    repeat(50){
                        if (last=0){
                            o+=1;artif=false;
                            if (obj_ncombat.post_equipment_lost[o]=marine_gear[i]){last=1;obj_ncombat.post_equipments_lost[o]+=1;artif=true;}
                            if (obj_ncombat.post_equipment_lost[o]="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_gear[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                            if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                            obj_ini.gear[marine_co[i],marine_id[i]]="";
                            // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                        }
                    }
                }
                if (dece<=eqp_chance) then scr_add_item(marine_gear[i],1);
            }
            if (wah=5) and (obj_ini.mobi[marine_co[i],marine_id[i]]!=""){
                if (string_count("&",marine_mobi[i])>0){
                    eqp_chance=90;
                    artif=true;
                }
                if (marine_dead[i]=2) or (destroy=2) then dece=9999;
                if (obj_ini.race[marine_co[i],marine_id[i]]!=1) then dece=9999;
                
                if (dece>eqp_chance){
                    var last,o;last=0;o=0;
                    repeat(50){
                        if (last=0){
                            o+=1;
                            artif=false;
                            if (obj_ncombat.post_equipment_lost[o]=marine_mobi[i]){
                                last=1;
                                obj_ncombat.post_equipments_lost[o]+=1;
                                artif=true;
                            }
                            if (obj_ncombat.post_equipment_lost[o]="") and (last=0){last=o;obj_ncombat.post_equipment_lost[o]=marine_mobi[i];obj_ncombat.post_equipments_lost[o]=1;artif=true;}
                            if (artif=true) then obj_ncombat.post_equipment_lost[o]=clean_tags(obj_ncombat.post_equipment_lost[o]);
                            obj_ini.mobi[marine_co[i],marine_id[i]]="";
                            // wep2[0,i]="";armour[0,i]="";gear[0,i]="";mobi[0,i]="";
                        }
                    }
                }
                if (dece<=eqp_chance) then scr_add_item(marine_mobi[i],1);
            }
        }
        
        
        
    }
}

for (i=0;i<array_length(veh_dead);i++){
    if ((veh_dead[i]=1) or (obj_ncombat.defeat!=0)) and (veh_type[i]!="") and (veh_ally[i]=false){
        obj_ncombat.vehicle_deaths+=1;
        
        var last=0,o=0;
        for (var o=0;o<array_length(obj_ncombat.post_unit_lost);o++){
            if (last=0){
                o+=1;
                if (obj_ncombat.post_unit_lost[o]=veh_type[i]){
                    last=1;
                    obj_ncombat.post_units_lost[o]+=1;
                }
                else if (obj_ncombat.post_unit_lost[o]="") and (last=0){
                    last=o;
                    obj_ncombat.post_unit_lost[o]=veh_type[i];
                    obj_ncombat.post_units_lost[o]=1;
                    obj_ncombat.post_unit_veh[o]=1;
                }
            }
        }
        
        // Determine which companies to crunch
        obj_ncombat.crunch[veh_co[i]]=1;
        
    }
}