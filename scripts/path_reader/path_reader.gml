function path_search(paths, recur = false, _filter = "") {
	var _paths = [];
	for( var i = 0, n = array_length(paths); i < n; i++ )
		array_append(_paths, paths_to_array(paths[i], recur, _filter));
	return _paths;
}

function paths_to_array(paths, recur = false, _filter = "") {
	paths = string_trim_end(paths, ["/", "\\"]);
	
	var _paths = [];
	var in     = 0;
	var regx   = new regex_tree(_filter);
	
	if(directory_exists(paths)) {
		var st = ds_stack_create();
		ds_stack_push(st, paths);
		
		while(!ds_stack_empty(st)) {
			var curr_path = ds_stack_pop(st);
			
			var file = file_find_first(curr_path + "/*", fa_directory);
			while(file != "") {
				var file_full = curr_path + "/" + file;
				if(directory_exists(file_full) && recur) {
					ds_stack_push(st, file_full);
				} else if(path_is_image(file_full) && regx.isMatch(file_full)) {
					array_push(_paths, file_full);
				}
			
				file = file_find_next();
			}
			file_find_close();
		}
		
		ds_stack_destroy(st);
	} else if(file_exists_empty(paths) && regx.isMatch(paths))
		array_push(_paths, paths);
	
	return _paths;
}

function path_is_image(path) {
	if(!file_exists_empty(path)) return false;	
	
	var ext = filename_ext(path);
	switch(ext) {
		case ".png":
		case ".jpg":
		case ".jpeg":
		case ".gif":
			return true;
	}
	return false;
}

function paths_to_array_ext(paths, _extension = "") {
	paths      = string_trim_end(paths, ["/", "\\"]);
	var _ext   = string_splice(_extension, ";", false, false);
	var _paths = [];
	
	if(!directory_exists(paths)) return [];
	
	var st = ds_stack_create();
	ds_stack_push(st, paths);
	
	while(!ds_stack_empty(st)) {
		var curr_path = ds_stack_pop(st);
		var file = file_find_first(curr_path + "/*", fa_none);
		
		while(file != "") {
			var file_full = curr_path + "/" + file;
			
			if(directory_exists(file_full))
				ds_stack_push(st, file_full);
				
			else if(array_exists(_ext, filename_ext(file)))
				array_push(_paths, file_full);
		
			file = file_find_next();
		}
		file_find_close();
	}
	
	ds_stack_destroy(st);
	
	return _paths;
}