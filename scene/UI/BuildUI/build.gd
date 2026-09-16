extends State



func Update(_delta:float):
	if (Input.is_action_just_pressed("rotate") && Global.base_manager.cur_building.is_sided):
		Global.base_manager.turn_selected_building()

func Exit():
	Global.base_manager.exited_build_state()
