#region context menu
	globalvar CONTEXT_MENU_CALLBACK;
	CONTEXT_MENU_CALLBACK = ds_map_create();
	
	function menuCall(menu_id = "", _x = mouse_mx + ui(4), _y = mouse_my + ui(4), menu = [], align = fa_left) {
		var dia = dialogCall(o_dialog_menubox, _x, _y);
		if(menu_id != "" && ds_map_exists(CONTEXT_MENU_CALLBACK, menu_id)) {
			var callbacks = CONTEXT_MENU_CALLBACK[? menu_id];
			
			for( var i = 0; i < array_length(callbacks); i++ ) 
				array_append(menu, callbacks[i].populate());
		}
		
		dia.setMenu(menu, align);
		return dia;
	}

	function submenuCall(_x, _y, _depth, menu = []) {
		var dia = instance_create_depth(_x - ui(4), _y, _depth - 1, o_dialog_menubox);
		dia.setMenu(menu);
		return dia;
	}

	function menuItem(name, func, spr = noone, hotkey = noone, toggle = noone) {
		return new MenuItem(name, func, spr, hotkey, toggle);
	}
	function MenuItem(name, func, spr = noone, hotkey = noone, toggle = noone) constructor {
		active = true;
		self.name	= name;
		self.func	= func;
		self.spr	= spr;
		self.hotkey = hotkey;
		self.toggle = toggle;
		color = c_white;
	
		isShelf = false;
	
		static setIsShelf = function() {
			isShelf = true;
			return self;
		}
	
		static setActive = function(active) {
			self.active = active;
			return self;
		}
	
		static setColor = function(color) {
			self.color = color;
			return self;
		}
	
		static deactivate = function() {
			active = false;
			return self;
		}
	}

	function menuItemGroup(name, group) {
		return new MenuItemGroup(name, group);
	}
	function MenuItemGroup(name, group) constructor {
		active = true;
		self.name	= name;
		self.group  = group;
	}
#endregion