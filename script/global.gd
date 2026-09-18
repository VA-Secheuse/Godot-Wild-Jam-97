extends Node

##Ressources
#Resource info
var nb_iron : int
var nb_gunpowder : int
var nb_energium : int
var ressources_observers : Array = []

#spawn ressource radius
var min_distance_between_nodes : float = 40.0

var resource_spawn_ranges = {
	"energium": {"scene_path": "res://scene/ressources/energium/energium_deposit.tscn", "min_radius_pct": 0.6, "max_radius_pct": 0.95, "density": 0.05},
	"iron": {"scene_path": "res://scene/ressources/iron/iron_deposit.tscn", "min_radius_pct": 0.3, "max_radius_pct": 0.7, "density": 0.10},
	"gunpowder": {"scene_path": "res://scene/ressources/gunpowder/gun_powder_deposit.tscn", "min_radius_pct": 0.3, "max_radius_pct": 0.7, "density": 0.07},
}


var main_level : MainLevel
var base_manager : BaseManager
var player : Player

##UI Global Reference
var building_UI : BuildMenu
var resouce_info : ResourceInfoMenu

##All turret type in array
var turrets : Array[Building] = [GunTurret.new(),EnergiumTurret.new(), MortarTurret.new()]

var upgrades : Array

##Tile set size
var tile_size : Vector2i = Vector2i(16,16)

func modify_amount_energium(amount : int) -> void:
	nb_energium -= amount
	if nb_energium < 0 :
		nb_energium = 0
	_notify_observer()

func modify_amount_iron(amount : int) -> void:
	nb_iron -= amount
	if nb_iron < 0 :
		nb_iron = 0
	_notify_observer()
	
func modify_amount_gunpowder(amount : int) -> void:
	nb_gunpowder -= amount
	if nb_gunpowder < 0 :
		nb_gunpowder = 0
	_notify_observer()

func add_ressources_observers(observer):
	ressources_observers.append(observer)

func _notify_observer() :
	for observer in ressources_observers :
		observer.change_in_ressources(nb_iron,nb_gunpowder,nb_energium)
