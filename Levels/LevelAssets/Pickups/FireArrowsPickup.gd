extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if $Pickup.is_colliding() and Input.is_action_just_pressed("Interact"):
		if PlayerGlobal.slot1_busy == false:
			PlayerGlobal.slot1 = "firearrow"
			PlayerGlobal.slot1number += 1
			PlayerGlobal.slot1_busy = true
		elif PlayerGlobal.slot1_busy == true and PlayerGlobal.slot1 == "firearrow":
			PlayerGlobal.slot1number += 1
		elif PlayerGlobal.slot1_busy == true:
			pass




