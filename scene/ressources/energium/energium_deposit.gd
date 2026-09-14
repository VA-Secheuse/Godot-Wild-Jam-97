class_name EnergiumDeposit extends RessourceDeposit


func _ready() -> void:
	self.max_health = 100
	self.cur_health = max_health
	self.nb_of_drop = 2
	self.scene_path = "res://scene/ressources/energium/energium_deposit.tscn"
	self.ressource = EnergiumRessources.new()
	self.sprite2d = $Sprite2D
	sprite2d.material.set_shader_parameter("seed", randf_range(0.0, 100.0))
