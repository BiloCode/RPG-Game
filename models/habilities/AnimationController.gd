extends Node2D

const Cure = preload("res://models/habilities/Cure/Cure.tscn");

signal onActionAnimationEnd;
signal onEntityAnimationEnd;

func is_fail_skill(battler) -> bool:
	var fail_skill = false;
	var probaility_fail = (100 / battler.skill_selected.precision) - 1;
	var probability = GameData.Random.randi_range(0, probaility_fail);
	
	return probability != 0;

func playAnimation(parent, target):
	var fail_skill = is_fail_skill(parent);
	
	match parent.skill_selected.name:
		"atack", "tackle":
			var AnimationParent = parent.get_node("Animation");
			var AnimationTarget = target.get_node("Animation");
			AnimationParent.play("MoveForHit");
			if !fail_skill:
				AnimationTarget.play("AnimationBattleHit");
				yield(AnimationTarget, "animation_finished");
				
		"defense":
			var AnimationParent = parent.get_node("Animation");
			AnimationParent.play("AnimationBattlerDefense");
			yield(AnimationParent, "animation_finished");
			
		"object":
			var animation_cure = Cure.instance();
			animation_cure.transform = parent.transform;
			get_tree().root.add_child(animation_cure);
			yield(animation_cure, "onParticleDestroy");
	
	if !fail_skill:
		emit_signal("onEntityAnimationEnd");

	yield(get_tree().create_timer(1), "timeout");
	emit_signal("onActionAnimationEnd");
	queue_free();
