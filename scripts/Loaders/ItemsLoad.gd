extends Resource

class_name ItemsLoad

func __invoke():
	var file = File.new();
	file.open("res://data/items.json", file.READ);
	
	var json_text = file.get_as_text()
	var json = JSON.parse(json_text);
	
	file.close();
	
	return json.result;
