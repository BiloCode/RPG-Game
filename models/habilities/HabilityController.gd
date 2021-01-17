extends Node2D

signal onAnimationEnd;

var Cure = preload("res://models/habilities/Cure/Cure.tscn");

func playAnimation(parent, target):
	match parent.skill_selected:
		"atack":
			var target_node_animation = target.get_node("Animation");
			target_node_animation.play("AnimationBattleHit");
			yield(target_node_animation, "animation_finished");
			
		"object":
			var animation_cure = Cure.instance();
			animation_cure.transform = parent.transform;
			get_tree().root.add_child(animation_cure);
			yield(animation_cure, "onParticleDestroy");
	
	yield(get_tree().create_timer(1), "timeout");
	emit_signal("onAnimationEnd");
	queue_free();
