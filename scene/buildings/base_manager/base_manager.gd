class_name BaseManager extends Node2D

var building_grid : TileMapLayer
var is_hovering : int =  false
var cur_building : Building

var selected_building : Building

var in_build_state : bool = false

var in_base : bool 
var overlaping_building : bool = false

const CONSTRUCTION_SHADER = preload("res://ressource/shader/construction_animation.gdshader")

##Variable For building highlighting
var highlight_building : bool = false
var highlight_color : String

func _ready() -> void:
	self.building_grid = $TileMapLayer

func _change_selected_building(building : Building) -> void:
	cur_building = building
	%HoveringSprite.change_hovered_building(building)

func _process(delta: float) -> void:
	##This is for the hovering before placing a building
	if(is_hovering):
		hover(verify_placement())
	if(in_build_state && Input.is_action_just_pressed("LeftClick")):
		place_building()
	
	##This is for selecting a building too destroy \ upgrade
	if highlight_building && selected_building :
		selected_building.highlight(highlight_color)
	
	##Destroying a building
	if highlight_building && selected_building && Global.building_UI.state_machine.current_state.name.to_lower() == "destroy" && Input.is_action_just_pressed("LeftClick"):
		destroy_building(selected_building)

func turn_selected_building() -> void:
	if is_instance_of(cur_building, GunTurret):
		var turret : GunTurret = cur_building
		turret.next_placement_side()
		%HoveringSprite.change_hovered_building(turret)

func place_building():
	if(!verify_placement()):
		return
	var new_packed_scene : PackedScene = load(cur_building.scene_path)
	var new_building : Building = new_packed_scene.instantiate()
	##Setting the position of the building
	var local_pos = building_grid.to_local(get_global_mouse_position())
	new_building.position = Vector2(building_grid.local_to_map(local_pos) * Vector2i(16,16))
	#new_building.sprite.offset = new_building.offset
	$ActiveBuilding.add_child(new_building)
	
	##THIS IS ONLY FOR THE GUN TURRET BECAUSE ITS SIDED CALISSSSEE
	if new_building.is_sided:
		new_building as GunTurret
		new_building.current_facing = cur_building.current_facing
		new_building.place_good_side()
		print(cur_building.offset)
		new_building.position += Vector2(cur_building.offset.x , cur_building.offset.y + 12)
	
	start_building_animation(new_building)

##Aniamtion for building and destroying the building
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
	building.building_finished = true

func destroy_building(building: Building):
	building.hide_info_ui()
	var sprite := Sprite2D.new()
	sprite.texture = building.sprite.texture
	sprite.global_position = building.sprite.global_position
	sprite.offset = building.sprite.offset
	sprite.global_rotation = building.sprite.global_rotation
	sprite.global_scale = building.sprite.global_scale
	sprite.vframes = building.sprite.vframes
	sprite.flip_h = building.sprite.flip_h
	sprite.hframes = building.sprite.hframes
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.frame = building.sprite.frame
	
	sprite.z_index = building.sprite.z_index

	var shader_material := ShaderMaterial.new()
	shader_material.shader = CONSTRUCTION_SHADER
	
	shader_material.set_shader_parameter("build_progress", 1.0)
	shader_material.set_shader_parameter("line_color", Color.RED)

	sprite.material = shader_material

	building.get_parent().add_child(sprite)

	building.queue_free()

	var tween := create_tween()
	tween.tween_method(
		func(value):
			shader_material.set_shader_parameter("build_progress", value),
		1.0,
		0.0,
		1.0
	)

	await tween.finished

	sprite.queue_free()

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

func get_closest_wall_coord_from_point(point: Vector2) -> Vector2:
	var closest_point := Vector2.ZERO
	var closest_dist := INF

	for wall in [%Top, %Bottom, %Left, %Right]:
		var shape_node : CollisionShape2D = wall
		var shape := shape_node.shape as RectangleShape2D
		if shape == null:
			continue

		var xform := shape_node.global_transform
		var local_point := xform.affine_inverse() * point

		# Godot 4: RectangleShape2D uses "size", half of that is the extent
		var half_size := shape.size * 0.5

		var clamped_local := Vector2(
			clampf(local_point.x, -half_size.x, half_size.x),
			clampf(local_point.y, -half_size.y, half_size.y)
		)

		var world_point := xform * clamped_local
		var dist := point.distance_to(world_point)

		if dist < closest_dist:
			closest_dist = dist
			closest_point = world_point

	return closest_point
