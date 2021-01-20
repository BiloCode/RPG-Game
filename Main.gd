extends Node2D

var MovablePlayer = preload("res://models/characters/MovablePlayer/MovablePlayer.tscn");
var Overworld = preload("res://levels/Overworld/Overworld.tscn");
var FadeEffect = preload("res://models/gui/FadeEffect/FadeEffect.tscn");
var battle_scene = preload("res://levels/Battle/Battle.tscn");

func _ready():
	var player = MovablePlayer.instance();
	var initial_map = Overworld.instance();
	
	player.position = initial_map.get_node("InitialPosition").position;
	
	$World.add_child(initial_map);
	$World.add_child(player);

# Test...
func _on_start_battle():
	var fade = FadeEffect.instance();
	add_child(fade);
	
	yield(fade, "onFadeInEnd");
	
	var battle = battle_scene.instance();
	battle.connect("onBattleEnd", self, "_on_end_battle");
	add_child(battle);
