class_name EnemyWaveEntry
extends Resource

enum EnemyLevel {
	LEVEL_1 = 1,
	LEVEL_2 = 2,
	LEVEL_3 = 3,
}

enum Side {
	LEFT = 1,
	RIGHT = 2,
	UP = 4,
	DOWN = 8,
}

@export var enemy_type: Enemy.Type = Enemy.Type.SAND_SPRITE
@export var level: EnemyLevel = EnemyLevel.LEVEL_1
@export var amount: int = 10

@export_flags("Left", "Right", "Up", "Down") var enabled_sides: int = 0

func is_side_enabled(side: Side) -> bool:
	return (enabled_sides & side) != 0

func get_enabled_sides() -> Array[Side]:
	var sides: Array[Side] = []
	for side in Side.values():
		if is_side_enabled(side):
			sides.append(side)
	return sides

func pick_random_side() -> Side:
	var sides := get_enabled_sides()
	if sides.is_empty():
		return -1
	return sides.pick_random()

func get_enemy_key() -> String:
	return Enemy.Type.keys()[enemy_type].to_lower()

func instantiate_enemy() -> Enemy:
	return Enemy.instantiate(enemy_type)
