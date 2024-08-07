function nodeValue_Quaternion(_name, _node, _value, _tooltip = "") { return new NodeValue_Quaternion(_name, _node, _value, _tooltip); }

function NodeValue_Quaternion(_name, _node, _value, _tooltip = "") : NodeValue_Array(_name, _node, _value, _tooltip, 4) constructor {
	setDisplay(VALUE_DISPLAY.d3quarternion);
	
	/////============== GET =============
	
	static getValue = function(_time = CURRENT_FRAME, applyUnit = true, arrIndex = 0, useCache = false, log = false) { //// Get value
		getValueRecursive(self.__curr_get_val, _time);
		var val = __curr_get_val[0];
		var nod = __curr_get_val[1];
		
		var typ = nod == undefined? VALUE_TYPE.any : nod.type;
		var dis = nod.display_type;
		
		if(applyUnit && display_data.angle_display == QUARTERNION_DISPLAY.euler)
			return quarternionFromEuler(val[0], val[1], val[2]);
		return val;
	}
}