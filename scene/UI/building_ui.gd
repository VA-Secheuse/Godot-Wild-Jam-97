class_name BuildMenu extends GridContainer

@export var state_machine : StateMachine 

var turret_buttons : Array[Button]
@onready var selection_buttons : Array[Button] = [$Turret,$Upgrade]
@onready var state_buttons : Array[Button] = [ $Back, $Repair, $Destroy]
var upgrades : Array

func _ready() -> void:
	_generate_build_and_upgrades_buttons()
	_generate_menu_from_active_buttons()
	

func _on_back_pressed() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state,'Idle')
	_return_main_build_menu()
	_generate_menu_from_active_buttons()
	

func _on_repair_pressed() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state,'Repair')

func _on_destroy_pressed() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state,'Destroy')

func _on_turret_pressed() -> void:
	for button in selection_buttons:
		button.visible = false
	for button in turret_buttons:
		button.visible = true
	_generate_menu_from_active_buttons()

func _generate_menu_from_active_buttons() -> void:
	# Remove old spacer nodes synchronously, before counting/inserting new ones
	for child in get_children():
		if child is Space:
			remove_child(child)
			child.free()
	# Count only the dynamic building buttons (exclude pinned state buttons)
	var nb_buttons : int = 0
	for child in get_children():
		if child is Button and child.visible and not (child in state_buttons):
			nb_buttons += 1
	var spaces_needed = (4 - nb_buttons % 4) % 4 + 1
	print($Back.get_index())
	for i in range(spaces_needed):
		var space = Space.new()
		add_child(space)
		move_child(space, $Back.get_index() )

func _return_main_build_menu() : 
	for button in turret_buttons:
		button.visible = false
	for button in upgrades:
		button.visible = false
	for button in selection_buttons:
		button.visible = true

func _generate_build_and_upgrades_buttons():
	for turret in Global.turrets: 
		var button := ConstructionButton.new()
		button.building = turret
		button.icon = turret.sprite.texture
		button.custom_minimum_size = Vector2 (40,40)
		button.pressed.connect(_on_building_button_pressed.bind(button))
		add_child(button)
		move_child(button, 0)
		button.visible = false
		turret_buttons.append(button)
	move_child($Turret,0)
	move_child($Upgrade,1)
	
	for upgrade in Global.upgrades:
		var button := Button.new()
		button.icon = upgrade.sprite.texture
		button.custom_minimum_size = Vector2 (40,40)
		add_child(button)
		move_child(button, 0)
		button.visible = false
		upgrades.append(button)

func _on_building_button_pressed(button: ConstructionButton) -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state, 'Build')
	Global.base_manager.entered_build_state(button.building)
