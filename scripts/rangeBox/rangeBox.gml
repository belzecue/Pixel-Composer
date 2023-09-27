function rangeBox(_type, _onModify) : widget() constructor {
	onModify   = _onModify;
	extra_data = { linked : false };
	
	tooltip	= new tooltipSelector("Value Type", [
		__txt("Random Range"),
		__txt("Constant"),
	]);
	
	onModifyIndex = function(index, val) { 
		var modi = false;
		
		if(extra_data.linked) {
			for( var i = 0; i < 2; i++ )
				modi |= onModify(i, toNumber(val)); 
			return modi;
		}
		
		return onModify(index, toNumber(val)); 
	}
	
	label = [ "min", "max" ];
	onModifySingle[0] = function(val) { return onModifyIndex(0, toNumber(val)); }
	onModifySingle[1] = function(val) { return onModifyIndex(1, toNumber(val)); }
	
	extras = -1;
	
	for(var i = 0; i < 2; i++) {
		tb[i] = new textBox(_type, onModifySingle[i]);
		tb[i].slidable = true;
	}
	
	static setSlideSpeed = function(speed) {
		tb[0].slide_speed = speed;
		tb[1].slide_speed = speed;
	}
	
	static setInteract = function(interactable = noone) { 
		self.interactable = interactable;
		
		tb[0].interactable = interactable;
		if(!extra_data.linked)
			tb[1].interactable = interactable;
	}
	
	static register = function(parent = noone) {
		tb[0].register(parent);
		if(!extra_data.linked)
			tb[1].register(parent);
	}
	
	static drawParam = function(params) {
		return draw(params.x, params.y, params.w, params.h, params.data, params.extra_data, params.m);
	}
	
	static draw = function(_x, _y, _w, _h, _data, _extra_data, _m) {
		x = _x;
		y = _y;
		w = _w;
		h = _h;
		if(struct_has(_extra_data, "linked"))	   extra_data.linked	  = _extra_data.linked;
		tooltip.index = extra_data.linked;
		
		var _icon_blend = extra_data.linked? COLORS._main_accent : COLORS._main_icon;
		var bx = _x;
		var by = _y + _h / 2 - ui(32 / 2);
		if(buttonInstant(THEME.button_hide, bx + ui(4), by + ui(4), ui(24), ui(24), _m, active, hover, tooltip, THEME.value_link, extra_data.linked, _icon_blend) == 2) {
			extra_data.linked  = !extra_data.linked;
			_extra_data.linked =  extra_data.linked;
			
			if(extra_data.linked) {
				onModify(0, _data[0]);
				onModify(1, _data[0]);
			}
		}
		
		_x += ui(28);
		_w -= ui(28);
		
		if(extra_data.linked) {
			tb[0].setFocusHover(active, hover);
			tb[0].draw(_x + ui(8), _y, _w - ui(8), _h, _data[0], _m);
		} else {
			if(is_array(_data) && array_length(_data) >= 2) {
				var ww  = _w / 2;
				for(var i = 0; i < 2; i++) {
					tb[i].setFocusHover(active, hover);
				
					var bx  = _x + ww * i;
					tb[i].draw(bx + ui(44), _y, ww - ui(44), _h, _data[i], _m);
				
					draw_set_text(f_p0, fa_left, fa_center, COLORS._main_text_sub);
					draw_text(bx + ui(8), _y + _h / 2, label[i]);
				}
			}
		}
		
		resetFocus();
		
		return h;
	}
}