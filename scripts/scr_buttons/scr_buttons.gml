function draw_unit_buttons(position, text, size_mod=[1.5,1.5],colour=c_gray,_halign=fa_center, font=fnt_40k_14b, alpha_mult=1, bg=false, bg_color=c_black){
	// TODO: fix halign usage
	// Store current state of all global vars
	var cur_alpha = draw_get_alpha();
	var cur_font = draw_get_font();
	var cur_color = draw_get_color();
	var cur_halign = draw_get_halign();
	var cur_valign = draw_get_valign();

	draw_set_font(font);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	var x2;
	var y2;
	var _text = string_hash_to_newline(text);
	if (array_length(position)>2){
		var x2 = position[2];
		var y2 = position[3];
	} else {
		var text_width = string_width(_text)*size_mod[0];
		var text_height = string_height(_text)*size_mod[1];
		var x2 = position[0]+text_width+(6*size_mod[0]);
		var y2 = position[1]+text_height+(6*size_mod[1]);
	}
	draw_set_alpha(1*alpha_mult);
	if (bg) {
		draw_set_color(bg_color);
		draw_rectangle(position[0], position[1], x2, y2, 0);
	}
	draw_set_color(colour);
	draw_text_transformed((position[0] + x2)/2, (position[1] + y2)/2, _text, size_mod[0], size_mod[1], 0);
	draw_rectangle(position[0],position[1], x2,y2,1)
	draw_set_alpha(0.5*alpha_mult);
	draw_rectangle(position[0]+1,position[1]+1, x2-1,y2-1,1)
	draw_set_alpha(0.25*alpha_mult);
	var mouse_consts = return_mouse_consts();	
	if (point_in_rectangle(mouse_consts[0],mouse_consts[1], position[0],position[1], x2,y2)){
		draw_rectangle(position[0],position[1], x2,y2,0);
	}

	// Reset all global vars to their previous state
	draw_set_alpha(cur_alpha);
	draw_set_font(cur_font);
	draw_set_color(cur_color);
	draw_set_halign(cur_halign);
	draw_set_valign(cur_valign);

	return [position[0],position[1], x2,y2];
}


//object containing draw_unit_buttons
function UnitButtonObject() constructor{
	x1 = 0;
	y1 = 0;
	w = 102;
	h = 30;
	h_gap= 4;
	v_gap= 4;
	label= "";
	alpha= 1;
	color= #50a076;
	keystroke = false;
	tooltip = "";

	static update = function(data){
		updaters = struct_get_names(data);
		for (var i=0;i<array_length(updaters);i++){
			self[$ updaters[i]] = data[$ updaters[i]];
		}
	}

	static update_loc = function(){
		x2 = x1 + w;
		y2 = y1 + h;		
	}

	update_loc();
	static move = function(m_direction, with_gap=false, multiplier=1){
		switch(m_direction){
			case "right":
				x1 +=( w+(with_gap*v_gap))*multiplier;
				x2 += (w+(with_gap*v_gap))*multiplier;
				break;
			case "left":
				x1 -= (w+(with_gap*v_gap))*multiplier;
				x2 -= (w+(with_gap*v_gap))*multiplier;
				break;
			case "down":
				y1 += (h+(with_gap*h_gap))*multiplier;
				y2 += (h+(with_gap*h_gap))*multiplier;
				break;
			case "up":
				y1 -= (h+(with_gap*h_gap))*multiplier;
				y2 -= (h+(with_gap*h_gap))*multiplier;
				break;								
		}
	}
	static draw = function(allow_click = true){
		if (scr_hit(x1, y1, x2, y2) && tooltip!=""){
			tooltip_draw(tooltip);
		}
		if (allow_click){
			return (point_and_click(draw_unit_buttons([x1, y1, x2, y2], label, [1,1],color,,,alpha)) || keystroke);
		} else {
			draw_unit_buttons([x1, y1, x2, y2], label, [1,1],color,,,alpha);
			return false;
		}
	}
}

function TextBarArea(XX,YY,Max_width = 400) constructor{
	allow_input=false;
	xx=XX;
	yy=YY
	max_width = Max_width;
	cooloff=0
    // Draw BG
    static draw = function(string_area){
		var old_font = draw_get_font();
		var old_halign = draw_get_halign();

    	if (cooloff>0) then cooloff--;
    	if (allow_input){
    		string_area=keyboard_string;
    	}
	    draw_set_alpha(1);
	    //draw_sprite(spr_rock_bg,0,xx,yy);
	    draw_set_font(fnt_40k_30b);
	    draw_set_halign(fa_center);
	    draw_set_color(c_gray);// 38144	
		var bar_wid=max_width,click_check, string_h;
	    draw_set_alpha(0.25);
	    if (string_area!=""){
	    	bar_wid=max(max_width,string_width(string_hash_to_newline(string_area)));
	    }
		string_h = string_height("LOL");
		var rect = [xx-(bar_wid/2),yy,xx+(bar_wid/2),yy-8+string_h]
	    draw_rectangle(rect[0],rect[1],rect[2],rect[3],1);
	    click_check = point_and_click(rect);
	    obj_cursor.image_index=0;
	    if (cooloff==0){
		    if (allow_input && mouse_check_button(mb_left) && !click_check){
	    	    allow_input=false;
	    	    cooloff=5;
	    	}else if (!allow_input && click_check){
		        obj_cursor.image_index=2;
		        allow_input=true;
	        	keyboard_string = string_area;
	        	cooloff=5;
		    }
		}

	    draw_set_alpha(1);

    	draw_set_font(fnt_fancy);
        if (!allow_input) then draw_text(xx,yy+2,string_hash_to_newline("''"+string(string_area)+"'' "));
        if (allow_input){
        	obj_cursor.image_index=2;
        	draw_text(xx,yy+2,string_hash_to_newline("''"+string(string_area)+"|''"))
        };

		draw_set_font(old_font);
		draw_set_halign(old_halign);

		return string_area;
	}
}

function ToggleButton() constructor {
    pos_x = 0;
    pos_y = 0;
    str1 = "";
    width = 0;
    state_alpha = 1;
    hover_alpha = 1;
    active = true;
    text_halign = fa_left;
    text_color = c_gray;
    button_color = c_gray;

    hover = function() {
        var str1_h = string_height(str1);
        return (mouse_x >= pos_x-2 && mouse_x <= pos_x+width+1 && mouse_y >= pos_y-4 && mouse_y <= pos_y+str1_h+1);
    };

    clicked = function() {
        if (hover() && mouse_check_button_pressed(mb_left) && obj_controller.cooldown <= 0) {
            active = !active; // Toggle the active state when clicked
            audio_play_sound(snd_click_small, 10, false, 1);
            return true;
        }
        else{
            return false;
        }
    };

    draw = function() {
        var str1_h = string_height(str1);
        var text_padding = width * 0.03;
        var text_x = pos_x + text_padding;
        var text_y = pos_y + text_padding;
        var total_alpha;

        if (text_halign == fa_center) {
            text_x = pos_x + (width / 2);
        }

        if (!active){
            if (state_alpha > 0.5) state_alpha -= 0.05;
        }
        else{
            if (state_alpha < 1) state_alpha += 0.05;
            if (hover()) {
                if (hover_alpha > 0.8) hover_alpha -= 0.02; // Decrease state_alpha when hovered
            } else {
                if (hover_alpha < 1) hover_alpha += 0.03; // Increase state_alpha when not hovered
            }
        }

        total_alpha = state_alpha * hover_alpha;
        draw_rectangle_color_simple(pos_x, pos_y, pos_x + width, pos_y + str1_h, 1, button_color, total_alpha);
        draw_set_halign(text_halign);
        draw_set_valign(fa_top);
        draw_text_color_simple(text_x, text_y, str1, text_color, total_alpha);
        draw_set_alpha(1);
        draw_set_halign(fa_left);
    };
}

function SwitchButton() constructor {
    pos_x = 0;
    pos_y = 0;
    str1 = "";
    alpha = 1;
    click_alpha = 1;
    locked = false;
    hover = function() {
        var str1_w = string_width(str1);
        var str1_h = string_height(str1);
        return (mouse_x >= pos_x-2 && mouse_x <= pos_x+str1_w+1 && mouse_y >= pos_y-4 && mouse_y <= pos_y+str1_h+1);
    };
    clicked = function() {
        if (hover() && mouse_check_button_pressed(mb_left)) {
            if (click_alpha > 0.8) click_alpha = 0.8; // Decrease click_alpha when clicked
            if (locked=true){
                audio_play_sound(snd_error, 10, false, 1);
            }
            else audio_play_sound(snd_click_small, 10, false, 1);
            return true;
        } else {
            if (click_alpha < 1) click_alpha += 0.03; // Increase click_alpha when not clicked
            return false;
        }
    };
    draw = function() {
        var str1_w = string_width(str1);
        var str1_h = string_height(str1);
        if (locked=true){
            if (alpha > 0.5) alpha -= 0.03;
        }
        else{
            if (hover()) {
                if (alpha > 0.8) alpha -= 0.02; // Decrease alpha when hovered
            } else {
                if (alpha < 1) alpha += 0.03; // Increase alpha when not hovered
            }
        }
        draw_set_alpha(alpha * click_alpha); // Multiply alpha and click_alpha to get the final alpha value
        draw_set_color(c_green);
        draw_rectangle(pos_x-2, pos_y-4, pos_x+str1_w+1, pos_y+str1_h+1,1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(pos_x, pos_y,str1);
        draw_set_alpha(1);
    };
}

function TextSwitchButton() constructor {
    pos_x = 0;
    pos_y = 0;
    str1 = "";
    str2 = "";
    alpha = 1;
    click_alpha = 1;
    locked = false;
    hover = function() {
        var str1_w = string_width(str1);
        var str2_w = string_width(str2);
        return (mouse_x >= pos_x+str1_w+5 && mouse_x <= pos_x+str1_w+str2_w+7 && mouse_y >= pos_y-1 && mouse_y <= pos_y + string_height(str2)+1);
    };
    clicked = function() {
        if (hover() && mouse_check_button_pressed(mb_left)) {
            if (click_alpha > 0.8) click_alpha = 0.8; // Decrease click_alpha when clicked
            if (locked=true){
                audio_play_sound(snd_error, 10, false, 1);
            }
            else audio_play_sound(snd_click_small, 10, false, 1);
            return true;
        } else {
            if (click_alpha < 1) click_alpha += 0.03; // Increase click_alpha when not clicked
            return false;
        }
    };
    draw = function() {
        var str1_w = string_width(str1);
        var str2_w = string_width(str2);
        draw_text(pos_x, pos_y, str1);
        if (hover()) {
            if (alpha > 0.8) alpha -= 0.02; // Decrease alpha when hovered
        } else {
            if (alpha < 1) alpha += 0.03; // Increase alpha when not hovered
        }
        draw_set_alpha(alpha * click_alpha); // Multiply alpha and click_alpha to get the final alpha value
        draw_set_color(c_green);
        draw_rectangle(pos_x+str1_w+5, pos_y-1, pos_x+str1_w+str2_w+7, pos_y+string_height(str2)+1,1);
        draw_text(pos_x+str1_w+6, pos_y,str2);
        draw_set_alpha(1);
    };
}