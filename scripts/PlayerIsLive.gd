extends Reference

class_name PlayerIsLive

func __invoke(life : Statistic):
	return life.current_value > 0;
