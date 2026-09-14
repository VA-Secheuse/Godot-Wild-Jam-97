class_name GunTurret extends Building


func _init() -> void:
	self.sprite = Sprite2D.new()
	self.sprite.texture = load("res://assets/sprite/building/turrets/Tourelle_placeholder.png")
	self.size = Vector2i(2,2)
	self.place = Vector2i(2,1)
	self.scene_path = "res://scene/buildings/turret/gun_turret/GunTurret.tscn"
	self.offset = Vector2(0,-12)

func _ready() -> void:
	self.sprite = $Dummy


func shoot():
	rand_shoot_animation()
	$AnimationPlayer.play("shoot")
	
	
func rand_shoot_animation():
	$Gun1.frame = randi_range(0,2)
	$Gun2.frame = randi_range(0,2)


func _on_building_ready() -> void:
	$Base.visible = true
	$Top.visible = true
	$Dummy.visible = false
