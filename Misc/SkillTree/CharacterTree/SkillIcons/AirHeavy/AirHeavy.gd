extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if PlayerGlobal.AirHeavy == true:
		$Button/AnimationPlayer.play("Active")

func _on_Button_mouse_entered():
	if $"../Dash/Button/AnimationPlayer".current_animation == "Active" :
		$Descr.visible = true
		$Button/AnimationPlayer.play("Hover")
	else : pass
	
func _on_Button_mouse_exited():
	if $"../Dash/Button/AnimationPlayer".current_animation == "Active":
		if !$Button/AnimationPlayer.current_animation == "Click":
			$Button/AnimationPlayer.play("Idle")
			$Descr.visible = false
		else : pass
	else : pass
func _on_Button_pressed():
	if PlayerGlobal.skill_selector == 0 and PlayerGlobal.AirHeavy == false :
		if $"../Dash/Button/AnimationPlayer".current_animation == "Active":
			$Button/AnimationPlayer.play("Click")
			$Descr.visible = false
			PlayerGlobal.skill_selector = 1
			if PlayerGlobal.AirHeavy == false:
				$Sure.visible = true
			else : pass
		else : pass
func _on_Yes_pressed():
	PlayerGlobal.skill_selector = 0
	PlayerGlobal.AirHeavy = true
	$Sure.visible = false
func _on_No_pressed():
	PlayerGlobal.skill_selector = 0
	$Button/AnimationPlayer.play("Idle")
	$Sure.visible = false
