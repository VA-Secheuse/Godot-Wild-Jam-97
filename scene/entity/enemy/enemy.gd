class_name Enemy
extends CharacterBody2D  

##Positionning variable
var side : int
var target_coordinate : Vector2

##Stat variables
@export var stats_by_level: Array[EnemyStat] = []
@export var level : int = 1
@export var aim_position : Marker2D
var stats: EnemyStat

var is_knocked_back: bool = false
@export var knockback_duration: float = 0.2 


signal killed

func _ready() -> void:
	target_coordinate = Global.base_manager.get_closest_wall_coord_from_point(self.position)
	var template := stats_by_level[level - 1] 
	stats = template.duplicate()
	stats.current_health = stats.max_health

enum Type {
	SAND_SPRITE,
}

static var scenes: Dictionary = {
	Type.SAND_SPRITE: preload("res://scene/entity/enemy/sand_sprite/sand_sprite.tscn")
}

func damaged(nb_damage : int):
	stats.current_health -= nb_damage
	if stats.current_health <= 0:
		destroy()

##Signal Emited when an enemy dies
#This is connected to the enemy manager
func destroy() -> void :
	killed.emit()
	self.queue_free()

static func instantiate(type: Type) -> Enemy:
	return scenes[type].instantiate()


func apply_knockback(velocity_to_apply: Vector2) -> void:
	velocity = velocity_to_apply
	is_knocked_back = true
	await get_tree().create_timer(knockback_duration).timeout
	is_knocked_back = false
