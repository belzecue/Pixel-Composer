function Node_Armature(_x, _y, _group = noone) : Node(_x, _y, _group) constructor {
	name = "Armature Create";
	
	//inputs[| 0] = nodeValue("Axis", self, JUNCTION_CONNECT.input, VALUE_TYPE.integer, 0);
	
	bone_renderer = new Inspector_Custom_Renderer(function(_x, _y, _w, _m, _hover, _focus) {
		var _b  = attributes.bones;
		var amo = _b.childCount();
		var _h  = ui(32 + 16) + amo * ui(28);
		var __y = _y;
		
		draw_set_text(f_p0, fa_left, fa_top, COLORS._main_text);
		draw_text_add(_x + ui(16), _y + ui(4), "Bones");
		
		_y += ui(32);
		
		draw_sprite_stretched_ext(THEME.ui_panel_bg, 1, _x, _y, _w, _h - ui(32), COLORS.node_composite_bg_blend, 1);
		draw_set_color(COLORS.node_composite_separator);
		draw_line(_x + 16, _y + ui(8), _x + _w - 16, _y + ui(8));
		
		_y += ui(8);
		
		for( var i = 0; i < array_length(_b.childs); i++ ) {
			_y = _b.childs[i].drawInspector(_x + ui(8), _y, _w - ui(16), _m, _hover, _focus);
		}
		
		return _h;
	})
	
	input_display_list = [
		bone_renderer,
	];
	
	input_fix_len = ds_list_size(inputs);
	data_length = 1;
	
	static createBone = function(parent, distance, direction) {
		var bone  = new __Bone(parent, distance, direction,,, attributes);
		parent.addChild(bone);
		
		if(parent == attributes.bones) 
			bone.parent_anchor = false;
		return bone;
	}
	
	outputs[| 0] = nodeValue("Armature", self, JUNCTION_CONNECT.output, VALUE_TYPE.armature, noone);
	
	attributes.bones = new __Bone(,,,,, attributes);
	attributes.bones.name = "Main";
	attributes.bones.is_main = true;
	bone_update = false;
	
	attributes.display_name = true;
	array_push(attributeEditors, ["Display name", "display_name", 
		new checkBox(function() { 
			attributes.display_name = !attributes.display_name;
		})]);
	
	tools = [
		new NodeTool( "Transform", THEME.bone_tool_transform ),
		new NodeTool( "Add bones", THEME.bone_tool_add ),
		new NodeTool( "Remove bones", THEME.bone_tool_remove ),
		new NodeTool( "Detach bones", THEME.bone_tool_detach ),
	];
	
	anchor_selecting = noone;
	builder_bone = noone;
	builder_type = 0;
	builder_sx = 0;
	builder_sy = 0;
	builder_mx = 0;
	builder_my = 0;
	
	moving = false;
	scaling = false;
	
	static drawOverlay = function(active, _x, _y, _s, _mx, _my, _snx, _sny) {
		var mx = (_mx - _x) / _s;
		var my = (_my - _y) / _s;
		
		var _b =  attributes.bones;
		
		if(isUsingTool(0)) { //transform
			attributes.bones.draw(active, _x, _y, _s, _mx, _my);
			
			var _bst = ds_stack_create();
			ds_stack_push(_bst, _b);
			
			var minx =  999999;
			var miny =  999999;
			var maxx = -999999;
			var maxy = -999999;
			
			while(!ds_stack_empty(_bst)) {
				var __b = ds_stack_pop(_bst);
				
				if(!__b.is_main) {
					var p0 = __b.getPoint(0, 0);
					var p1 = __b.getPoint(__b.length, __b.angle);
					
					minx = min(minx, p0.x);
					miny = min(miny, p0.y);
					maxx = max(maxx, p0.x);
					maxy = max(maxy, p0.y);
					
					minx = min(minx, p1.x);
					miny = min(miny, p1.y);
					maxx = max(maxx, p1.x);
					maxy = max(maxy, p1.y);
				}
				
				for( var i = 0; i < array_length(__b.childs); i++ )
					ds_stack_push(_bst, __b.childs[i]);
			}
		
			ds_stack_destroy(_bst);
			
			
			var hvSc = false;
			var hvMv = false;
			
			if(moving) {
				var dx = mx - builder_mx;
				var dy = my - builder_my;
				
				builder_mx = mx;
				builder_my = my;
				
				for( var i = 0; i < array_length(_b.childs); i++ ) {
					var bone = _b.childs[i];
					
					var _bx = lengthdir_x(bone.distance, bone.direction) + dx;
					var _by = lengthdir_y(bone.distance, bone.direction) + dy;
					
					bone.distance  = point_distance(0, 0, _bx, _by);
					bone.direction = point_direction(0, 0, _bx, _by);
				}
				
				if(mouse_release(mb_left))
					moving = false;
			} else if(scaling) {
				var dir = point_direction(minx, miny, maxx, maxy);
				var ss  = 1 + dot_product(lengthdir_x(1, dir), lengthdir_y(1, dir), mx - builder_mx, my - builder_my);
				
				var _bst = ds_stack_create();
				ds_stack_push(_bst, _b);
			
				while(!ds_stack_empty(_bst)) {
					var __b = ds_stack_pop(_bst);
				
					if(!__b.is_main) {
						__b.distance = __b.freeze_data.distance * ss;
						__b.length   = __b.freeze_data.length * ss;
					}
				
					for( var i = 0; i < array_length(__b.childs); i++ )
						ds_stack_push(_bst, __b.childs[i]);
				}
		
				ds_stack_destroy(_bst);
				
				if(mouse_release(mb_left))
					scaling = false;
			} else {
				if(point_in_circle(_mx, _my, maxx, maxy, 16)) {
					hvSc = true;
					
					if(mouse_press(mb_left)) {
						attributes.bones.freeze();
						
						builder_mx = mx;
						builder_my = my;
						scaling = true;
					}
				} else if(point_in_circle(_mx, _my, maxx, maxy, 16)) {
					hvMv = true;
					
					if(mouse_press(mb_left)) {
						builder_mx = mx;
						builder_my = my;
						moving = true;
					}
				}
			}
			
			draw_sprite_colored(THEME.anchor_scale, hvSc, maxx, maxy);
			
			draw_set_color(COLORS._main_accent);
			draw_rectangle_border(minx, miny, maxx, maxy, hvMv);
			return;
		}
		
		anchor_selecting = attributes.bones.draw(active, _x, _y, _s, _mx, _my, true, anchor_selecting);
		//if(is_array(anchor_selecting)) print(anchor_selecting[1])
		
		if(builder_bone != noone) {
			//draw_set_color(COLORS._main_accent);
			//draw_circle(_x + builder_sx * _s, _y + builder_sy * _s, 8, false);
		
			var dir = point_direction(builder_sx, builder_sy, mx, my);
			var dis = point_distance(builder_sx, builder_sy, mx, my);
			
			if(builder_type == 2) {
				var bx = builder_sx + (mx - builder_mx) / _s;
				var by = builder_sy + (my - builder_my) / _s;
				
				if(!builder_bone.parent_anchor) {
					builder_bone.direction = point_direction(0, 0, bx, by);
					builder_bone.distance  = point_distance( 0, 0, bx, by);
				}
			} else if(key_mod_press(ALT)) {
				if(builder_type == 0) {
					var bo = builder_bone.getPoint(builder_bone.length, builder_bone.angle);
					
					builder_bone.direction = dir;
					builder_bone.distance  = dis;
					
					var bn = builder_bone.getPoint(0, 0);
					
					builder_bone.angle  = point_direction(bn.x, bn.y, bo.x, bo.y);
					builder_bone.length = point_distance( bn.x, bn.y, bo.x, bo.y);
				} else if(builder_type == 1) {
					var chs = [];
					for( var i = 0; i < array_length(builder_bone.childs); i++ ) {
						var ch = builder_bone.childs[i];
						chs[i] = ch.getPoint(ch.length, ch.angle);
					}
				
					builder_bone.angle  = dir;
					builder_bone.length = dis;
					
					for( var i = 0; i < array_length(builder_bone.childs); i++ ) {
						var ch = builder_bone.childs[i];
						var c0 = ch.getPoint(0, 0);
					
						ch.angle  = point_direction(c0.x, c0.y, chs[i].x, chs[i].y);
						ch.length = point_distance( c0.x, c0.y, chs[i].x, chs[i].y);
					}
				}
			} else {
				if(builder_type == 0) {
					builder_bone.direction = dir;
					builder_bone.distance  = dis;
				} else if(builder_type == 1) {
					builder_bone.angle  = dir;
					builder_bone.length = dis;
				}
			}
			
			if(mouse_release(mb_left)) {
				builder_bone = noone;
				UNDO_HOLDING = false;
			}
		}
			
		if(isUsingTool(1)) { // builder
			if(mouse_press(mb_left, active)) {
				if(anchor_selecting == noone) {
					builder_bone = createBone(attributes.bones, point_distance(0, 0, mx, my), point_direction(0, 0, mx, my));
					builder_type = 1;
					builder_sx = mx;
					builder_sy = my;
					UNDO_HOLDING = true;
				} else if(anchor_selecting[1] == 1) {
					builder_bone = createBone(anchor_selecting[0], 0, 0);
					builder_type = 1;
					builder_sx = mx;
					builder_sy = my;
					UNDO_HOLDING = true;
				} else if(anchor_selecting[1] == 2) {
					var _pr = anchor_selecting[0];
					var _md = new __Bone(noone, 0, 0, _pr.angle, _pr.length / 2, attributes);
					_pr.length = _md.length;
					
					for( var i = 0; i < array_length(_pr.childs); i++ )
						_md.addChild(_pr.childs[i]);
					
					_pr.childs = [];
					_pr.addChild(_md);
					
					bone_update = true;
					UNDO_HOLDING = true;
				}
			}
		} else if(isUsingTool(2)) { //remover
			if(anchor_selecting != noone && anchor_selecting[0].parent != noone && mouse_press(mb_left, active)) {
				var _bone = anchor_selecting[0];
				var _par  = _bone.parent;
				
				if(anchor_selecting[1] == 2) {
					array_remove(_par.childs, _bone);
				
					for( var i = 0; i < array_length(_bone.childs); i++ ) {
						var _ch = _bone.childs[i];
						_par.addChild(_ch);
					}
					
					bone_update = true;
				}
			}
		} else if(isUsingTool(2)) { //detach
			if(anchor_selecting != noone && anchor_selecting[0].parent_anchor && anchor_selecting[1] == 2 && mouse_press(mb_left, active)) {
				builder_bone = anchor_selecting[0];
				builder_type = anchor_selecting[1];
				
				var par = builder_bone.parent;
				builder_bone.parent_anchor = false;
				builder_bone.distance  = par.length;
				builder_bone.direction = par.angle;
				
				builder_sx = lengthdir_x(par.length, par.angle);
				builder_sy = lengthdir_y(par.length, par.angle);
				builder_mx = mx;
				builder_my = my;
				UNDO_HOLDING = true;
			}
		} else if(isUsingTool(3) || isNotUsingTool()) { //mover
			if(anchor_selecting != noone && mouse_press(mb_left, active)) {
				builder_bone = anchor_selecting[0];
				builder_type = anchor_selecting[1];
				
				if(builder_type == 0) {
					var orig = builder_bone.parent.getPoint(0, 0);
					builder_sx = orig.x;
					builder_sy = orig.y;
				} else if(builder_type == 1) {
					var orig = builder_bone.getPoint(0, 0);
					builder_sx = orig.x;
					builder_sy = orig.y;
				} else if(builder_type == 2) {
					if(builder_bone.parent_anchor) {
						builder_bone = noone;
					} else {
						var par = builder_bone.parent;
						builder_sx = lengthdir_x(builder_bone.distance, builder_bone.direction);
						builder_sy = lengthdir_y(builder_bone.distance, builder_bone.direction);
						builder_mx = mx;
						builder_my = my;
					}
				}
				
				UNDO_HOLDING = true;
			}
		}
	}
	
	static step = function() {
		
	}
	
	static update = function(frame = ANIMATOR.current_frame) {
		outputs[| 0].setValue(attributes.bones);
	}
	
	static doSerialize = function(_map) {
		_map.bones = attributes.bones.serialize();
	}
	
	static postDeserialize = function() {
		if(!struct_has(load_map, "bones")) return;
		attributes.bones = new __Bone(,,,,, attributes);
		attributes.bones.deserialize(load_map.bones, attributes);
	}
}

