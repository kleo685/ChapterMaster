	//stashes varibles for marine reordering
function temp_marine_variables(co, unit_num){
		var unit = TTRPG[co][unit_num];
		if (unit.squad != "none"){
			var squad_member;
			var found = false;
			for (var r=0;r<array_length(squads[unit.squad].members);r++){
				squad_member = squads[unit.squad].members[r];
				try{
					if (squad_member[0] == unit.company) and (squad_member[1] == unit.marine_number){
						squads[unit.squad].members[r] = [co,array_length(temp_name)];
						found = true;
						break;
					}
				} catch( _exception) {
					handle_exception(_exception);
					unit.squad="none";
				}
			}
			if (!found){unit.squad = "none"}
		}
		array_push(temp_race,race[co][unit_num]);
		array_push(temp_loc,loc[co][unit_num]);
		array_push(temp_name,name[co][unit_num]);
		array_push(temp_role,role[co][unit_num]);
		array_push(temp_wep1,wep1[co][unit_num]);
		array_push(temp_wep2,wep2[co][unit_num]);
		array_push(temp_armour,armour[co][unit_num]);
		array_push(temp_gear,gear[co][unit_num]);
		array_push(temp_age,age[co][unit_num]);
		array_push(temp_mobi,mobi[co][unit_num]);
		array_push(temp_spe,spe[co][unit_num]);
		array_push(temp_god,god[co][unit_num]);
		array_push(temp_struct,jsonify_marine_struct(co,unit_num));
		scr_wipe_unit(co,unit_num);
}

function scr_company_order(company) {

	// company : company number
	// This sorts and crunches the marine variables for the company
	var co=company;

	var i=-1;
	//TODO optomise to reasonable array sizes
	var temp_vrace, temp_vloc, temp_vrole, temp_vwep1, temp_vwep2, temp_vup, temp_vhp, temp_vchaos, temp_vpilots, temp_vlid, temp_vwid, unit;
	var company_size = 501
    temp_race=[];
    temp_loc=[];
    temp_name=[];
    temp_role=[];
    temp_lid=[];
    temp_wid=[];
    temp_wep1=[];
    temp_wep2=[];
    temp_armour=[];
    temp_gear=[];
    temp_mobi=[];
    temp_hp=[];
    temp_chaos=[];
    temp_experience=[];
    temp_age=[];
    temp_spe=[];
    temp_god=[];
	temp_struct=[];


	/*takes a template of a role, required role number and if there are enough 
	of those units not in a squad creates a new squad of a given type*/
	function create_squad_from_squadless(squadless_and_squads,build_data,company){
		var squadless = squadless_and_squads[0];
		var empty_squads = squadless_and_squads[1];
		var role = build_data[1];
		var required_unit_count = build_data[2];
		var new_squad_type = build_data[0];
		var new_squad_index, role_number;
		if (struct_exists(squadless,role)){
			role_number = array_length(squadless[$ role]);
			while (role_number >= required_unit_count){
				new_squad_index=false;
				if (array_length(empty_squads)>0){
					new_squad_index = empty_squads[0];
					array_delete(empty_squads,0,1);
					create_squad(new_squad_type, company, false, new_squad_index);
				} else{
					create_squad(new_squad_type, company, false);
				}
				var sorted_units = 0;
				for (var i=0;i<role_number;i++){
					unit = TTRPG[company,squadless[$ role][i]];
					if (unit.squad != "none"){
						array_delete(squadless[$ role], i ,1);
						sorted_units++;
						i--;
						role_number--;
					}
				}
				//this is to catch any potential infinite loops where by squads dont get formed and the role number dosnt derease
				if (sorted_units==0) then break;
			}

		}
		return [squadless,empty_squads];
	}

	// the order that marines are displayed in the company view screen(this order is augmented by squads)
	var role_orders = role_hierarchy();

	var empty_squads=[]
	var role_shuffle_length = array_length(role_orders);
	var company_length = array_length(name[co]);
	var squadless={};
	// find units not in a squad
	for (i=0;i<company_length;i++){
		if (!is_struct(TTRPG[co][i])) then TTRPG[co][i] = new TTRPG_stats("chapter", co, i, "blank");
		unit = TTRPG[co][i];
		if (unit.squad=="none") and (unit.name()!=""){
			if (!struct_exists(squadless, unit.role())){
				squadless[$ unit.role()] = [i];
			} else {
				array_push(squadless[$ unit.role()],i);
			}
		}
	}

	//at this point check that all squads have the right types and numbers of units in them
	var squad, wanted_roles;
	for (i=0;i<array_length(squads);i++){
		if (squads[i].base_company != co){
			if (array_length(squads[i].members)==0){
				array_push(empty_squads,i);
			}
			continue;
		}
		squad = squads[i];
		squad.update_fulfilment();

		//squad has role spaces to fill
		if (squad.has_space){
			wanted_roles=struct_get_names(squad.space);

			/* this finds sqauds that are in need of members and checks ot see if there 
				are any squadless units in the chapter with
				the right role to fill the gap*/ 
			for (var r = 0;r < array_length(wanted_roles);r++){

				if (struct_exists(squadless,wanted_roles[r])){
					if (!squad.fulfilled){

						if (struct_exists(squad.required,wanted_roles[r])){

							while (array_length(squadless[$ wanted_roles[r]])>0) and (squad.required[$ wanted_roles[r]] > 0){

								array_push(squad.members,[company,squadless[$ wanted_roles[r]][0]]);

								TTRPG[co,squadless[$ wanted_roles[r]][0]].squad=i;

								array_delete(squadless[$ wanted_roles[r]],0,1);

								squad.required[$ wanted_roles[r]]--;
								
								squad.space[$ wanted_roles[r]]--;
							}
						}
					}
					if (struct_exists(squad.space,wanted_roles[r])){
						while (array_length(squadless[$ wanted_roles[r]])> 0) and (squad.space[$ wanted_roles[r]] > 0){
							array_push(squad.members,[company,squadless[$ wanted_roles[r]][0]]);
							TTRPG[co,squadless[$ wanted_roles[r]][0]].squad=i;
							array_delete(squadless[$ wanted_roles[r]],0,1);
							squad.space[$ wanted_roles[r]]--;					
						}
					}
				}
			}
			//if no new sergeants are found for squad someone gets promoted
			//find a new_sergeant 
			if (struct_exists(squad.required, role[100][18])){
				if (squad.required[$ role[100][18]] > 0){
					squad.new_sergeant();
					squad.required[$ role[100][18]]--;
				}
			}
			//find a new veteran sergeant 
			if (struct_exists(squad.required, role[100][19])){
				if (squad.required[$ role[100][19]] > 0){
					squad.new_sergeant(true);
					squad.required[$ role[100][19]]--;
				}
			}		
		}
	}

	var squadless_and_squad_spaces = [squadless,empty_squads];

	var squad_builder = [
		["tactical_squad",role[100][8],5],
		["devastator_squad",role[100][9],5],
		["sternguard_veteran_squad",role[100][3],5],
		["vanguard_veteran_squad",role[100][3],5],
		["terminator_squad",role[100][4],4],
		["terminator_assault_squad",role[100][4],4],
		["assault_squad",role[100][10],5],
		["scout_squad",role[100][12],5],
	]
	
	for (i=0;i<array_length(squad_builder);i++){
		squadless_and_squad_spaces=create_squad_from_squadless(
			squadless_and_squad_spaces,
			squad_builder[i],
			co
		);
	}

	//comand squads only get built to a max of one and are specialist so sit outside of general squad creation
	if (struct_exists(squadless,role[100,5])) && (struct_exists(squadless,role[100,7])) && (struct_exists(squadless,role[100][11])){
		if (array_length(squadless[$role[100,5]])>0) && (array_length(squadless[$role[100,7]])>0) && (array_length(squadless[$role[100][11]])>0){
			new_squad_index=false;
			if (array_length(empty_squads)>0){
				new_squad_index = empty_squads[0];
				array_delete(empty_squads,0,1);
				create_squad("command_squad", co, false, new_squad_index);
			} else{
				create_squad("command_squad", co, false);
			}
		}
	}
	var sorted_numbers = [];

	//this stops over strenuous repeats should greatly speed up company reshuffle
	for (i=0;i<company_length;i++){
		sorted_numbers[i]=i;
	}
	for (var role_name=0;role_name<role_shuffle_length;role_name++){
		var wanted_role = role_orders[role_name];
		var sort_length = array_length(sorted_numbers)-1
		i=-1;
		while (i < sort_length){
			i++;
			if (role_name == 0){
				if (name[co, sorted_numbers[i]] == ""){
					array_delete(sorted_numbers, i ,1);
					i--;
					sort_length--;
					continue;
				};
			}
			unit = TTRPG[co,sorted_numbers[i]];
			if (unit.role() == wanted_role){
				temp_marine_variables(co, sorted_numbers[i]);
				array_delete(sorted_numbers, i ,1);
				i--;
				sort_length--;
				//if unit is part of a squad make sure rest of squad is grouped next to unit			
				if (unit.squad !="none"){
					var cur_squad = unit.squad;
					var r = -1;
					while (r < sort_length){
						r++;
						var squad_unit = TTRPG[co,sorted_numbers[r]];
						if (squad_unit.squad == cur_squad){
							temp_marine_variables(co, sorted_numbers[r]);
							array_delete(sorted_numbers, r, 1);
							r--;
							sort_length--;
						}
					}
				}
			}
		}
	}
	//position 2 in role order
	/*if (global.chapter_name!="Space Wolves") and (global.chapter_name!="Iron Hands"){
	i=0;repeat(300){i+=1;
	    if (role[co][i]=role[100][14]){v+=1;
	        temp_marine_variables(co, i ,v);
	    }
	}*/

	// Return here
	for (i=0;i<array_length(temp_name);i++){
	        race[co][i]=temp_race[i];
	        loc[co][i]=temp_loc[i];
	        name[co][i]=temp_name[i];
	        role[co][i]=temp_role[i];
	        wep1[co][i]=temp_wep1[i];
	        wep2[co][i]=temp_wep2[i];
	        armour[co][i]=temp_armour[i];
	        gear[co][i]=temp_gear[i];
	        mobi[co][i]=temp_mobi[i];
	        age[co][i]=temp_age[i];
	        spe[co][i]=temp_spe[i];
	        god[co][i]=temp_god[i];
			unit = TTRPG[co][i];
			unit.load_json_data(json_parse(temp_struct[i]))
			unit.company = co;
			unit.marine_number = i;
			unit.movement_after_math();
			delete temp_struct[i];
	}
/*	i=0;repeat(300){i+=1;
	    if (role[co][i]="Death Company"){
	        if (string_count("Dreadnought",armour[co][i])>0){v+=1;
	            temp_marine_variables(co, i ,v);
	        }
	    }
	}

	i=0;repeat(300){i+=1;
	    if (role[co][i]="Death Company"){
	        if (string_count("Dreadnought",armour[co][i])=0) and (string_count("Terminator",armour[co][i])=0) and (armour[co][i]!="Tartaros"){v+=1;
	            temp_marine_variables(co, i ,v);
	        }
	    }
	}*/

}

function role_hierarchy(){

	var hierarchy = [
			"Chapter Master",
			"Forge Master",
			"Master of Sanctity",
			"Master of the Apothecarion",
			string("Chief {0}",obj_ini.role[100,Role.LIBRARIAN]),
			obj_ini.role[100][Role.HONOUR_GUARD],
			obj_ini.role[100][Role.CAPTAIN],
			obj_ini.role[100][14],
			string("{0} Aspirant",obj_ini.role[100][Role.CHAPLAIN]),
			"Death Company",
			obj_ini.role[100][16],
			string("{0} Aspirant",obj_ini.role[100][Role.TECHMARINE]),
			"Techpriest",
			obj_ini.role[100][15],
			string("{0} Aspirant",obj_ini.role[100][Role.APOTHECARY]),
			"Sister Hospitaler",
			obj_ini.role[100,17],
			"Codiciery",
			"Lexicanum",
			string("{0} Aspirant",obj_ini.role[100,Role.LIBRARIAN]),
			obj_ini.role[100][Role.ANCIENT],
			obj_ini.role[100][Role.CHAMPION],
			"Death Company",
			obj_ini.role[100][Role.VETERAN_SERGEANT],
			obj_ini.role[100][Role.SERGEANT],		
			obj_ini.role[100][4],
			obj_ini.role[100][3],
			obj_ini.role[100][8],
			obj_ini.role[100][10],
			obj_ini.role[100][9],
			obj_ini.role[100][12],
			"Venerable "+string(obj_ini.role[100][6]),
			obj_ini.role[100][6],
			"Skitarii",
			"Crusader",
			"Ranger",
			"Sister of Battle",
			"Flash Git",
			"Ork Sniper"
		];

	return hierarchy
}