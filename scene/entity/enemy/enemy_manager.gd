class_name EnemyManager extends Node2D

@export var current_wave : int
var enemy_to_be_spawned : Array[Enemy]

var enemy_node : Node2D
@export var max_on_screened_enemy : int
@export var waves_info : Array[WaveResource] 
var current_wave_info : WaveResource
var wave_lenght_sec : float 
signal wave_finished


var min_cluster_size : int 
var max_cluster_size : int
var min_time_spacing :float
var max_time_spacing : float


var timer : Timer

func _ready() -> void:
	enemy_node = $LiveEnemy
	timer = $Timer
	min_time_spacing = 3
	max_time_spacing = 6
	wave_lenght_sec = 90

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("test")):
		start_next_wave()

##This function is to be called when you want to start a new wave
func start_next_wave() -> void :
	enemy_to_be_spawned = _get_enemy_wave(current_wave)
	_set_spawn_value(enemy_to_be_spawned,wave_lenght_sec)
	_start_spawning_enemy()

func _set_spawn_value(enemy_to_be_spawned : Array, wave_lenght : float) -> void:
	var median_time := (max_time_spacing+min_time_spacing) / 2
	var nb_of_cluster_spawning = ceil(wave_lenght/median_time)
	max_cluster_size = ceil(enemy_to_be_spawned.size() / nb_of_cluster_spawning ) + 3
	min_cluster_size = max(0,max_cluster_size - 6)

##This is the initial spawn will spawn all the enemy up to the limit or until the array is empty
func _start_spawning_enemy() -> void :
	var cluster_size : int = randi_range(min_cluster_size,max_cluster_size)
	var next_spawn_time : float = randf_range(min_time_spacing,max_time_spacing)
	
	if cluster_size > max_on_screened_enemy - $LiveEnemy.get_children().size() :
		timer.wait_time = next_spawn_time
		timer.start()
		return
	
	for i in range(cluster_size):
		if enemy_to_be_spawned.is_empty():
			return
		var tmp_enemy : Enemy = enemy_to_be_spawned.pop_front()
		tmp_enemy.position = _get_random_spawnable_coordinate(tmp_enemy.side)
		enemy_node.add_child(tmp_enemy)
	
	timer.wait_time = next_spawn_time
	timer.start()

##This instantiate and keep all the reference of the enemy in an array
func _get_enemy_wave(wave_number : int) -> Array[Enemy]:
	current_wave_info = waves_info[wave_number]
	var enemy_wave : Array[Enemy] = []
	
	for enemy_wave_entry: EnemyWaveEntry in current_wave_info.entries:
		for i in enemy_wave_entry.amount :
			var new_enemy : Enemy = enemy_wave_entry.instantiate_enemy()
			#This give the side where the enemy needs to spawn
			new_enemy.side = enemy_wave_entry.pick_random_side()
			new_enemy.level = enemy_wave_entry.level
			new_enemy.killed.connect(_on_enemy_killed)
			enemy_wave.append(new_enemy)
	
	return enemy_wave

##This function is called when an enemy is killed
func _on_enemy_killed() -> void:
	pass

##This function is called when the signal wave_finished is being emited
func _on_wave_finished() -> void:
	current_wave += 1

func _get_random_spawnable_coordinate(side: int) -> Vector2:
	match side:
		EnemyWaveEntry.Side.LEFT:
			return _get_random_point_in_collision_shape_2d($EnemySpawn/SpawnLeft)
		EnemyWaveEntry.Side.RIGHT:
			return _get_random_point_in_collision_shape_2d($EnemySpawn/SpawnRight)
		EnemyWaveEntry.Side.UP:
			return _get_random_point_in_collision_shape_2d($EnemySpawn/SpawnTop)
		EnemyWaveEntry.Side.DOWN:
			return _get_random_point_in_collision_shape_2d($EnemySpawn/SpawnBot)

	return global_position

func _get_random_point_in_collision_shape_2d(shape : CollisionShape2D) -> Vector2:
	var rect: Rect2 = shape.shape.get_rect()
	var random_x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var random_y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	return shape.global_position + Vector2(random_x, random_y)
