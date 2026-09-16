@abstract class_name Turret extends Building

var current_target : Enemy
var shooting_area : Area2D
@export var projectile_scene: PackedScene
@export var cooldown_timer : Timer
var _on_cooldown : bool = false

func _ready() -> void:
	super._ready()
