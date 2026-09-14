class_name IronResource extends Ressources


func _init() -> void:
	self.amount= randi_range(3,6)
	self.scene_path = "res://scene/ressources/iron/iron.tscn"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_instance_of(area,Player):
		Global.modify_amount_iron(amount)
