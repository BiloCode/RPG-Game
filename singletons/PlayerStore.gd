extends Node

var player_name = "Luxvir";

var gold = 0;
var position = Vector2();

var skills = [0,1,3];
var inventory = [
	{
		"id" : 1,
		"type" : "item",
		"name" : "hierba medicinal",
		"amount" : 1,
		"effect" : {
			"type" : "state"
		}
	},
	{
		"id" : 0,
		"type" : "item",
		"name" : "manzana",
		"amount" : 1,
		"effect" : {
			"type" : "life",
			"amount" : 10
		}
	}
];

var stats_points = 0;
var stats = {
	"life" : 40,
	"atack" : 10,
	"defense" : 3,
	"speed" : 9
}

var equipment = {
	"hands" : "",
	"helmet" : "",
	"chestplate" : ""
}

func loadGame():
	pass

func saveGame():
	pass
	
func getSkills():
	var skills = [];
	for skill_id in PlayerStore.skills:
		for skill in GameData.skills:
			if skill_id == skill.id:
				skills.append(skill);
				break;
		
	return skills;

func getObjects():
	var objects = [];
	for item in PlayerStore.inventory:
		if item.type == "item":
			objects.append(item);
	
	return objects;

func getObjectById(id : int):
	for item in getObjects():
		if item.id == id:
			return item;
	
	return null;
	
func removeAmountItemUsed(id: int, amount: int):
	var object_store = PlayerStore.getObjectById(id);
	object_store.amount -= amount;
	
	if object_store.amount <= 0:
		var new_inventory = [];
		for item in getObjects():
			if item.id != object_store.id:
				new_inventory.append(item);
		
		inventory = new_inventory;
