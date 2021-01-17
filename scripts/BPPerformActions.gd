extends Resource

class_name BPPerformActions

func __invoke(entity_list : Array, current_index : int) -> bool:
	if current_index < entity_list.size():
		var current_entity = entity_list[current_index];
		if !current_entity.is_perform_action:
			current_entity.call("perform_action");
	
	return current_index == entity_list.size();
