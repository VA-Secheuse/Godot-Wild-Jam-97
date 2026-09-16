extends State

func Enter():
	print("entered destroy state")
	Global.base_manager.highlight_building = true
	Global.base_manager.highlight_color = "cool"


func Exit():
	Global.base_manager.highlight_building = false
