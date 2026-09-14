class_name GunPowderDeposit extends RessourceDeposit

func _ready() -> void:
	self.max_health = 150
	self.cur_health = max_health
	self.nb_of_drop = 4
	self.scene_path = "res://scene/ressources/gunpowder/gun_powder_deposit.tscn"
	self.ressource = GunPowderResource.new()
	self.sprite2d = $Sprite2D
	sprite2d.material.set_shader_parameter("seed", randf_range(0.0, 100.0))
