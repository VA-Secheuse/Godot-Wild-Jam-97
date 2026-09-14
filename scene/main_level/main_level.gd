class_name MainLevel extends Node2D


var map_generator : MapGenerator

func _ready() -> void:
	_set_global_variable() 
	self.map_generator = %Level
	map_generator.generate_map()
	

func _set_global_variable() -> void:
	Global.main_level = self
	Global.base_manager = %BaseManager
	Global.building_UI = %BuildMenu
	Global.player = %Player
