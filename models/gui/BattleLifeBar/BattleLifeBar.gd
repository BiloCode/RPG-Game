extends ProgressBar

func UpdateLifeBar(name: String, current_life : int, max_life : int, isDrawText : bool):
	min_value = 0;
	value = current_life;
	max_value = max_life;
	$Name.text = name;
	if isDrawText:
		$LifePoints.text = str(current_life) + "/" + str(max_life);
