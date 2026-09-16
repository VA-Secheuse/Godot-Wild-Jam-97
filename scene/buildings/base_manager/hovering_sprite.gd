extends Sprite2D

var base_manager : BaseManager

func _ready() -> void:
	base_manager = owner

func change_hovered_building(building : Building):
	##Set the hovered Texture and the size of the base of the building
	self.texture = building.sprite.texture
	$Hover/CollisionShape2D.shape.size = Global.tile_size * building.place
	
	##Offest the building to have the base be at the bottom
	offset.x = building.offset.x
	offset.y = building.offset.y
	$Hover/CollisionShape2D.position = Vector2(building.place.x * 16.0/2, building.place.y * Global.tile_size.y/2) 

func set_placement_valid(is_valid: bool):
	material.set_shader_parameter("invalid_amount", 0.0 if is_valid else 0.5)
	
func _on_hover_area_entered(area: Area2D) -> void:
	##If enterring layer 8 (Buildable Area)
	if (area.collision_layer) == 128 :
		base_manager.in_base = true
	##If enterring layer 7 (collision with another building)
	if (area.collision_layer) == 64 :
		base_manager.overlaping_building = true

func _on_hover_area_exited(area: Area2D) -> void:
	##If exiting layer 8
	if (area.collision_layer) == 128 :
		base_manager.in_base = false
	##If exiting layer 7 (collision with another building)
	if (area.collision_layer) == 64 :
		base_manager.overlaping_building = false

func reset_hovering():
	offset.x = 0
