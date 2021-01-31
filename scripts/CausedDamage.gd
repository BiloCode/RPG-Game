extends Resource

class_name CausedDamage

var random : RandomNumberGenerator;

func _init(random : RandomNumberGenerator):
	self.random = random;

func __invoke(entity_atack : int, target_defense : int):
	var variant_atack = random.randf_range(1, 1.2);
	var variant_defense = random.randf_range(0.9, 1.1);

	var current_atack = entity_atack * (4 * variant_atack);
	var target_current_defense = target_defense * (2 * variant_defense);
	var damage = current_atack - target_current_defense;

	return ceil(damage);
