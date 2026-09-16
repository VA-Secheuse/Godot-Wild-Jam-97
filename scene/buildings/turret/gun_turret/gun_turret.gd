class_name GunTurret extends Turret

enum Facing { LEFT, UP, RIGHT, DOWN }
var current_facing: Facing = Facing.RIGHT

var retarget_interval: float = 0.15  
var _retarget_timer: float = 0.0

var test : bool = true

func _init() -> void:
	is_sided = true
	self.sprite = Sprite2D.new()
	_right_placement_info()
	self.scene_path = "res://scene/buildings/turret/gun_turret/GunTurret.tscn"

func _process(delta: float) -> void:
	_retarget_timer -= delta
	if _retarget_timer <= 0.0:
		_retarget_timer = retarget_interval
		current_target = $EnemyTracking.get_closest_enemy_from_point(global_position)
	if is_instance_valid(current_target) && !_on_cooldown:
		shoot()

func _ready() -> void:
	self.sprite = $Dummy

func shoot():
	if !building_finished :
		return
	rand_shoot_animation()
	match current_facing :
		Facing.RIGHT :
			$TopTurretPivot.look_at(current_target.global_position)
			$AnimationPlayer.play("shoot_right")
		Facing.LEFT :
			$AnimationPlayer.play("shoot_left")
			print(current_target.global_position)
			$TopTurretPivot.look_at(current_target.global_position)
			%TopTurretPivot.rotation_degrees += 180
		Facing.UP :
			$TopTurretPivot.look_at(current_target.global_position)
			$AnimationPlayer.play("shoot_top")
			%TopTurretPivot.rotation_degrees += 90
		Facing.DOWN:
			$TopTurretPivot.look_at(current_target.global_position)
			$AnimationPlayer.play("shoot_down")
			%TopTurretPivot.rotation_degrees -= 90

	var shared_direction : Vector2= (current_target.aim_position.global_position - $TopTurretPivot.global_position).normalized()
	_shoot_from_first_cannon(shared_direction)
	_shoot_from_second_cannon(shared_direction)

	_on_cooldown = true
	cooldown_timer.start()

func _shoot_from_first_cannon(dir: Vector2) -> void:
	var proj := projectile_scene.instantiate() as Projectile
	proj.global_position = $TopTurretPivot/ProjectileOutput1.global_position
	proj.direction = dir
	Global.main_level.map_generator.projectile_node.add_child(proj)

func _shoot_from_second_cannon(dir: Vector2) -> void:
	var proj := projectile_scene.instantiate() as Projectile
	proj.global_position = $TopTurretPivot/ProjectileOutput2.global_position
	proj.direction = dir
	Global.main_level.map_generator.projectile_node.add_child(proj)

func rand_shoot_animation():
	%Gun1.frame = randi_range(0,2)
	%Gun2.frame = randi_range(0,2)

func _on_building_ready() -> void:
	$Base.visible = true
	$TopTurretPivot/Top.visible = true
	$Dummy.visible = false

func _on_cool_down_timer_timeout() -> void:
	_on_cooldown = false


###### DONT TOUCH WONKY LOGIC FOR TURNING #######
func change_facing(facing : int):
	match facing :
		0:
			_face_left()
		1:
			_face_right()
		2:
			pass
		3:
			pass

func _face_left() -> void:
	#Changing the tracking side
	%EnemyTracking.position = Vector2(0,-36)
	%EnemyTracking.rotation_degrees = 180.0
	#changing The Dummy
	%Dummy.frame = 0
	%Dummy.flip_h = true
	#The area of the turret
	%Area2D.position = Vector2(0,0)
	%Area2D.rotation_degrees = 0.0
	#The Sprite of the top turret
	%Top.position = Vector2(0,0)
	%Top.offset = Vector2(-5,0)
	%Top.frame = 0
	%Top.flip_h = true
	#The Sprite of the shooting animation
	%Gun2.position = Vector2(-22,6)
	%Gun2.rotation_degrees = 0.0
	%Gun2.flip_h = true
	%Gun1.position = Vector2(-22,-3)
	%Gun1.rotation_degrees = 0.0
	%Gun1.flip_h = true
	#The position of the pivot and outputs
	%TopTurretPivot.position = Vector2(5,-18)
	%ProjectileOutput1.position = Vector2(-19.0,5.0)
	%ProjectileOutput2.position = Vector2(-19.0,-4.0)
	#The base sprite
	%Base.offset = Vector2(0,-12)
	%Base.position = Vector2(0,0)
	%Base.frame = 0
	%Base.flip_h = true
	#The info for the placement
	size = Vector2i(2,2)
	place = Vector2i(2,1)
	offset = Vector2(0,-12)

func _face_right() -> void:
	#Changing the tracking side
	%EnemyTracking.position = Vector2(0,0)
	%EnemyTracking.rotation_degrees = 0.0
	#changing The Dummy
	%Dummy.frame = 0
	%Dummy.flip_h = false
	#The area of the turret
	%Area2D.position = Vector2(0,0)
	%Area2D.rotation_degrees = 0.0
	#The Sprite of the top turret
	%Top.position = Vector2(0,0)
	%Top.frame = 0
	%Top.offset = Vector2(5,0)
	%Top.flip_h = false
	#The Sprite of the shooting animation
	%Gun2.position = Vector2(22,6)
	%Gun2.rotation_degrees = 0.0
	%Gun2.flip_h = false
	%Gun1.position = Vector2(22,-3)
	%Gun1.rotation_degrees = 0.0
	%Gun1.flip_h = false
	#The position of the pivot and outputs
	%TopTurretPivot.position = Vector2(-5,-18)
	%ProjectileOutput1.position = Vector2(19.0,5.0)
	%ProjectileOutput2.position = Vector2(19.0,-4.0)
	#The base sprite
	%Base.offset = Vector2(0,-12)
	%Base.position = Vector2(0,0)
	%Base.frame = 0
	%Base.flip_h = false
	#The info for the placement
	size = Vector2i(2,2)
	place = Vector2i(2,1)
	offset = Vector2(0,-12)

func _face_top() -> void:
	#Changing the tracking side
	%EnemyTracking.position = Vector2(18.0,-14.0)
	%EnemyTracking.rotation_degrees = -90.0
	#changing The Dummy
	%Dummy.frame = 1
	%Dummy.flip_h = false
	#The area of the turret
	%Area2D.position = Vector2(-4,-8)
	%Area2D.rotation_degrees = 90.0
	#The Sprite of the top turret
	%Top.position = Vector2(0,0)
	%Top.offset = Vector2(0,-3)
	%Top.frame = 1
	%Top.flip_h = false
	#The Sprite of the shooting animation
	%Gun2.position = Vector2(7,-18)
	%Gun2.rotation_degrees = -90.0
	%Gun2.flip_h = false
	%Gun1.position = Vector2(-6,-18)
	%Gun2.rotation_degrees = -90.0
	%Gun1.flip_h = false
	#The position of the pivot and outputs
	%TopTurretPivot.position = Vector2(0,-13.0)
	%ProjectileOutput1.position = Vector2(6.0,-16.0)
	%ProjectileOutput2.position = Vector2(-6,-16)
	#The base sprite
	%Base.offset = Vector2(-1.0,-12)
	%Base.position = Vector2(0,0)
	%Base.frame = 1
	%Base.flip_h = false
	#The info for the placement
	size = Vector2i(2,2)
	place = Vector2i(2,1)
	offset = Vector2(0,-12)

func _face_down() -> void:
	#Changing the tracking side
	%EnemyTracking.position = Vector2(-18.0,-15.0)
	%EnemyTracking.rotation_degrees = 90.0
	#changing The Dummy
	%Dummy.frame = 2
	%Dummy.flip_h = false
	#The area of the turret
	%Area2D.position = Vector2(-4,-8)
	%Area2D.rotation_degrees = 90.0
	#The Sprite of the top turret
	%Top.position = Vector2(0,0)
	%Top.offset = Vector2(0,5)
	%Top.frame = 2
	%Top.flip_h = false
	#The Sprite of the shooting animation
	%Gun2.position = Vector2(7,19)
	%Gun2.rotation_degrees = -90.0
	%Gun2.flip_h = true
	%Gun1.position = Vector2(-6,19)
	%Gun2.rotation_degrees = -90.0
	%Gun1.flip_h = true
	#The position of the pivot and outputs
	%TopTurretPivot.position = Vector2(0,-20)
	%ProjectileOutput1.position = Vector2(7.0,16.0)
	%ProjectileOutput2.position = Vector2(-6,16)
	#The base sprite
	%Base.offset = Vector2(0.0,-12)
	%Base.position = Vector2(0,0)
	%Base.frame = 2
	%Base.flip_h = false
	#The info for the placement
	size = Vector2i(2,2)
	place = Vector2i(2,1)
	offset = Vector2(0,-12)

func next_placement_side() -> void:
	current_facing = (current_facing + 1) % 4
	_change_placement_info(current_facing)

func place_good_side() -> void :
	match current_facing:
		0:
			_face_left()
		1:
			_face_top() 
		2:
			_face_right()
		3:
			_face_down()

func _change_placement_info(facing : int):
	match facing:
		0:
			_left_placement_info()
		1:
			_up_placement_info()
		2:
			_right_placement_info()
		3:
			_down_placement_info()

func _right_placement_info() -> void:
	sprite.texture = load("res://assets/sprite/building/turrets/turret_facing_right.png")
	size = Vector2i(2,2)
	place = Vector2i(2,1)
	offset = Vector2(16,0)

func _down_placement_info() ->void:
	sprite.texture = load("res://assets/sprite/building/turrets/turret_face_down.png")
	size = Vector2(1.5,2.5)
	place = Vector2i(1,2)
	offset = Vector2(8,12)

func _up_placement_info() -> void:
	sprite.texture = load("res://assets/sprite/building/turrets/turret_face_up.png")
	size = Vector2(1.5,2.5)
	place = Vector2i(1,2)
	offset = Vector2(8,12)

func _left_placement_info() -> void:
	sprite.texture = load("res://assets/sprite/building/turrets/turret_facing_left.png")
	size = Vector2i(2,2)
	place = Vector2i(2,1)
	offset = Vector2(16,0)
