extends Resource

class_name GameUtility

func GetSkillById(id : int):
	for item in GameData.skills:
		if item.id == id:
			return item;
	
	return null;
