class_name EnergiumTurret
extends Turret

@export var max_pulse_radius: float = 300.0
@export var pulse_duration: float = 0.6
@export var pulse_damage: int = 10
var can_shoot : bool = false

@onready var pulse_area: Area2D = $PusleArea
@onready var pulse_collision: CollisionShape2D = $PusleArea/CollisionShape2D

var _hit_enemies: Array[Node2D] = []
var _pulse_active : bool = false

func _init() -> void:
	is_sided = false
	self.sprite = Sprite2D.new()
	_set_hover_and_placement_info()
	self.scene_path = "res://scene/buildings/turret/energium_turret/EnergiumTurret.tscn"

func _ready() -> void:
	super._ready()
	self.sprite = $TurretSprite

	var color_rect := $ColorRect as ColorRect
	max_pulse_radius = color_rect.size.x / 2.0 

	var col_shape := pulse_collision.shape as CircleShape2D
	col_shape.radius = 0.0

	var mat := color_rect.material as ShaderMaterial
	mat.set_shader_parameter("node_size_px", color_rect.size)

	pulse_area.body_entered.connect(_on_pulse_body_entered)

func _set_hover_and_placement_info():
	sprite.texture = load("res://assets/sprite/building/turrets/Mortar/energy_turret.png")
	size = Vector2i(2,2)
	place = Vector2i(2,2)
	offset = Vector2(16,8)

func _process(delta: float) -> void:
	if !$EnemyTracking.enemies_in_range.is_empty() && can_shoot:
		shoot()

func shoot() -> void:
	_fire_pulse()
	can_shoot = false
	cooldown_timer.start()

func _on_building_ready() -> void:
	cooldown_timer.start()

func highlight(color: String):
	show_info_ui()
	$TurretSprite.material.set_shader_parameter("use_outline", true)

func remove_highlight():
	hide_info_ui()
	$TurretSprite.material.set_shader_parameter("use_outline", false)

##FOR THE PULSE PROJECTILE
func _fire_pulse() -> void:
	if _pulse_active:
		return

	_pulse_active = true
	_hit_enemies.clear()
	pulse_area.monitoring = true 

	var mat := $ColorRect.material as ShaderMaterial
	mat.set_shader_parameter("ring_radius_px", 0.0)
	mat.set_shader_parameter("fade_out", 1.0)

	var col_shape := pulse_collision.shape as CircleShape2D
	col_shape.radius = 0.0

	$ColorRect.visible = true

	var tween := create_tween()
	tween.tween_method(_update_pulse_radius, 0.0, max_pulse_radius, pulse_duration)
	tween.parallel().tween_method(func(f): mat.set_shader_parameter("fade_out", f), 1.0, 0.0, pulse_duration)
	tween.tween_callback(_on_pulse_finished)

func _on_pulse_finished() -> void:
	$ColorRect.visible = false
	pulse_area.monitoring = false 
	var col_shape := pulse_collision.shape as CircleShape2D
	col_shape.radius = 0.0
	_pulse_active = false

func _update_pulse_radius(r: float) -> void:
	var mat := $ColorRect.material as ShaderMaterial
	mat.set_shader_parameter("ring_radius_px", r)

	var col_shape := pulse_collision.shape as CircleShape2D
	col_shape.radius = r

func _on_pulse_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Enemy) and body not in _hit_enemies:
		_hit_enemies.append(body)
		var enemy := body as Enemy
		var direction := (enemy.global_position - global_position).normalized()
		enemy.apply_knockback(direction * kcnoback_strenght)
		enemy.damaged(pulse_damage)

func _on_cool_down_timer_timeout() -> void:
	can_shoot = true
