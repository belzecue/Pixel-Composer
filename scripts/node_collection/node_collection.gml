enum COLLECTION_TAG {
	group = 1,
	loop = 2
}

function groupNodes(nodeArray, _group = noone, record = true, check_connect = true) {
	UNDO_HOLDING = true;
	
	if(_group == noone) {
		var cx = 0;
		var cy = 0;
		for(var i = 0; i < array_length(nodeArray); i++) {
			var _node = nodeArray[i];
			cx += _node.x;
			cy += _node.y;
		}
		cx = round(cx / array_length(nodeArray) / 32) * 32;
		cy = round(cy / array_length(nodeArray) / 32) * 32;
		
		_group = new Node_Group(cx, cy, PANEL_GRAPH.getCurrentContext());
	}
	
	var _content = [];
		
	for(var i = 0; i < array_length(nodeArray); i++) {
		_group.add(nodeArray[i]);
		_content[i] = nodeArray[i];
	}
		
	var _io = [];
	if(check_connect) 
	for(var i = 0; i < array_length(nodeArray); i++)
		array_append(_io, nodeArray[i].checkConnectGroup());
			
	UNDO_HOLDING = false;	
	if(record) recordAction(ACTION_TYPE.group, _group, { io: _io, content: _content });
	
	return _group;
}

function upgroupNode(collection, record = true) {
	UNDO_HOLDING = true;
	var _content = [];
	var _io = [];
	var node_list = collection.getNodeList();
	while(!ds_list_empty(node_list)) {
		var remNode = node_list[| 0];
		if(remNode.destroy_when_upgroup)	
			array_push(_io, remNode);
		else 
			array_push(_content, remNode);
		
		collection.remove(remNode); 
	}
	
	nodeDelete(collection);
	UNDO_HOLDING = false;
	
	if(record) recordAction(ACTION_TYPE.ungroup, collection, { io: _io, content: _content });
}

function Node_Collection(_x, _y, _group = noone) : Node(_x, _y, _group) constructor {
	nodes = ds_list_create();
	ungroupable = true;
	auto_render_time = false;
	combine_render_time = true;
	
	isInstancer  = false;
	instanceBase = noone;
	
	custom_input_index = 0;
	custom_output_index = 0;
	
	metadata = new MetaDataManager();
	
	static getNodeBase = function() {
		if(instanceBase == noone) return self;
		return instanceBase.getNodeBase();
	}
	
	static getNodeList = function() {
		if(instanceBase == noone) return nodes;
		return instanceBase.getNodeList();
	}
	
	static drawOverlay = function(active, _x, _y, _s, _mx, _my, _snx, _sny) {
		for(var i = custom_input_index; i < ds_list_size(inputs); i++) {
			var _in = inputs[| i];
			var _show = _in.from.inputs[| 6].getValue();
			
			if(!_show) continue;
			_in.drawOverlay(active, _x, _y, _s, _mx, _my, _snx, _sny);
		}
	}
	
	static getNextNodes = function() {
		for(var i = custom_input_index; i < ds_list_size(inputs); i++) {
			var _in = inputs[| i].from;
			if(!_in.renderActive) continue;
			
			ds_queue_enqueue(RENDER_QUEUE, _in);
			printIf(global.RENDER_LOG, "Push group input " + _in.name + " to stack");
		}
	}
	
	static setRenderStatus = function(result) {
		rendered = result;
		
		if(result) {
			var siz = ds_list_size(outputs);
			for( var i = custom_output_index; i < siz; i++ ) {
				var _o = outputs[| i];
				if(_o.node.rendered) continue;
				
				rendered = false;
				break;
			}
		}
			
		if(!result && group != noone) 
			group.setRenderStatus(result);
	}
	
	function add(_node) {
		ds_list_add(getNodeList(), _node);
		var list = _node.group == noone? PANEL_GRAPH.nodes_list : _node.group.getNodeList();
		var _pos = ds_list_find_index(list, _node);
		ds_list_delete(list, _pos);
		
		recordAction(ACTION_TYPE.group_added, self, _node);
		_node.group = self;
	}
	
	function remove(_node) {
		var node_list = getNodeList();
		var _pos = ds_list_find_index(node_list, _node);
		ds_list_delete(node_list, _pos);
		var list = group == noone? PANEL_GRAPH.nodes_list : group.getNodeList();
		ds_list_add(list, _node);
		
		recordAction(ACTION_TYPE.group_removed, self, _node);
		
		if(struct_has(_node, "ungroup"))
			_node.ungroup();
			
		if(_node.destroy_when_upgroup) 
			nodeDelete(_node);
		else
			_node.group = group;
	}
	
	static clearCache = function() {
		var node_list = getNodeList();
		for(var i = 0; i < ds_list_size(node_list); i++) {
			node_list[| i].clearCache();
		}
	}
	
	static inspectorGroupUpdate = function() {
		var node_list = getNodeList();
		for(var i = 0; i < ds_list_size(node_list); i++) {
			var _node = node_list[| i];
			if(_node.hasInspectorUpdate() == noone)
				_node.inspectorUpdate();
		}
	}
	
	static stepBegin = function() {
		use_cache = false;
		inspectorUpdate = noone;
		
		array_safe_set(cache_result, ANIMATOR.current_frame, true);
		
		var node_list = getNodeList();
		for(var i = 0; i < ds_list_size(node_list); i++) {
			var n = node_list[| i];
			n.stepBegin();
			if(n.hasInspectorUpdate())
				inspectorUpdate = inspectorGroupUpdate;
			if(!n.use_cache) continue;
			
			use_cache = true;
			if(!array_safe_get(n.cache_result, ANIMATOR.current_frame))
				array_safe_set(cache_result, ANIMATOR.current_frame, false);
		}
		
		var out_surf = false;
		
		for( var i = 0; i < ds_list_size(outputs); i++) {
			if(outputs[| i].type == VALUE_TYPE.surface) 
				out_surf = true;
		}
		
		if(out_surf) {
			w = 128;
			min_h = 128;
		} else {
			w = 96;
			
		}
		
		setHeight();
		doStepBegin();
	}
	
	static step = function() {
		if(combine_render_time) render_time = 0;
		
		var node_list = getNodeList();
		for(var i = 0; i < ds_list_size(node_list); i++) {
			node_list[| i].step();
			if(combine_render_time) 
				render_time += node_list[| i].render_time;
		}
		
		if(PANEL_GRAPH.node_focus == self && panelFocus(PANEL_GRAPH) && DOUBLE_CLICK) {
			PANEL_GRAPH.addContext(self);
			DOUBLE_CLICK = false;
		}
		
		onStep();
	}
	
	static onStep = function() {}
	
	static triggerRender = function() {
		for(var i = custom_input_index; i < ds_list_size(inputs); i++) {
			var jun_node = inputs[| i].from;
			jun_node.triggerRender();
		}
	}
	
	static preConnect = function() {
		sortIO();
		deserialize(load_map, load_scale);
	}
	
	static sortIO = function() {
		var siz = ds_list_size(inputs);
		var ar = ds_priority_create();
		
		for( var i = custom_input_index; i < siz; i++ ) {
			var _in = inputs[| i];
			var _or = _in.from.inputs[| 5].getValue();
			
			ds_priority_add(ar, _in, _or);
		}
		
		for( var i = siz - 1; i >= custom_input_index; i-- ) {
			ds_list_delete(inputs, i);
		}
		
		for( var i = custom_input_index; i < siz; i++ ) {
			var _jin = ds_priority_delete_min(ar);
			_jin.index = i;
			ds_list_add(inputs, _jin);
		}
		
		ds_priority_destroy(ar);
		
		var siz = ds_list_size(outputs);
		var ar = ds_priority_create();
		
		for( var i = custom_output_index; i < siz; i++ ) {
			var _out = outputs[| i];
			var _or = _out.from.inputs[| 1].getValue();
			
			ds_priority_add(ar, _out, _or);
		}
		
		for( var i = siz - 1; i >= custom_output_index; i-- ) {
			ds_list_delete(outputs, i);
		}
		
		for( var i = custom_output_index; i < siz; i++ ) {
			var _jout = ds_priority_delete_min(ar);
			_jout.index = i;
			ds_list_add(outputs, _jout);
		}
		
		ds_priority_destroy(ar);
	}
	
	static onClone = function(_newNode, target = PANEL_GRAPH.getCurrentContext()) {
		if(instanceBase != noone) {
			_newNode.instanceBase = instanceBase;
			return;
		}
		
		var dups = ds_list_create();
		
		for(var i = 0; i < ds_list_size(nodes); i++) {
			var _node = nodes[| i];
			var _cnode = _node.clone(target);
			ds_list_add(dups, _cnode);
			
			APPEND_MAP[? _node.node_id] = _cnode.node_id;
		}
		
		APPENDING = true;
		for(var i = 0; i < ds_list_size(dups); i++) {
			var _node = dups[| i];
			_node.connect();
		}
		APPENDING = false;
		
		ds_list_destroy(dups);
	}
	
	static enable = function() { 
		active = true;
		var node_list = getNodeList();
		for( var i = 0; i < ds_list_size(node_list); i++ )
			node_list[| i].enable();
	}
	
	static disable = function() {
		active = false;
		var node_list = getNodeList();
		for( var i = 0; i < ds_list_size(node_list); i++ )
			node_list[| i].disable();
	}
	
	static resetAllRenderStatus = function() {
		var node_list = getNodeList();
		for( var i = 0; i < ds_list_size(node_list); i++ ) {
			node_list[| i].setRenderStatus(false);
			if(variable_struct_exists(node_list[| i], "nodes"))
				node_list[| i].resetAllRenderStatus();
		}
	}
	
	static setInstance = function(node) {
		instanceBase = node;
	}
	
	static resetInstance = function() {
		instanceBase = noone;
	}
	
	static processSerialize = function(_map) {
		_map[? "instance_base"]	= instanceBase? instanceBase.node_id : noone;
	}
	
	static preConnect = function() {
		instanceBase = GetAppendID(ds_map_try_get(load_map, "instance_base", noone));
		
		sortIO();
		applyDeserialize();
	}
}