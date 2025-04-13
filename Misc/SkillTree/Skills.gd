extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if PlayerGlobal.sight == true:
		$Sight/SightButton/Sight/AnimationPlayer.play("Active")


#SIGHT1
func _on_SightButton_mouse_entered():
	if PlayerGlobal.sight == false:
		$Sight/SightButton/Sight/AnimationPlayer.play("Hover")
	$Sight/SightDescr.visible = true
func _on_SightButton_mouse_exited():
	$Sight/SightDescr.visible = false
	if !$Sight/SightButton/Sight/AnimationPlayer.current_animation == "Click" and PlayerGlobal.sight == false:
		$Sight/SightButton/Sight/AnimationPlayer.play("Idle")
	else :
		pass
func _on_SightButton_pressed():
	if PlayerGlobal.skill_selector == 0 and PlayerGlobal.sight == false:
		$Sight/SightButton/Sight/AnimationPlayer.play("Click")
		PlayerGlobal.skill_selector = 1

func _on_YesButton_pressed():
	PlayerGlobal.skill_selector = 0
	PlayerGlobal.sight = true


func _on_NoButton_pressed():
	PlayerGlobal.skill_selector = 0
	$Sight/SightButton/Sight/AnimationPlayer.play("Idle")
