class_name EnemyTrackerArea
extends Area2D

var enemies_in_range: Array[Node2D] = []

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)

func get_closest_enemy_from_point(point: Vector2) -> Node2D:
	var closest_enemy: Node2D = null
	var closest_dist_sq := INF
	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):  # enemy might have been freed (died) without exiting cleanly
			continue
		var dist_sq := point.distance_squared_to(enemy.global_position)
		if dist_sq < closest_dist_sq:
			closest_dist_sq = dist_sq
			closest_enemy = enemy
	return closest_enemy
