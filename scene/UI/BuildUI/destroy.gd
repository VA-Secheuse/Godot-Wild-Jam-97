extends State

func Enter():	
	Global.base_manager.highlight_building = true
	Global.base_manager.highlight_color = "cool"


func Exit():
	Global.base_manager.highlight_building = false
