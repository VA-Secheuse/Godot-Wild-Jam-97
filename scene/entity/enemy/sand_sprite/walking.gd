extends State

var direction : Vector2
var enemy : Enemy

func _ready() -> void:
	enemy = $"../.."

# Called when the node enters the scene tree for the first time.
func Enter() -> void:
	direction = enemy.global_position.direction_to(enemy.target_coordinate)
	
func Update(_delta:float) -> void:
	enemy.velocity = direction * enemy.stats.speed
	enemy.move_and_slide()
	if enemy.global_position.distance_to(enemy.target_coordinate) < enemy.stats.attack_range:
		Transitioned.emit(self,"Attack")
	_update_direction()

func _update_direction() -> void:
	var sprite = $"../../Sprite2D"
	##if facing left
	if direction.x > 0 && abs(direction.x) > abs(direction.y) && sprite.position != Vector2(7.0,-8.0) :
		sprite.frame = 1
		sprite.rotation_degrees = -90.0
		sprite.flip_v = false
		sprite.position = Vector2(7.0,-8.0)
	
	##if facing right
	if direction.x < 0 &&  abs(direction.x) > abs(direction.y) && sprite.position != Vector2(17.0,-8.0):
		sprite.frame = 1
		sprite.rotation_degrees = -90.0
		sprite.flip_v = true
		sprite.position = Vector2(17.0,-8.0)
	
	if direction.y > 0  &&  abs(direction.x) < abs(direction.y) && sprite.position != Vector2(0,0) :
		sprite.frame = 0
		sprite.rotation_degrees = 0
		sprite.flip_v = false
		sprite.position = Vector2(0,0)
	
	if direction.y < 0 && abs(direction.x) < abs(direction.y) && sprite.position != Vector2(0,-8):
		sprite.frame = 2
		sprite.rotation_degrees = 180
		sprite.flip_v = false
		sprite.position = Vector2(0,-8)
