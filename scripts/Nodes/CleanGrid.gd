extends GridContainer

func _ready():
	for child in get_children():
		child.queue_free();
