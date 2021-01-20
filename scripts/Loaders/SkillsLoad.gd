extends Resource

class_name SkillsLoad

func __invoke():
	var file = File.new();
	file.open("res://data/skills.json", file.READ);
	
	var json_text = file.get_as_text();
	var json = JSON.parse(json_text);
	
	file.close();
	
	return json.result;
