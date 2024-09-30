#macro unit_type_unknown "unknown"
#macro unit_type_marine "marine"
#macro unit_type_terminator "terminator"
#macro unit_type_dreadnought "dreadnought"
#macro unit_type_land_raider "land_raider"
#macro unit_type_rhino "rhino"
#macro unit_type_predator "predator"
#macro unit_type_land_speeder "land_speeder"
#macro unit_type_whirlwind "whirlwind"

function scr_weapons_equip() {

	// gets the weapons for the particular slot

	var equipment_slot = 0;
	var equipment_tab = 0;
	var unit_type = "";
	var unit_role = "";
	var unit_is_vehicle = false;
	var standard_equip = false;
	var creation_equip = false;
	var mass_equip = false;
	var equip_data;
	var valid = 0;
	var i = 0;
	item_name = [];
	var normal_ranged_list = [
		"Bolt Pistol",
		"Bolter",
		"Stalker Pattern Bolter",
		"Storm Bolter",
		"Heavy Bolter",
		"Combiflamer",
		"Flamer",
		"Heavy Flamer",
		"Lascannon",
		"Lascutter",
		"Infernus Pistol",
		"Meltagun",
		"Multi-Melta",
		"Plasma Pistol",
		"Plasma Gun",
		"Plasma Cannon",
		"Missile Launcher",
		"Autocannon",
		"Sniper Rifle",
		"Webber"
	];
	var normal_melee_list = [
		"Combat Knife",
		"Chainsword",
		"Chainaxe",
		"Eviscerator",
		"Power Sword",
		"Power Axe",
		"Power Spear",
		"Power Mace",
		"Power Fist",
		"Boltstorm Gauntlet",
		"Lightning Claw",
		"Force Staff",
		"Thunder Hammer",
		"Heavy Thunder Hammer",
		"Boarding Shield",
		"Storm Shield"
	];
	var terminator_ranged_list = [
		"Storm Bolter",
		"Combiflamer",
		"Heavy Flamer",
		"Multi-Melta",
		"Plasma Cannon",
		"Assault Cannon"
	];
	var terminator_melee_list = [
		"Chainaxe",
		"Power Sword",
		"Power Axe",
		"Power Mace",
		"Power Fist",
		"Boltstorm Gauntlet",
		"Chainfist",
		"Lightning Claw",
		"Force Staff",
		"Thunder Hammer",
		"Heavy Thunder Hammer",
		"Boarding Shield",
		"Storm Shield"
	];
	var dreadnought_ranged_list = [
		"Multi-Melta",
		"Twin Linked Heavy Flamer Sponsons",
		"Plasma Cannon",
		"Assault Cannon",
		"Autocannon",
		"Missile Launcher",
		"Twin Linked Lascannon",
		"Twin Linked Assault Cannon Mount",
		"Twin Linked Heavy Bolter",
		"Heavy Conversion Beam Projector"
	];
	var dreadnought_melee_list = [
		"Close Combat Weapon",
		"Dreadnought Power Claw",
		"Dreadnought Lightning Claw",
	];
	var normal_armour_list = [
		"MK3 Iron Armour",
		"MK4 Maximus",
		"MK5 Heresy",
		"MK6 Corvus",
		"MK7 Aquila",
		"MK8 Errant",
	];
	var terminator_armour_list = [
		"Terminator Armour",
		"Tartaros",
	];
	var dreadnought_armour_list = [
		"Dreadnought",
	];
	var normal_gear_list = [
		"Combat Shield",
		"Iron Halo",
		"Plasma Bomb",
	];
	var normal_mobility_list = [
		"Jump Pack",
		"Heavy Weapons Pack",
		"Bike",
	];
	var dreadnought_mobility_list = [
		"Searchlight",
		"Smoke Launchers",
		"Frag Assault Launchers",
	];

	// This is for equipping the selected marines on the company view
	if (instance_exists(obj_controller)) and(instance_exists(obj_popup)) and(!instance_exists(obj_mass_equip)) {
		standard_equip = true;
		equipment_slot = target_comp;
		equipment_tab = tab;
		unit_role = obj_popup.unit_role;
		unit_type = obj_popup.unit_type;
		unit_is_vehicle = obj_popup.unit_is_vehicle;
	}
	// This is for equipping roles on the creation screen
	else if (instance_exists(obj_creation)) {
		creation_equip = true;
		equipment_slot = target_gear;
		equipment_tab = tab;
		unit_role = obj_creation_popup.type - 100
		if (unit_role >= 50) {
			unit_is_vehicle = obj_popup.unit_is_vehicle;
			return;
		} else if (unit_role == 4) {
			unit_type = unit_type_terminator;
		} else if (unit_role == 6) {
			unit_type = unit_type_dreadnought;
		} else {
			unit_type = unit_type_marine;
		}
	}
	// This is for equipping roles on the chapter management screen
	else if (instance_exists(obj_mass_equip)) {
		// equipment_slot=tab;equipment_tab=1;
		mass_equip = true;
		equipment_tab = tab;
		equipment_slot = tab;
		unit_role = obj_mass_equip.role;
		if (unit_role >= 50) {
			return;
		} else if (unit_role == 4) {
			unit_type = unit_type_terminator;
		} else if (unit_role == 6) {
			unit_type = unit_type_dreadnought;
		} else {
			unit_type = unit_type_marine;
		}
	}

	if (unit_role == 14) {
		normal_gear_list = ["Rosarius"];
	} else if (unit_role == 15) {
		normal_gear_list = ["Narthecium"];
	} else if (unit_role == 16) {
		normal_mobility_list = ["Servo-arm", "Servo-harness"];
	} else if (unit_role == 17) {
		normal_gear_list = ["Psychic Hood"];
	} else if (unit_role == 12) {
		normal_armour_list = ["Scout Armour"]
	}

	if (equipment_slot <= 2) and (!unit_is_vehicle) {
		if (equipment_tab = 1) {
			if (standard_equip) { // Infantry Ranged
				item_name[0] = "(None)";
				item_name[1] = "(any)";
				valid = 2;
				for (i = 0; i < array_length(obj_ini.equipment); i++) {
					if (obj_popup.master_crafted == 1) {
						if (!array_contains(obj_ini.equipment_quality[i], "master_crafted")) {
							continue;
						}
					}
					equip_data = gear_weapon_data("weapon", obj_ini.equipment[i]);
					if (is_struct(equip_data) && obj_ini.equipment_number[i] > 0 && equip_data.has_unit(unit_type)) {
						if (equip_data.range > 1.1) {
							item_name[valid] = equip_data.name;
							valid++;
						}
					}
				}
			} else {
				item_name[0] = "(None)";
				item_name[1] = "(any)";
				switch (unit_type) {
					case unit_type_marine:
						item_name = array_concat(item_name, normal_ranged_list);
						break;
					case unit_type_terminator:
						item_name = array_concat(item_name, terminator_ranged_list);
						break;
					case unit_type_dreadnought:
						item_name = array_concat(item_name, dreadnought_ranged_list);
						break;
					default:
						break;
				}				
			}
		} else if (equipment_tab = 2) {
			if (standard_equip) {
				item_name[0] = "(None)";
				item_name[1] = "(any)";
				valid = 2;
				for (i = 0; i < array_length(obj_ini.equipment); i++) {
					if (obj_popup.master_crafted == 1) {
						if (!array_contains(obj_ini.equipment_quality[i], "master_crafted")) {
							continue;
						}
					}
					equip_data = gear_weapon_data("weapon", obj_ini.equipment[i]);
					if (is_struct(equip_data) && obj_ini.equipment_number[i] > 0 && equip_data.has_unit(unit_type)) {
						if (equip_data.range <= 1.1) {
							item_name[valid] = equip_data.name;
							valid++;
						}
					}
				}
			} else {
				switch (unit_type) {
					case unit_type_marine:
						item_name = array_concat(item_name, normal_melee_list);
						break;
					case unit_type_terminator:
						item_name = array_concat(item_name, terminator_melee_list);
						break;
					case unit_type_dreadnought:
						item_name = array_concat(item_name, dreadnought_melee_list);
						break;
					default:
						break;
				}
			}
		}
	}

	if (equipment_slot == 3 and !unit_is_vehicle) {
		if (standard_equip) {
			item_name[0] = "(None)";
			item_name[1] = "(any)";
			valid = 2;
			for (i = 0; i < array_length(obj_ini.equipment); i++) {
				equip_data = gear_weapon_data("armour", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i] > 0 && equip_data.has_unit(unit_type)) {
					item_name[valid] = equip_data.name;
					valid++;
				}
			}
		} else {
			item_name[0] = "(None)";
			item_name[1] = "(any)";
			switch (unit_type) {
				case unit_type_marine:
					item_name = array_concat(item_name, normal_armour_list);
					break;
				case unit_type_terminator:
					item_name = array_concat(item_name, terminator_armour_list);
					break;
				case unit_type_dreadnought:
					item_name = array_concat(item_name, dreadnought_armour_list);
					break;
				default:
					break;
			}
		}
	}

	if (equipment_slot = 4 and !unit_is_vehicle) { 
		if (standard_equip) {
			item_name[0] = "(None)";
			valid = 1;
			for (i = 0; i < array_length(obj_ini.equipment); i++) {
				equip_data = gear_weapon_data("gear", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i] > 0 && equip_data.has_unit(unit_type)) {
					item_name[valid] = equip_data.name;
					valid++;
				}
			}
		} else {
			item_name[0] = "(None)";
			switch (unit_type) {
				case unit_type_marine:
					item_name = array_concat(item_name, normal_gear_list);
					break;
				case unit_type_terminator:
					item_name = array_concat(item_name, terminator_gear_list);
					break;
				case unit_type_dreadnought:
					item_name = array_concat(item_name, dreadnought_gear_list);
					break;
				default:
					break;
			}
		}
	}
	if (equipment_slot = 5 and !unit_is_vehicle) { // unit_type == unit_type_marine for normal infantry gear
		if (standard_equip) {
			item_name[0] = "(None)";
			valid = 1;
			for (i = 0; i < array_length(obj_ini.equipment); i++) {
				equip_data = gear_weapon_data("mobility", obj_ini.equipment[i]);
				if (is_struct(equip_data) && obj_ini.equipment_number[i] > 0 && equip_data.has_unit(unit_type)) {
					item_name[valid] = equip_data.name;
					valid++;
				}
			}
		} else {
			item_name[0] = "(None)";
			switch (unit_type) {
				case unit_type_marine:
					item_name = array_concat(item_name, normal_mobility_list);
					break;
				case unit_type_terminator:
					item_name = array_concat(item_name, terminator_mobility_list);
					break;
				case unit_type_dreadnought:
					item_name = array_concat(item_name, dreadnought_mobility_list);
					break;
				default:
					break;
			}
		}
	}

	if (equipment_slot = 1) and(equipment_tab = 1) and(unit_type == unit_type_land_raider) {
		i = 0; // Land Raider Regular Front Weapon
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Twin Linked Heavy Bolter Mount";
		i += 1;
		item_name[i] = "Twin Linked Lascannon Mount";
		i += 1;
		item_name[i] = "Twin Linked Assault Cannon Mount";
		i += 1;
		item_name[i] = "Whirlwind Missiles";
	}

	if (equipment_slot = 1) and(equipment_tab = 2) and(unit_type == unit_type_land_raider) {
		i = 0; // Land Raider Relic Front Weapon
		i += 1;
		item_name[i] = "(None)";
		//i+=1;item_name[i]="Thunderfire Cannon Mount";
		i += 1;
		item_name[i] = "Neutron Blaster Turret";
		i += 1;
		item_name[i] = "Reaper Autocannon Mount";
		//i+=1;item_name[i]="Twin Linked Helfrost Cannon Mount";
		//i+=1;item_name[i]="Graviton Cannon Mount";
	}

	if (equipment_slot = 2) and(equipment_tab = 1) and(unit_type == unit_type_land_raider) {
		i = 0; // Land Raider Regular Sponsons
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Twin Linked Lascannon Sponsons";
		i += 1;
		item_name[i] = "Hurricane Bolter Sponsons";
		i += 1;
		item_name[i] = "Flamestorm Cannon Sponsons";
	}

	if (equipment_slot = 2) and(equipment_tab = 2) and(unit_type == unit_type_land_raider) {
		i = 0; // Land Raider Relic Sponsons
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Quad Linked Heavy Bolter Sponsons";
		i += 1;
		item_name[i] = "Twin Linked Heavy Flamer Sponsons";
		i += 1;
		item_name[i] = "Twin Linked Multi-Melta Sponsons";
		i += 1;
		item_name[i] = "Twin Linked Volkite Culverin Sponsons";
	}

	if (equipment_slot = 3) and(equipment_tab = 1) and(unit_type == unit_type_land_raider) {
		i = 0; // Land Raider Pintle
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Bolter";
		i += 1;
		item_name[i] = "Combiflamer";
		i += 1;
		item_name[i] = "Twin Linked Bolters";
		i += 1;
		item_name[i] = "Storm Bolter";
		i += 1;
		item_name[i] = "HK Missile";
	}

	if (equipment_slot < 3) and(equipment_tab = 1) and(unit_type == unit_type_rhino) {
		i = 0; // Rhino Weapons
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Bolter";
		i += 1;
		item_name[i] = "Combiflamer";
		i += 1;
		item_name[i] = "Twin Linked Bolters";
		i += 1;
		item_name[i] = "Storm Bolter";
		i += 1;
		item_name[i] = "HK Missile";
	}

	if (equipment_slot = 1) and(equipment_tab = 1) and(unit_type == unit_type_predator) {
		i = 0; // Predator Turret
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Autocannon Turret";
		i += 1;
		item_name[i] = "Twin Linked Lascannon Turret";
		i += 1;
		item_name[i] = "Flamestorm Cannon Turret";
		i += 1;
		item_name[i] = "Twin Linked Assault Cannon Turret";
		i += 1;
		item_name[i] = "Magna-Melta Turret";
		i += 1;
		item_name[i] = "Plasma Destroyer Turret";
		i += 1;
		item_name[i] = "Heavy Conversion Beam Projector";
		i += 1;
		item_name[i] = "Neutron Blaster Turret";
		i += 1;
		item_name[i] = "Volkite Saker Turret";
		//i+=1;item_name[i]="Graviton Cannon Turret";
	}
	if (equipment_slot = 2) and(equipment_tab = 1) and(unit_type == unit_type_predator) {
		i = 0; // Predator Sponsons
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Heavy Bolter Sponsons";
		i += 1;
		item_name[i] = "Lascannon Sponsons";
		i += 1;
		item_name[i] = "Heavy Flamer Sponsons";
		i += 1;
		item_name[i] = "Volkite Culverin Sponsons";
	}
	if (equipment_slot = 3) and(equipment_tab = 1) and(unit_type == unit_type_predator) {
		i = 0; // Predator Pintle
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Bolter";
		i += 1;
		item_name[i] = "Combiflamer";
		i += 1;
		item_name[i] = "Twin Linked Bolters";
		i += 1;
		item_name[i] = "Storm Bolter";
		i += 1;
		item_name[i] = "HK Missile";
	}
	if (equipment_slot = 1) and(equipment_tab = 1) and(unit_type == unit_type_land_speeder) {
		i = 0; // Land Speeder Primary
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Multi-Melta";
		i += 1;
		item_name[i] = "Heavy Bolter";
	}

	if (equipment_slot = 2) and(equipment_tab = 1) and(unit_type == unit_type_land_speeder) {
		i = 0; // Land Speeder Secondary
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Assault Cannon";
		i += 1;
		item_name[i] = "Heavy Flamer";
	}

	if (equipment_slot = 1) and(equipment_tab = 1) and(unit_type == unit_type_whirlwind) {
		i = 0; // Whirlwind Missiles
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Whirlwind Missiles";
	}

	if (equipment_slot = 2) and(equipment_tab = 1) and(unit_type == unit_type_whirlwind) {
		i = 0; // Whirlwind Pintle
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Bolter";
		i += 1;
		item_name[i] = "Combiflamer";
		i += 1;
		item_name[i] = "Twin Linked Bolters";
		i += 1;
		item_name[i] = "Storm Bolter";
		i += 1;
		item_name[i] = "HK Missile";
	}

	if (equipment_slot = 4) and(equipment_tab = 1) and((unit_type == unit_type_land_raider) or(unit_type == unit_type_rhino) or(unit_type == unit_type_predator) or(unit_type == unit_type_whirlwind)) {
		i = 0; // Tank Upgrade
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Armoured Ceramite";
		i += 1;
		item_name[i] = "Artificer Hull";
		i += 1;
		item_name[i] = "Heavy Armour";
		if unit_type == unit_type_land_raider {
			i += 1;
			item_name[i] = "Void Shield";
		} //only for Land Raiders
	}
	if (equipment_slot = 5) and(equipment_tab = 1) and((unit_type == unit_type_land_raider) or(unit_type == unit_type_rhino) or(unit_type == unit_type_predator) or(unit_type == unit_type_whirlwind)) {
		i = 0; // Tank Accessory
		i += 1;
		item_name[i] = "(None)";
		i += 1;
		item_name[i] = "Dozer Blades"
		i += 1;
		item_name[i] = "Searchlight";
		i += 1;
		item_name[i] = "Smoke Launchers";
		i += 1;
		item_name[i] = "Frag Assault Launchers";
		if (unit_type != unit_type_land_raider){
			i += 1;
			item_name[i] = "Lucifer Pattern Engine"
		}; //not available for Land Raiders
	}
}