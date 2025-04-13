extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _celesteslam():
	var Celesteslam = preload("res://Effects/WeaponEffects/Celeste/CelesteSlam.tscn")
	var celesteslam = Celesteslam.instance()
	get_tree().current_scene.add_child(celesteslam)
	celesteslam.global_position = $"../WeaponArtsAnchor".global_position
