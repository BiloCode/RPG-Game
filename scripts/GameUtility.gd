extends Resource

class_name GameUtility

func GetSkillById(id : int):
	for item in GameData.skills:
		if item.id == id:
			return item;
	
	return null;

func GetStateById(id : int):
	for state in GameData.states:
		if state.id == id:
			return state;
			
	return null;
