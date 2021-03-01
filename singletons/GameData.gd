extends Node

var game_state = Types.game_state.START;

onready var items = ItemsLoad.new().__invoke();
onready var weapons = WeaponsLoad.new().__invoke();
onready var skills = SkillsLoad.new().__invoke();
onready var monsters = MonsterLoad.new().__invoke();
onready var states = StatesLoad.new().__invoke();

var Random : RandomNumberGenerator;

func _ready():
	Random = RandomNumberGenerator.new();
	Random.randomize();
