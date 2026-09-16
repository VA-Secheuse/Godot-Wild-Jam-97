class_name EnemyStat extends Resource


## Stat Variables
@export var max_health: int = 10
@export var attack: int = 1
@export var speed: int = 100
@export var attack_range : int = 10

var current_health: int

func _init() -> void:
	current_health = max_health
