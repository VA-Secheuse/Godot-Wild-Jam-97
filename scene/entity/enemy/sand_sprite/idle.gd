extends State

var enemy : Enemy

func _ready() -> void:
	enemy = $"../.."
	
	
func Update(_delta:float) -> void:
	if enemy.global_position.distance_to(enemy.target_coordinate) > enemy.stats.attack_range:
		Transitioned.emit(self,"Walking")
	
	elif  enemy.global_position.distance_to(enemy.target_coordinate) < enemy.stats.attack_range:
		Transitioned.emit(self,"Attack")
