@abstract class_name Turret extends Building

var current_target : Enemy
var shooting_area : Area2D
@export var projectile_scene: PackedScene
@export var cooldown_timer : Timer
@export var kcnoback_strenght : int
var _on_cooldown : bool = false


@abstract func shoot() -> void
@abstract func _on_building_ready() -> void

func _ready() -> void:
	super._ready()
