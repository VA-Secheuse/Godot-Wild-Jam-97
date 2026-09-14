class_name MapGenerator extends Node2D


var resource_parent : Node2D
var spawned_position : Array
var tile_map_layer : TileMapLayer

func _ready() -> void:
	self.tile_map_layer = %TileMapLayer
	resource_parent = %Ressource
	spawned_position = []

func generate_map():
	for x in range(-100, 101):
		for y in range(-100, 101):
			var atlas_coord = Vector2i(randi_range(0, 2), randi_range(0, 2))
			tile_map_layer.set_cell(Vector2i(x, y), 2, atlas_coord)
	spawn_all_resources()


func spawn_all_resources() -> void:
	spawned_position.clear()
	for resource_key in Global.resource_spawn_ranges.keys():
		_spawn_resource_type(resource_key)

func _spawn_resource_type(resource_key: String) -> void:
	var config = Global.resource_spawn_ranges[resource_key]
	var packed_scene : PackedScene = load(config["scene_path"])

	var map_half_size = 100 * Global.tile_size.x # matches your -100 to 100 tile loop

	var min_radius = config["min_radius_pct"] * map_half_size
	var max_radius = config["max_radius_pct"] * map_half_size

	var count = _calculate_count_for_density(min_radius, max_radius, config["density"])
	if count <= 0:
		return

	var angle_step = TAU / count

	for i in range(count):
		var spawn_pos = _find_valid_position(angle_step, i, min_radius, max_radius)
		if spawn_pos == null:
			continue

		var resource_node = packed_scene.instantiate()
		resource_node.global_position = spawn_pos
		add_child(resource_node)
		spawned_position.append(spawn_pos)

func _calculate_count_for_density(min_radius: float, max_radius: float, density_per_10000_px: float) -> int:
	var ring_area = PI * (max_radius * max_radius - min_radius * min_radius)
	return int(ring_area / 10000.0 * density_per_10000_px)

func _find_valid_position(angle_step: float, index: int, min_radius: float, max_radius: float):
	var max_attempts = 10
	for attempt in range(max_attempts):
		var angle = (angle_step * index) + randf_range(-angle_step * 0.3, angle_step * 0.3)
		var distance = randf_range(min_radius, max_radius)
		var candidate_pos = Vector2(cos(angle), sin(angle)) * distance

		if _is_position_valid(candidate_pos):
			return candidate_pos

	return null

func _is_position_valid(pos: Vector2) -> bool:
	for existing_pos in spawned_position:
		if pos.distance_to(existing_pos) < Global.min_distance_between_nodes:
			return false
	return true

func remove_and_reset() -> void:
	for child in resource_parent.get_children():
		if is_instance_of(child, RessourceDeposit):
			child.queue_free()
	Global.spawned_positions.clear()
