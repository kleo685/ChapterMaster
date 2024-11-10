// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_livery_setup(){
 draw_set_font(fnt_40k_30b);
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(38144);

    
    tooltip="";
    tooltip2="";
    obj_cursor.image_index=0;

    draw_text_color_simple(800,80,string_hash_to_newline(string(chapter_name)),38144);
    var draw_sprites = [spr_mk7_colors, spr_mk4_colors,spr_mk5_colors,spr_beakie_colors,spr_mk8_colors,spr_mk3_colors, spr_terminator3_colors];
    var draw_hem = [spr_generic_sgt_mk7, spr_generic_sgt_mk4,spr_generic_sgt_mk5,spr_generic_sgt_mk6,spr_generic_sgt_mk8,spr_generic_sgt_mk3, spr_generic_terminator_sgt];
    
    var preview_box = {
        x1: 444,
        y1: 252,
        w: 167,
        h: 232,
    }
    preview_box.x2 = preview_box.x1 + preview_box.w;
    preview_box.y2 = preview_box.y1 + preview_box.h;

	draw_sprite_stretched(spr_creation_arrow,0,preview_box.x1,preview_box.y1,32,32);// Left Arrow
    draw_sprite_stretched(spr_creation_arrow,1,preview_box.x2-32,preview_box.y1,32,32);// Right Arrow 
    if (point_and_click([preview_box.x1,preview_box.y1,preview_box.x1+32,preview_box.y1+32])){
        test_sprite++;
        if (test_sprite==array_length(draw_sprites)) then test_sprite=0;
    }   
    if (point_and_click([preview_box.x2-32,preview_box.y1,preview_box.x2, preview_box.y1+32])){
        test_sprite--;
        if (test_sprite<0) then test_sprite=(array_length(draw_sprites)-1);
    }
    var liv_string = $"Full Livery {livery_picker.role_set == 0? "Defualt" :role[100][livery_picker.role_set]}";
    draw_text(150, 200, liv_string);
    livery_picker.draw_base();
    draw_rectangle_color_simple(preview_box.x1,preview_box.y1,preview_box.x2,preview_box.y2,1,38144);
    if( shader_is_compiled(sReplaceColor)){
        shader_set(sReplaceColor);
        
        shader_set_uniform_f_array(colour_to_find1, body_colour_find );       
        shader_set_uniform_f_array(colour_to_set1, body_colour_replace );
        shader_set_uniform_f_array(colour_to_find2, secondary_colour_find );       
        shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace );
        shader_set_uniform_f_array(colour_to_find3, pauldron_colour_find );       
        shader_set_uniform_f_array(colour_to_set3, pauldron_colour_replace );
        shader_set_uniform_f_array(colour_to_find4, lens_colour_find );       
        shader_set_uniform_f_array(colour_to_set4, lens_colour_replace );
        shader_set_uniform_f_array(colour_to_find5, trim_colour_find );
        shader_set_uniform_f_array(colour_to_set5, trim_colour_replace );
        shader_set_uniform_f_array(colour_to_find6, pauldron2_colour_find );
        shader_set_uniform_f_array(colour_to_set6, pauldron2_colour_replace );
        shader_set_uniform_f_array(colour_to_find7, weapon_colour_find );
        shader_set_uniform_f_array(colour_to_set7, weapon_colour_replace );
        
        //Rejoice!
        tester_sprite = draw_sprites[test_sprite];
        tester_helm = draw_hem[test_sprite];
        if (col_special=0) then draw_sprite(tester_sprite,10,preview_box.x1,preview_box.y1 + 8);
        if (col_special=1) then draw_sprite(tester_sprite,11,preview_box.x1,preview_box.y1 + 8);
        if (col_special>=2) then draw_sprite(tester_sprite,12,preview_box.x1,preview_box.y1 + 8);
        
        draw_sprite(tester_sprite,col_special,preview_box.x1,preview_box.y1 + 8);
        if (col_special<=1){
            draw_sprite(tester_sprite,6,preview_box.x1,preview_box.y1 + 8);
            draw_sprite(tester_sprite,8,preview_box.x1,preview_box.y1 + 8);
        }
        if (col_special>=2){
            draw_sprite(tester_sprite,6,preview_box.x1,preview_box.y1 + 8);
            draw_sprite(tester_sprite,9,preview_box.x1,preview_box.y1 + 8);
        }
        if (trim=0) and (col_special<=1) then draw_sprite(tester_sprite,4,preview_box.x1,preview_box.y1 + 8);
        if (trim=0) and (col_special>=2) then draw_sprite(tester_sprite,5,preview_box.x1,preview_box.y1 + 8);
        //TODO this can be imprved but for now it's fit for purpose
        if (complex_selection=="Sergeant Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.sgt.helm_primary;
            var sgt_col_2 = complex_livery_data.sgt.helm_secondary;
            var lens_col = complex_livery_data.sgt.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        }
        else if (complex_selection=="Veteran Sergeant Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.vet_sgt.helm_primary;
            var sgt_col_2 = complex_livery_data.vet_sgt.helm_secondary;
            var lens_col = complex_livery_data.vet_sgt.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        }
        else if (complex_selection=="Captain Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.captain.helm_primary;
            var sgt_col_2 = complex_livery_data.captain.helm_secondary;
            var lens_col = complex_livery_data.captain.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        } else if (complex_selection=="Veteran Markers" && complex_livery){
            var sgt_col_1 = complex_livery_data.veteran.helm_primary;
            var sgt_col_2 = complex_livery_data.veteran.helm_secondary;
            var lens_col = complex_livery_data.veteran.helm_lens;
            shader_set_uniform_f_array(colour_to_find1, [30/255,30/255,30/255]);
            shader_set_uniform_f(colour_to_set1, col_r[sgt_col_1]/255, col_g[sgt_col_1]/255, col_b[sgt_col_1]/255);
            shader_set_uniform_f_array(colour_to_find2, [200/255,0/255,0/255]);
            shader_set_uniform_f(colour_to_set2, col_r[sgt_col_2]/255, col_g[sgt_col_2]/255, col_b[sgt_col_2]/255);
            shader_set_uniform_f(colour_to_set4, col_r[lens_col]/255, col_g[lens_col]/255, col_b[lens_col]/255);
            draw_sprite(tester_helm, complex_depth_selection, preview_box.x1,preview_box.y1 + 8);
        }                 
        shader_set_uniform_f_array(colour_to_find1, body_colour_find );       
        shader_set_uniform_f_array(colour_to_set1, body_colour_replace );
        shader_set_uniform_f_array(colour_to_find2, secondary_colour_find );       
        shader_set_uniform_f_array(colour_to_set2, secondary_colour_replace ); 
        shader_set_uniform_f_array(colour_to_set4, lens_colour_replace );
		if(tester_sprite == spr_terminator3_colors){
			draw_sprite(spr_weapon_colors,0,444 - 12,252 + 5);
		} else {
			draw_sprite(spr_weapon_colors,0,444,252);	
		}
        shader_reset();
        
    }else{
        draw_text(444,252,string_hash_to_newline("Color swap shader#did not compile"));
    }
    
    draw_set_color(38144);
    draw_set_halign(fa_left);
    draw_text_transformed(580,118,"Battle Cry:",0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    if (text_selected!="battle_cry") or (custom<2) then draw_text_ext(580,144,string_hash_to_newline(string(battle_cry)+"!"),-1,580);
    if (custom>1){
        if (text_selected="battle_cry") and (text_bar>30) then draw_text_ext(580,144,string_hash_to_newline(string(battle_cry)+"!"),-1,580);
        if (text_selected="battle_cry") and (text_bar<=30) then draw_text_ext(580,144,string_hash_to_newline(string(battle_cry)+"|!"),-1,580);
        var str_width=max(580,string_width_ext(string_hash_to_newline(battle_cry),-1,580));
        var hei=string_height_ext(string_hash_to_newline(battle_cry),-1,580);
        if (scr_hit(580-2,144-2,582+str_width,146+hei)){obj_cursor.image_index=2;
            if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="battle_cry";cooldown=8000;keyboard_string=battle_cry;}
        }
        if (text_selected="battle_cry") then battle_cry=keyboard_string;
        draw_rectangle(580-2,144-2,582+580,146+hei,1);
    }
    
    
    
    draw_rectangle(445, 200, 1125, 202, 0)
    
    draw_set_font(fnt_40k_30b);
    draw_text_transformed(444,215,"Basic Livelry",0.6,0.6,0);
    var button_alpha = custom < 2 ? 0.5 : 1;
    var livery_swap_button = draw_unit_buttons([570,215], complex_livery? "Simple Livery":"Complex Livery",[1,1], 38144,, fnt_40k_14b, button_alpha);
    if (point_and_click(livery_swap_button) && custom >= 2){
        complex_livery=!complex_livery;
    }
    var str,str_width,hei,x8,y8;x8=0;y8=0;
    //Dont ask why the pauldron colours are switched i guess duke got confused between left and right at some point
    //TODO extract this function somewhere
    /*function draw_checkbox (cords, text, main_alpha, checked){
            draw_set_alpha(main_alpha);
            yar = col_special==(i+1) ?1:0;
            if (custom<2) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (scr_hit(cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32) and allow_colour_click){
                    cooldown=8000;
                    var onceh=0;
                    if (col_special=i+1) and (onceh=0){col_special=0;onceh=1;}
                    if (col_special!=i+1) and (onceh=0){col_special=i+1;onceh=1;}
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
    }*/
    if (!complex_livery){
        var button_data = [
            {
                text : $"Primary : {col[main_color]}",
                tooltip:"Primary",
                tooltip2:"The main color of your Astartes and their vehicles.",
                cords : [620, 252],
            },
            {
                text : $"Secondary: {col[secondary_color]}",
                tooltip:"Secondary",
                tooltip2:"The secondary color of your Astartes and their vehicles.",
                cords : [620, 287],
            },
            {
                text : $"Pauldron 1: {col[right_pauldron]}",
                tooltip:"First Pauldron",
                tooltip2:"The color of your Astartes' right Pauldron.  Normally this Pauldron displays their rank and designation.",
                cords : [620, 322],
            },
            {
                text : $"Pauldron 2: {col[left_pauldron]}",
                tooltip:"Second Pauldron",
                tooltip2:"The color of your Astartes' left Pauldron.  Normally this Pauldron contains the Chapter Insignia.",
                cords : [620, 357],
            },
            {
                text : $"Trim: {col[main_trim]}",
                tooltip:"Trim",
                tooltip2:"The trim color that appears on the Pauldrons, armour plating, and any decorations.",
                cords : [620, 392],                
            },
            {
                text : $"Lens: {col[lens_color]}",
                tooltip:"Lens",
                tooltip2:"The color of your Astartes' lenss.  Most of the time this will be the visor color.",
                cords : [620, 427],                
            },
            {
                text : $"Weapon: {col[weapon_color]}",
                tooltip:"Weapon",
                tooltip2:"The primary color of your Astartes' weapons.",
                cords : [620, 462],                
            }             
        ]
        var button_cords, cur_button;
        for (var i=0;i<array_length(button_data);i++){
            cur_button = button_data[i];
            var button_alpha = custom < 2 ? 0.5 : 1;
            button_cords = draw_unit_buttons(cur_button.cords, cur_button.text,[0.5,0.5], 38144,, fnt_40k_30b, button_alpha);
            if (scr_hit(button_cords[0],button_cords[1],button_cords[2],button_cords[3])){
                tooltip=cur_button.tooltip;
                tooltip2=cur_button.tooltip2;
            }
            if (point_and_click(button_cords) && custom >= 2){
                cooldown=8000;
                instance_destroy(obj_creation_popup);
                var pp=instance_create(0,0,obj_creation_popup);
                pp.type=i+1;
            }
        }
        draw_set_color(38144);
        var livery_type_options = [
            {
                cords : [437,500],   
                text : $"Breastplate",             
            },
            {
                cords : [554,500],   
                text : $"Vertical",             
            },
            {
                cords : [662,500],   
                text : $"Quadrant",             
            },                                  
        ]
        var yar;
        for (var i=0;i<array_length(livery_type_options);i++){
            cur_button = livery_type_options[i];
            draw_set_alpha(1);
            yar = col_special==(i+1) ?1:0;
            if (cur_button.text=="Trim") then yar = trim;
            if (custom<2) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (point_and_click([cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32])){
                cooldown=8000;
                var onceh=0;
                if (cur_button.text!="Trim"){
                    if (col_special=i+1){
                        col_special=0
                    }else if (col_special!=i+1){
                        col_special=i+1;
                    }
                } else {
                    trim=!trim;
                }
	    		var struct_cols = {
	    			main_color :main_color,
	    			secondary_color:secondary_color,
	    			main_trim:main_trim,
	    			right_pauldron:right_pauldron,
	    			left_pauldron:left_pauldron,
	    			lens_color:lens_color,
	    			weapon_color:weapon_color
	    		}
	    		livery_picker.set_defualt_armour(struct_cols, col_special);          
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
        }
    } else {
        var button_data=[];
        if (complex_selection=="Sergeant Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.sgt.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of sgt.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "sgt",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.sgt.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of sgt.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "sgt",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.sgt.helm_lens]}",
                    tooltip:"Secondary",
                    tooltip2:"helm lens colour of sgt.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "sgt",
                },                
            ];
            if (turn_selection_change){
                complex_depth_selection=complex_livery_data.sgt.helm_pattern;
            } else {complex_livery_data.sgt.helm_pattern=complex_depth_selection;}

        } else if (complex_selection=="Veteran Sergeant Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.vet_sgt.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of sgt.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "vet_sgt",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.vet_sgt.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of sgt.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "vet_sgt",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.vet_sgt.helm_lens]}",
                    tooltip:"Secondary",
                    tooltip2:"helm lens colour of sgt.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "vet_sgt",
                },                
            ];
            if (turn_selection_change){
                complex_depth_selection=complex_livery_data.vet_sgt.helm_pattern;
            } else {complex_livery_data.vet_sgt.helm_pattern=complex_depth_selection;}

        }else if (complex_selection=="Captain Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.captain.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of captain.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "captain",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.captain.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of captain.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "captain",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.captain.helm_lens]}",
                    tooltip:"lens",
                    tooltip2:"helm lens colour of captain.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "captain",
                },                
            ];
             if (turn_selection_change){
                complex_depth_selection=complex_livery_data.captain.helm_pattern;
            } else {complex_livery_data.captain.helm_pattern=complex_depth_selection;}
        } else if (complex_selection=="Veteran Markers"){
            button_data = [
                {
                    text : $"Helm Primary : {col[complex_livery_data.veteran.helm_primary]}",
                    tooltip:"Primary Helm Colour",
                    tooltip2:"Primary helm colour of Veterans.",
                    cords : [620, 252],
                    type : "helm_primary",
                    role : "veteran",
                },
                {
                    text : $"Helm Secondary: {col[complex_livery_data.veteran.helm_secondary]}",
                    tooltip:"Secondary",
                    tooltip2:"Secondary helm colour of Veterans.",
                    cords : [620, 287],
                    type : "helm_secondary",
                    role : "veteran",
                },
                {
                    text : $"Helm lens: {col[complex_livery_data.veteran.helm_lens]}",
                    tooltip:"lens",
                    tooltip2:"helm lens colour of Veterans.",
                    cords : [620, 322],
                    type : "helm_lens",
                    role : "veteran",
                },                
            ];
             if (turn_selection_change){
                complex_depth_selection=complex_livery_data.veteran.helm_pattern;
            } else {complex_livery_data.veteran.helm_pattern=complex_depth_selection;}
        }
        turn_selection_change = false;
        var button_cords, cur_button;
        for (var i=0;i<array_length(button_data);i++){
            cur_button = button_data[i];
            button_cords = draw_unit_buttons(cur_button.cords, cur_button.text,[0.5,0.5], 38144,, fnt_40k_30b, 1);
            if (scr_hit(button_cords[0],button_cords[1],button_cords[2],button_cords[3])){
                 tooltip=cur_button.tooltip;
                 tooltip2=cur_button.tooltip2;
            }
            if (point_and_click(button_cords)){
                cooldown=8000;
                instance_destroy(obj_creation_popup);
                var pp=instance_create(0,0,obj_creation_popup);
                pp.type=cur_button.type;
                pp.role = cur_button.role
            }
        }
        draw_set_color(38144);
        var livery_type_options = [
            {
                cords : [437,500],   
                text : $"Single Colour",             
            },
            {
                cords : [554,500],   
                text : $"Stripe",             
            },
            {
                cords : [662,500],   
                text : $"Muzzle",             
            },
            {
                cords : [770,500],   
                text : $"Pattern",
            }                               
        ]  
        var yar;
        for (var i=0;i<array_length(livery_type_options);i++){
            cur_button = livery_type_options[i];
            draw_set_alpha(1);
            yar = complex_depth_selection==(i) ? 1 : 0;
            if (custom<2) then draw_set_alpha(0.5);
            draw_sprite(spr_creation_check,yar,cur_button.cords[0],cur_button.cords[1]);
             if (scr_hit(cur_button.cords[0],cur_button.cords[1],cur_button.cords[0]+32,cur_button.cords[1]+32) and allow_colour_click){
                    cooldown=8000;
                    var onceh=0;
                    if (complex_depth_selection=i) and (onceh=0){complex_depth_selection=0;onceh=1;}
                    else if (complex_depth_selection!=i) and (onceh=0){complex_depth_selection=i;onceh=1;}
             }
             draw_text_transformed(cur_button.cords[0]+30,cur_button.cords[1]+4,cur_button.text,0.4,0.4,0);
        }                                           
    }
    draw_set_alpha(1);
    
    draw_rectangle(844, 204, 846, 740, 0)
    draw_text_transformed(862,215,"Astartes Role Settings",0.6,0.6,0);
    draw_set_font(fnt_40k_14b);
    var c=100,role_id,spacing=30;
    draw_set_halign(fa_left);
    var xxx=862;
    var yyy=255-spacing;
    
    
    if (!complex_livery){
        
        for (var role_slot =1;role_slot<=13;role_slot++){
            var id_array = [
                0,
                Role.APOTHECARY,
                Role.CHAPLAIN,
                Role.LIBRARIAN,
                Role.TECHMARINE,
                Role.CAPTAIN,
                Role.HONOUR_GUARD,
                Role.TERMINATOR,
                Role.VETERAN,Role.DREADNOUGHT,
                Role.TACTICAL,
                Role.DEVASTATOR,
                Role.ASSAULT,
                Role.SCOUT
            ];
            role_id = id_array[role_slot];
            
            draw_set_alpha(1);
            if (race[c,role_id]!=0){
                if (custom<2) then draw_set_alpha(0.5);
                yyy+=spacing;
                draw_set_color(38144);
                draw_rectangle(xxx,yyy,1150,yyy+20,1);
                draw_set_color(38144);
                draw_text(xxx,yyy,string_hash_to_newline(role[c,role_id]));
                if (scr_hit(xxx,yyy,1150,yyy+20)) and ((!instance_exists(obj_creation_popup)) || ((instance_exists(obj_creation_popup) and obj_creation_popup.target_gear=0))) {

                    draw_set_alpha(custom==2?0.2:0.1);
                    draw_set_color(c_white);
                    draw_rectangle(xxx,yyy,1150,yyy+20,0);
                    draw_set_alpha(1);
                    tooltip=string(role[c][role_id])+" Settings";
                    tooltip2="Click to open the settings for this unit.";
                    if (mouse_left>=1) and (custom>0) and (cooldown<=0) and (custom=2){
                        instance_destroy(obj_creation_popup);
                        var pp=instance_create(0,0,obj_creation_popup);
                        pp.type=role_id+100;
                        cooldown=8000;
                        full_liveries[livery_picker.role_set] = DeepCloneStruct(livery_picker.map_colour);
                        livery_picker.role_set = role_id;
                        livery_picker.map_colour = full_liveries[role_id];
                        if (!livery_picker.map_colour.is_changed){
                            livery_picker.map_colour = DeepCloneStruct(full_liveries[0]);
                        }
                    }
                }
            }
        }
    } else {
        var complex_livery_options = ["Sergeant Markers","Veteran Sergeant Markers", "Captain Markers", "Veteran Markers"];
        for (var i=0;i<array_length(complex_livery_options);i++){
            yyy+=spacing;
            if (point_and_click(draw_unit_buttons([xxx,yyy], complex_livery_options[i],[0.5,0.5], 38144,, fnt_40k_30b, 1))){
                complex_selection=complex_livery_options[i];
                turn_selection_change=true;
            }
        }
    }
    if (livery_picker.role_set!=0){
    	if (point_and_click(draw_unit_buttons([10, 150], $"Return to defualt Livery"))){
            full_liveries[livery_picker.role_set] = DeepCloneStruct(livery_picker.map_colour);
            livery_picker.map_colour = full_liveries[0];
            livery_picker.role_set = 0;   		
    	}
    }
    
    
    
    draw_set_color(38144);
    draw_set_alpha(1);
    draw_set_font(fnt_40k_30b);
    
    if (custom<2) then draw_set_alpha(0.5);
    yar=0;
    if (equal_specialists=1) then yar=1;
    draw_sprite(spr_creation_check,yar,860,645);yar=0;
    if (scr_hit(860,650,1150,650+32)) and (!instance_exists(obj_creation_popup)){
    	tooltip="Specialist Distribution";
    	tooltip2=$"Check if you wish for your Companies to be uniform and each contain {role[100][10]}s and {role[100][9]}s.";
    }
    if (scr_hit(860,650,860+32,650+32) and allow_colour_click){
        cooldown=8000;
        var onceh=0;
        equal_specialists = !equal_specialists;
    }
    draw_text_transformed(860+30,650+4,"Equal Specialist Distribution",0.4,0.4,0);
    draw_set_alpha(1);
    
    yar=0;
    if (load_to_ships[0]=1) then yar=1;draw_sprite(spr_creation_check,yar,860,645+40);yar=0;
    if (scr_hit(860,645+40,1005,645+32+40) and !instance_exists(obj_creation_popup)){
    	tooltip="Load to Ships";
    	tooltip2="Check to have your Astartes automatically loaded into ships when the game starts.";
    }
    if (scr_hit(860,645+40,860+32,645+32+40) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup))){
        cooldown=8000;
        var onceh=0;
        load_to_ships[0] = !load_to_ships[0];
    }
    draw_text_transformed(860+30,645+4+40,"Load to Ships",0.4,0.4,0);
    
    yar=0;

    draw_sprite(spr_creation_check,load_to_ships[0]==2,1010,645+40);
    if (scr_hit(1010,645+40,1150,645+32+40)) and (!instance_exists(obj_creation_popup)){
    	tooltip="Load (Sans Escorts)";
    	tooltip2="Check to have your Astartes automatically loaded into ships, except for Escorts, when the game starts.";
    }
    if (point_and_click([1010,645+40,1020+32,645+32+40]))  and (!instance_exists(obj_creation_popup)){
        cooldown=8000;
        load_to_ships[0] =  (load_to_ships[0]!=2) ? 2 : 0; 

    }
    draw_text_transformed(1010+30,645+4+40,"Load (Sans Escorts)",0.4,0.4,0);
	
	yar=0;
	if (load_to_ships[0] > 0){
		if (load_to_ships[1] == 1){
			yar=1;
		}
		draw_sprite(spr_creation_check,yar,860,645+80);yar=0;
    	if (scr_hit(860,645+80,1005,645+32+80)) and (!instance_exists(obj_creation_popup)){tooltip="Distribute Scouts";tooltip2="Check to have your Scouts split across ships in the fleet.";}
    	if (scr_hit(860,645+80,860+32,645+32+80)) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){
    		 cooldown=8000;
             load_to_ships[1] = !load_to_ships[1];  		 
    	}
    	draw_text_transformed(860+30,645+4+80,"Distribute Scouts",0.4,0.4,0);	
	
		yar=0;
		if (load_to_ships[2] == 1){
			yar=1;
		}
		draw_sprite(spr_creation_check,yar,1010,645+80);yar=0;
    	if (scr_hit(1010,645+80,1150,645+32+80)) and (!instance_exists(obj_creation_popup)){
            tooltip="Distribute Veterans";tooltip2="Check to have your Veterans split across the fleet.";
        }
    	if (scr_hit(1010,645+80,1020+32,645+32+80)) and (cooldown<=0) and (mouse_left>=1) and (!instance_exists(obj_creation_popup)){
    		 cooldown=8000;var onceh=0;
             load_to_ships[2] = !load_to_ships[2] 		 
    	}
    	draw_text_transformed(1010+30,645+4+80,"Distribute Veterans",0.4,0.4,0);	
	}	
    
    
    
    
    draw_line(433,535,844,535);
    draw_line(433,536,844,536);
    draw_line(433,537,844,537);
    
    if (!instance_exists(obj_creation_popup)){
    
        if (scr_hit(540,547,800,725)){tooltip="Advisor Names";tooltip2="The names of your main Advisors.  They provide useful information and reports on the divisions of your Chapter.";}
    
        draw_text_transformed(444,550,string_hash_to_newline("Advisor Names"),0.6,0.6,0);
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_right);
        if (race[100,15]!=0) then draw_text(594,575,("Chief Apothecary: "));
        if (race[100,14]!=0) then draw_text(594,597,("High Chaplain: "));
        if (race[100,17]!=0) then draw_text(594,619,("Chief Librarian: "));
        if (race[100,16]!=0) then draw_text(594,641,("Forge Master: "));
        draw_text(594,663,"Master of Recruits: ");
        draw_text(594,685,"Master of the Fleet: ");
        draw_set_halign(fa_left);
        
        if (race[100,15]!=0){
            draw_set_color(38144);if (hapothecary="") then draw_set_color(c_red);
            if (text_selected!="apoth") or (custom<2) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)),-1,580);
            if (custom>1){
                if (text_selected="capoth") and (text_bar>30) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)),-1,580);
                if (text_selected="capoth") and (text_bar<=30) then draw_text_ext(600,575,string_hash_to_newline(string(hapothecary)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(hapothecary),-2,580);
                if (scr_hit(600,575,785,575+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){
                        text_selected="capoth";
                        cooldown=8000;keyboard_string=hapothecary;
                    }
                }
                if (text_selected="capoth") then hapothecary=keyboard_string;
                draw_rectangle(600-1,575-1,785,575+hei,1);
            }
        }
        
        if (race[100,14]!=0){
            draw_set_color(38144);if (hchaplain="") then draw_set_color(c_red);
            if (text_selected!="chap") or (custom<2) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)),-1,580);
            if (custom>1){
                if (text_selected="chap") and (text_bar>30) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)),-1,580);
                if (text_selected="chap") and (text_bar<=30) then draw_text_ext(600,597,string_hash_to_newline(string(hchaplain)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(hchaplain),-2,580);
                if (scr_hit(600,597,785,597+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="chap";cooldown=8000;keyboard_string=hchaplain;}
                }
                if (text_selected="chap") then hchaplain=keyboard_string;
                draw_rectangle(600-1,597-1,785,597+hei,1);
            }
        }
        
        if (race[100,17]!=0){
            draw_set_color(38144);if (clibrarian="") then draw_set_color(c_red);
            if (text_selected!="libra") or (custom<2) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)),-1,580);
            if (custom>1){
                if (text_selected="libra") and (text_bar>30) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)),-1,580);
                if (text_selected="libra") and (text_bar<=30) then draw_text_ext(600,619,string_hash_to_newline(string(clibrarian)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(clibrarian),-2,580);
                if (scr_hit(600,619,785,619+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="libra";cooldown=8000;keyboard_string=clibrarian;}
                }
                if (text_selected="libra") then clibrarian=keyboard_string;
                draw_rectangle(600-1,619-1,785,619+hei,1);
            }
        }
        
        if (race[100,16]!=0){
            draw_set_color(38144);if (fmaster="") then draw_set_color(c_red);
            if (text_selected!="forge") or (custom<2) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)),-1,580);
            if (custom>1){
                if (text_selected="forge") and (text_bar>30) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)),-1,580);
                if (text_selected="forge") and (text_bar<=30) then draw_text_ext(600,641,string_hash_to_newline(string(fmaster)+"|"),-1,580);
                var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(fmaster),-2,580);
                if (scr_hit(600,641,785,641+hei)){obj_cursor.image_index=2;
                    if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="forge";cooldown=8000;keyboard_string=fmaster;}
                }
                if (text_selected="forge") then fmaster=keyboard_string;
                draw_rectangle(600-1,641-1,785,641+hei,1);
            }
        }
        
        draw_set_color(38144);if (recruiter="") then draw_set_color(c_red);
        if (text_selected!="recr") or (custom<2) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)),-1,580);
        if (custom>1){
            if (text_selected="recr") and (text_bar>30) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)),-1,580);
            if (text_selected="recr") and (text_bar<=30) then draw_text_ext(600,663,string_hash_to_newline(string(recruiter)+"|"),-1,580);
            var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(recruiter),-2,580);
            if (scr_hit(600,663,785,663+hei)){obj_cursor.image_index=2;
                if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="recr";cooldown=8000;keyboard_string=recruiter;}
            }
            if (text_selected="recr") then recruiter=keyboard_string;
            draw_rectangle(600-1,663-1,785,663+hei,1);
        }
        
        draw_set_color(38144);if (admiral="") then draw_set_color(c_red);
        if (text_selected!="admi") or (custom<2) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)),-1,580);
        if (custom>1){
            if (text_selected="admi") and (text_bar>30) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)),-1,580);
            if (text_selected="admi") and (text_bar<=30) then draw_text_ext(600,685,string_hash_to_newline(string(admiral)+"|"),-1,580);
            var str_width,hei;str_width=0;hei=string_height_ext(string_hash_to_newline(admiral),-2,580);
            if (scr_hit(600,685,785,685+hei)){obj_cursor.image_index=2;
                if (mouse_left>=1) and (cooldown<=0) and (!instance_exists(obj_creation_popup)){text_selected="admi";cooldown=8000;keyboard_string=admiral;}
            }
            if (text_selected="admi") then admiral=keyboard_string;
            draw_rectangle(600-1,685-1,785,685+hei,1);
        }
        
        
    
    }
}