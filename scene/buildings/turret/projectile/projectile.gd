class_name Projectile extends Area2D

@export var projectile_stat : ProjectileStat

var timer : Timer
var direction : Vector2

func _ready() -> void:
	timer = $Timer
	rotation = direction.angle()  
	timer.start()

func _physics_process(delta: float) -> void:
	global_position += direction * projectile_stat.speed * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if is_instance_of(area.get_parent(),Enemy):
		var enemy : Enemy = area.get_parent()
		enemy.damaged(projectile_stat.damage)
		queue_free()
