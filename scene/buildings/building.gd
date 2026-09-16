@abstract class_name Building extends Node2D

var size : Vector2
var sprite : Sprite2D
var place : Vector2i
var scene_path : String
var offset : Vector2i
var is_sided : bool = false
var building_finished : bool = false

var current_level : int = 1

@export var max_level : int = 1
@export var price : Array[Dictionary] = [{"iron" : 30, "gunpowder" : 0, "energium" : 0},{"iron" : 40, "gunpowder" : 10, "energium" : 0},{"iron" : 50, "gunpowder" : 20, "energium" : 5}]
@export var colliding_area : Area2D
@export var menu_coordinate : Marker2D

func _ready() -> void:
	colliding_area.mouse_entered.connect(func(): Global.base_manager.selected_building = self)
	colliding_area.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_exited() -> void:
	Global.base_manager.selected_building = null
	self.remove_highlight()

@abstract func highlight(color : String)

@abstract func remove_highlight()

func _resource_gain_on_delete() -> Array:
	var resources: Array = [0, 0, 0]
	for i in range(current_level):
		resources[0] += price[i]["iron"]
		resources[1] += price[i]["gunpowder"]
		resources[2] += price[i]["energium"]
	
	return resources

func _resource_needed_for_upgrade() -> Array:
	if current_level >= max_level:
		return [0, 0, 0]
	
	var upgrade_price: Dictionary = price[current_level]
	
	return [
		upgrade_price["iron"],
		upgrade_price["gunpowder"],
		upgrade_price["energium"]
	]

func show_info_ui() -> void:
	var tmp_array : Array = _resource_gain_on_delete()
	if Global.building_UI.state_machine.current_state.name.to_lower() == "destroy":
		Global.resouce_info.show_and_change_info_menu(tmp_array[0],tmp_array[1],tmp_array[2])
	
	elif Global.building_UI.state_machine.current_state.name.to_lower() == "upgrade":
		Global.resouce_info.show_and_change_info_menu(tmp_array[0],tmp_array[1],tmp_array[2])
	Global.resouce_info.global_position = menu_coordinate.global_position

func hide_info_ui() -> void:
	Global.resouce_info.hide_menu()

signal building_ready
