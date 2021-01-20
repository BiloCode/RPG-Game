extends KinematicBody2D

export(int, 100, 150) var speed : int = 100;

var state;
var direction;
var probability = 3;
var velocity = Vector2(0,0);

signal onStartBattle;

func _process(delta):
	if GameData.game_state != Types.game_state.START: 
		return;
	
	var key_left = Input.is_action_pressed("ui_left");
	var key_right = Input.is_action_pressed("ui_right");
	var key_up = Input.is_action_pressed("ui_up");
	var key_down = Input.is_action_pressed("ui_down");
	
	velocity.x = (int(key_right) - int(key_left)) * speed;
	velocity.y = (int(key_down) - int(key_up)) * speed;
	
	if key_right:
		direction = Types.movable_direction.RIGHT;
	elif key_left:
		direction = Types.movable_direction.LEFT;
	
	$Sprite.flip_h = direction == Types.movable_direction.RIGHT;
	
	if velocity.x != 0 or velocity.y != 0:
		state = Types.state_machine.MOVE;
	else:
		state = Types.state_machine.IDDLE;
	
	velocity = move_and_slide(velocity);
