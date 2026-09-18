class_name MortarTurret extends Turret


func _init() -> void:
	is_sided = false
	self.sprite = Sprite2D.new()
	_set_hover_and_placement_info()
	self.scene_path = "res://scene/buildings/turret/mortar_turret/mortar_turret.tscn"

func _ready() -> void:
	super._ready()
	self.sprite = $TurretSprite

func _set_hover_and_placement_info():
	sprite.texture = load("res://assets/sprite/building/turrets/Mortar/Mortar.png")
	size = Vector2i(2,2)
	place = Vector2i(2,2)
	offset = Vector2(16,8)

func shoot() -> void:
	pass

func _on_building_ready() -> void:
	pass

func highlight(color : String):
	show_info_ui()
	$TurretSprite.material.set_shader_parameter("use_outline", true)
	
func remove_highlight():
	hide_info_ui()
	$TurretSprite.material.set_shader_parameter("use_outline", false)
