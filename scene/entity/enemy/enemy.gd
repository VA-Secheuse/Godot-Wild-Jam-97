class_name Enemy
extends CharacterBody2D  

var side : int

signal killed

enum Type {
	SAND_SPRITE,
}

static var scenes: Dictionary = {
	Type.SAND_SPRITE: preload("res://scene/entity/enemy/sand_sprite/sand_sprite.tscn")
}

##Signal Emited when an enemy dies
#This is connected to the enemy manager
func destroy() -> void :
	killed.emit()

static func instantiate(type: Type) -> Enemy:
	return scenes[type].instantiate()
