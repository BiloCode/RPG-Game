extends Node2D;

var PlayerBattle = preload("res://models/characters/PlayerBattle/PlayerBattle.tscn");
var EnemyBattle = preload("res://models/characters/EnemyBattle/EnemyBattle.tscn");
var FadeEffect = preload("res://models/gui/FadeEffect/FadeEffect.tscn");

# Battle Params
var battle_zone = Types.battle_zones.PLAINS;

# Enemies Group
var enemy_list_on_battle = [];
var enemy_list_current = 0;
var next_battler = false;

# Battlers
var player;
var enemy;

# Process Battle
var battle_state;
var current_list_battlers = [];
var current_battler_action = 0;

# Entity Actions
var player_controls_active = false;
var entity_is_perform_action = false;

# Signals
signal onBattleEnd;

func _ready():
	enemy_list_on_battle = generateRandomEnemies();
	enemy = EnemyBattle.instance();
	player = PlayerBattle.instance();
	
	setPlayerDataForBattle();
	setEnemyDataForBattle();
	
	enemyNodeInit();
	playerNodeInit();

	add_child(enemy);
	add_child(player);

	battle_state = Types.state_battle.LIFE_CHECK;
	player.transform = $PlayerPosition.transform;
	enemy.transform = $EnemyPosition.transform;
	
func _process(delta):
	if player_controls_active or entity_is_perform_action:
		return;

	match battle_state:
		Types.state_battle.LIFE_CHECK:
			var playerIsLive = PlayerIsLive.new();
			var battleLifeCheck = BPLifeCheck.new(playerIsLive);
			battle_state = battleLifeCheck.__invoke(player, enemy);
			
		Types.state_battle.NEXT_ENEMY:
			if enemy_list_current < enemy_list_on_battle.size() - 1:
				next_battler = true;
				enemy_list_current += 1;
				setEnemyDataForBattle();
				battle_state = Types.state_battle.CONTROLS;
				return;
				
			battle_state = Types.state_battle.WIN_BATTLE;

		Types.state_battle.CONTROLS:
			player.call("create_controls", enemy);
			enemy.call("target_selection", player);
			player_controls_active = true;
			
		Types.state_battle.SPEED_CHECK:
			var speedCheck = BPSpeedCheck.new(GameData.Random);
			current_list_battlers = speedCheck.__invoke(player, enemy);
			battle_state = Types.state_battle.PERFORM_ACTIONS;
			
		Types.state_battle.PERFORM_ACTIONS:
			var performActions = BPPerformActions.new();
			var is_finish = performActions.__invoke(current_list_battlers, current_battler_action);
			if is_finish:
				battle_state = Types.state_battle.TURN_END;
				
		Types.state_battle.TURN_END:
			current_list_battlers = [];
			current_battler_action = 0;
			enemy.normalize_data();
			player.normalize_data();
			battle_state = Types.state_battle.LIFE_CHECK;
			
		Types.state_battle.WIN_BATTLE:
			print("win");
			#emit_signal("onBattleEnd");
			#queue_free();
			
		Types.state_battle.LOSE_BATTLE:
			print("Lose");

# Players Set Data
func setPlayerDataForBattle():
	player.data = BattlerData.new(
		PlayerStore.player_name, 
		PlayerStore.stats.life,
		PlayerStore.stats.atack,
		PlayerStore.stats.defense,
		PlayerStore.stats.speed
	);
	
	$BattleLifeBarPlayer.call("LifeInit", player.data.name,
											player.data.life.current_value,
											player.data.life.max_value);

func setEnemyDataForBattle():
	var current_enemy = enemy_list_on_battle[enemy_list_current];
	if(next_battler):
		var enemy_animation : AnimationPlayer = enemy.get_node("Animation");
		enemy_animation.play("NextBattler");
		next_battler = false;
		
	enemy.data = current_enemy.data;
	enemy.sprite = current_enemy.sprite;
	enemy.gold = current_enemy.gold;
	enemy.weapons = current_enemy.weapons;
	enemy.items = current_enemy.items;
	
	$BattleLifeBarEnemy.call("LifeInit", enemy.data.name,
										enemy.data.life.current_value,
										enemy.data.life.max_value);
	enemy.reloadSprite = true;

# Players Init
func playerNodeInit():
	player.connect("onRunBattle", self, "_on_player_run_battle");
	player.connect("onSelectAction", self, "_on_player_select_action");
	player.connect("onPlayerDamageRecived", self, "_on_player_damage_recived");
	player.connect("onBattleEntityEndAction", self, "_on_battle_entity_end_action");
	player.connect("onBattleEntityStartAction", self, "_on_battle_entity_start_action");
	
func enemyNodeInit():
	enemy.connect("onEnemyDamageRecived", self,"_on_enemy_damage_recived");
	enemy.connect("onBattleEntityEndAction", self, "_on_battle_entity_end_action");
	enemy.connect("onBattleEntityStartAction", self, "_on_battle_entity_start_action");

#Utils
func generateRandomEnemies() -> Array:
	var generate_number = 3;
	var enemy_list_battle = [];
	
	for i in range(generate_number):
		var generateEnemy = RandomEnemy.new(GameData.Random);
		var randomEnemy = generateEnemy.__invoke(battle_zone, GameData.monsters);
		
		var data = {
			"sprite" : randomEnemy.sprite,
			"weapons" : randomEnemy.treasures.weapons,
			"gold" : randomEnemy.treasures.gold,
			"items" : randomEnemy.treasures.items,
			"data" : BattlerData.new(
				randomEnemy.name,
				randomEnemy.stats.life,
				randomEnemy.stats.atack,
				randomEnemy.stats.defense,
				randomEnemy.stats.speed
			)
		}
		
		enemy_list_battle.append(data);
		
	return enemy_list_battle;

# Signals Battle
func _on_battle_entity_start_action(self_entity):
	entity_is_perform_action = true;

func _on_battle_entity_end_action():
	current_battler_action += 1;
	entity_is_perform_action = false;

# Signals UI
func _on_enemy_damage_recived():
	$BattleLifeBarEnemy.call("LifeUpdate", enemy.data.life.current_value);

func _on_player_damage_recived():
	$BattleLifeBarPlayer.call("LifeUpdate", player.data.life.current_value);

# Signals Player Actions
func _on_player_select_action():
	battle_state = Types.state_battle.SPEED_CHECK;
	player_controls_active = false;

func _on_player_run_battle():
	queue_free();
