function __initAddon() { 
	var dirPath = DIRECTORY + "Addons";
	globalvar ADDONS, ADDONS_ON_START;
	ADDONS = [];
	ADDONS_ON_START = [];
	
	if(!directory_exists(dirPath)) {
		directory_create(dirPath);
		return;
	}
	
	var f = file_find_first(dirPath + "\\*", fa_directory);
	var _f = "";
	
	while(f != "" && f != _f) {
		_f = f;
		var _path = dirPath + "\\" + f;
		var _meta = _path + "\\meta.json";
		
		if(!file_exists(_meta)) {
			f = file_find_next();
			continue;
		}
		
		var _mSrt = json_load_struct(_meta);
		var _str = {
			name: f,
			path: _path,
			meta: _mSrt.meta,
			
			open: false
		};
		
		array_push(ADDONS, _str);	
		f = file_find_next();
	}
	
	file_find_close();
}

function loadAddon() {
	var _path = DIRECTORY + "Addons\\__init.json";
	if(!file_exists(_path)) return;
	
	ADDONS_ON_START = json_load_struct(_path);
	for( var i = 0; i < array_length(ADDONS_ON_START); i++ ) 
		addonTrigger(ADDONS_ON_START[i], false);
}