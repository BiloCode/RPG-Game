extends ProgressBar

func LifeInit(battler_name: String, current_value: int, max_value: int):
	self.value = current_value;
	self.max_value = max_value;
	
	$Name.text = battler_name;
	$LifePoints.text = str(current_value) + "/" + str(max_value);

func LifeUpdate(final_value : int):
	var tween = $Tween;
	tween.interpolate_property(self, "value", self.value, final_value, .6,
												Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start();


func _on_Tween_tween_step(object, key, elapsed, value):
	$LifePoints.text = str(self.value) + "/" + str(self.max_value);
