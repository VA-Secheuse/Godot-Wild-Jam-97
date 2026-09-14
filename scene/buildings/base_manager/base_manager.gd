class_name BaseManager extends Node2D

var building_grid : TileMapLayer
var is_hovering : int =  false
var cur_building : Building
var selected_building : Building

var in_build_state : bool = false

var in_base : bool 
var overlaping_building : bool = false

const CONSTRUCTION_SHADER = preload("res://ressource/shader/construction_animation.gdshader")


func _ready() -> void:
	self.building_grid = $TileMapLayer

func _change_selected_building(building : Building) -> void:
	cur_building = building
	%HoveringSprite.change_hovered_building(building)

func _process(delta: float) -> void:
	if(is_hovering):
		hover(verify_placement())
	if(in_build_state && Input.is_action_just_pressed("LeftClick")):
		place_building()
		
	

func place_building():
	if(!verify_placement()):
		return
	var new_packed_scene : PackedScene = load(cur_building.scene_path)
	var new_building : Building = new_packed_scene.instantiate()
	##Setting the position of the building
	var local_pos = building_grid.to_local(get_global_mouse_position())
	new_building.position = (building_grid.local_to_map(local_pos) * Vector2i(16,16))
	new_building.position.x += new_building.size.x * Global.tile_size.x - Global.tile_size.x
	new_building.position.y -= new_building.offset.y 
	$ActiveBuilding.add_child(new_building)
	start_building_animation(new_building)
		
func start_building_animation(building : Building):
	var original_material = building.sprite.material
	
	var shader_material := ShaderMaterial.new()
	shader_material.shader = CONSTRUCTION_SHADER
	shader_material.set_shader_parameter("build_progress", 0.0)
	building.sprite.material = shader_material
	
	var tween = create_tween()
	tween.tween_method(
		func(value): shader_material.set_shader_parameter("build_progress", value),
		0.0, 1.0, 1.0 
	)
	
	await tween.finished
	
	building.sprite.material = original_material
	
	building.building_ready.emit()

func entered_build_state(building:Building) -> void:
	in_build_state = true
	_change_selected_building(building)
	start_hovering()

func exited_build_state() -> void :
	%HoveringSprite.reset_hovering()
	in_build_state = false
	stop_hovering()

func stop_hovering():
	%HoveringSprite.visible = false
	self.is_hovering = false

func start_hovering():
	%HoveringSprite.visible = true
	self.is_hovering = true

func hover(valid : bool) -> void:
	var local_pos = building_grid.to_local(get_global_mouse_position())
	%HoveringSprite.position = (building_grid.local_to_map(local_pos) * Vector2i(16,16))
	%HoveringSprite.set_placement_valid(valid)

func verify_placement() -> bool :
	return in_base && !overlaping_building
