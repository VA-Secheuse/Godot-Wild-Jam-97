class_name RessourceDeposit extends StaticBody2D

var scene_path : String
var max_health : int
var nb_of_drop : int
var cur_health : int
var ressource : Ressources
var sprite2d : Sprite2D
var shake_tween: Tween


func mine(damage : int):
	var treshold_pass : int = _verify_integrity(damage)
	for i in range(treshold_pass):
		_damage_rock()
	if cur_health <= 0 :
		_destroy_rock()

func _verify_integrity(damage : int) -> int:
	var new_life_total : int= cur_health - damage
	var threshold_size = float(max_health) / float(nb_of_drop)
	
	var band_before = ceil(cur_health / threshold_size)
	var band_after = ceil(new_life_total / threshold_size)
	
	var thresholds_crossed = int(band_before - band_after)
	
	cur_health = new_life_total
	return thresholds_crossed

func _damage_rock() -> void:
	var current_crack = sprite2d.material.get_shader_parameter("crack_amount")
	var new_crack = current_crack + (float(max_health) / float(nb_of_drop) /100)
	sprite2d.material.set_shader_parameter("crack_amount", new_crack)
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
		
	var original_x = position.x
	shake_tween = create_tween()
	shake_tween.tween_property(sprite2d, "position:x", original_x + randf_range(-4, 4), 0.05)
	shake_tween.tween_property(sprite2d, "position:x", original_x, 0.05)
	
	_drop_ressource()

func _drop_ressource() -> void:
	var tmp_packed_scene : PackedScene = load(ressource.scene_path)
	var resource : Ressources = tmp_packed_scene.instantiate()
	get_tree().current_scene.add_child(resource)
	resource.global_position = self.global_position

	# random landing spot nearby, so drops scatter instead of stacking on one point
	var landing_offset = Vector2(randf_range(-20, 20), randf_range(10, 30))
	var start_pos = resource.global_position
	var end_pos = start_pos + landing_offset

	var arc_height = 20.0
	var duration = 0.5

	var tween = create_tween()
	tween.set_parallel(true)

	# horizontal + base vertical movement (straight line from start to end)
	tween.tween_property(resource, "global_position", end_pos, duration).set_trans(Tween.TRANS_LINEAR)

	# extra vertical arc on top, using a method tween driven by a sine curve for the "pop up then fall" feel
	tween.tween_method(
		func(t):
			var arc_offset = sin(t * PI) * arc_height
			resource.global_position.y = lerp(start_pos.y, end_pos.y, t) - arc_offset,
		0.0, 1.0, duration
	)

func _destroy_rock():
	pass
