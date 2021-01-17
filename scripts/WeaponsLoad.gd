extends Resource

class_name WeaponsLoad

func __invoke():
	var file = File.new();
	file.open("res://data/weapons.json", file.READ);
	
	var json_text = file.get_as_text();
	var json = JSON.parse(json_text);
	
	file.close();
	
	return json.result;
