class_name ResourceInfoMenu extends Control

var nb_gunpowder : int
var nb_iron : int
var nb_energium : int

func show_and_change_info_menu(iron: int, gunpowder: int, energium: int) -> void:
	nb_energium = energium
	nb_iron = iron
	nb_gunpowder = gunpowder
	
	$RichTextLabel.text = "%s %d\n%s %d\n%s %d" % [
		"+" if iron >= 0 else "-",
		abs(iron),
		"+" if gunpowder >= 0 else "-",
		abs(gunpowder),
		"+" if energium >= 0 else "-",
		abs(energium)
	]
	
	self.visible = true

func hide_menu():
	self.visible = false
