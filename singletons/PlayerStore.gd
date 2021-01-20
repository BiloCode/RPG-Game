extends Node

var player_name = "Bilo";

var gold = 0;
var exp_gained = 0;
var exp_accumulated = 0;
var position = Vector2();

var skills = [ 0,1,2,3 ];
var inventory = [
	{
		"id" : 1,
		"type" : "item",
		"name" : "hierba medicinal",
		"amount" : 15,
		"effect" : {
			"type" : "state"
		}
	},
	{
		"id" : 0,
		"type" : "item",
		"name" : "manzana",
		"amount" : 99,
		"effect" : {
			"type" : "life",
			"amount" : 10
		}
	}
];

var stats = {
	"life" : 40,
	"atack" : 10,
	"defense" : 10,
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

func getObjects():
	var objects = [];
	for item in PlayerStore.inventory:
		if item.type == "item":
			objects.append(item);
	
	return objects;

func getObjectById(id : int):
	var object = null;
	for item in getObjects():
		if item.id == id:
			object = item;
			break;
	
	return object;
