extends Node2D;

var PlayerBattle = preload("res://models/characters/PlayerBattle/PlayerBattle.tscn");
var EnemyBattle = preload("res://models/characters/EnemyBattle/EnemyBattle.tscn");
var TextBox = preload("res://models/gui/TextBox/TextBox.tscn");

var battle_state;
var player;
var enemy;

var current_index = 0;
var entity_list = [];
var player_controls_active = false;
var entity_is_perform_action = false;
var text_box_exists = false;

signal onBattleEnd;

func _init():
	player = PlayerBattle.instance();
	enemy = EnemyBattle.instance();
	
	player.connect("onBattleEntityStartAction", self, "_on_battle_entity_start_action");
	player.connect("onBattleEntityEndAction", self, "_on_battle_entity_end_action");
	player.connect("onSelectAction", self, "_on_player_select_action");
	player.connect("onRunBattle", self, "_on_entity_run_battle");
	enemy.connect("onBattleEntityStartAction", self, "_on_battle_entity_start_action");
	enemy.connect("onBattleEntityEndAction", self, "_on_battle_entity_end_action");
	
	player.data = BattleEntity.new("player_test", 30,8,10,15);
	enemy.data = BattleEntity.new("enemy_test", 30,5,5,5);
	
	add_child(player);
	add_child(enemy);

func _ready():
	battle_state = Types.state_battle.LIFE_CHECK;
	player.transform = $PlayerPosition.transform;
	enemy.transform = $EnemyPosition.transform;

func _process(delta):
	if text_box_exists or player_controls_active or entity_is_perform_action:
		return;
	
	match battle_state:
		Types.state_battle.LIFE_CHECK:
			var playerIsLive = PlayerIsLive.new();
			var battleLifeCheck = BPLifeCheck.new(playerIsLive);
			battle_state = battleLifeCheck.__invoke(player, enemy);

		Types.state_battle.CONTROLS:
			player.call("controlsActivate", enemy);
			enemy.call("targetSelection", player);
			player_controls_active = true;
			
		Types.state_battle.SPEED_CHECK:
			var ranNumber = RandomNumberGenerator.new();
			var speedCheck = BPSpeedCheck.new(ranNumber);
			entity_list = speedCheck.__invoke(player, enemy);
			battle_state = Types.state_battle.PERFORM_ACTIONS;
			
		Types.state_battle.PERFORM_ACTIONS:
			var performActions = BPPerformActions.new();
			var is_finish = performActions.__invoke(entity_list, current_index);
			if is_finish:
				battle_state = Types.state_battle.TURN_END;
				
		Types.state_battle.TURN_END:
			entity_list = [];
			current_index = 0;
			player.is_perform_action = false;
			enemy.is_perform_action = false;
			battle_state = Types.state_battle.LIFE_CHECK;
			
		Types.state_battle.WIN_BATTLE:
			var text_box = create_text_box([
				"Has ganado el combate",
				"Has ganado 35 de exp y 25 de oro"
			]);
			
			yield(text_box, "onTextBoxDestroy");
			emit_signal("onBattleEnd");
			queue_free();
			
		Types.state_battle.LOSE_BATTLE:
			print("Lose");

#Utils
func create_text_box(message : Array):
	var text_box = TextBox.instance();
	text_box.message = message;
	add_child(text_box);
	text_box_exists = true;
	
	return text_box;

#Signals Functions

func _on_battle_entity_start_action():
	entity_is_perform_action = true;

func _on_battle_entity_end_action():
	current_index += 1;
	entity_is_perform_action = false;

func _on_player_select_action():
	battle_state = Types.state_battle.SPEED_CHECK;
	player_controls_active = false;

func _on_entity_run_battle(self_entity):
	var text_box = create_text_box([ 
		self_entity.data.name + " ha escapado del combate." 
	]);
	
	yield(text_box, "onTextBoxDestroy");
	emit_signal("onBattleEnd");
	queue_free();
