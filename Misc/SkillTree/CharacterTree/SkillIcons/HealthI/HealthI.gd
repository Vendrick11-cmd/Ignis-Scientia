extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if PlayerGlobal.HealthI == true:
		$SkillButton/Skill/AnimationPlayer.play("Active")
	

#HealthI1
func _on_SkillButton_mouse_entered():
	if PlayerGlobal.HealthI == false  and $Hover/YesNo/Activate.visible == false and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("Hover")
		
func _on_SkillButton_mouse_exited():
	if !$SkillButton/Skill/AnimationPlayer.current_animation == "Click" and PlayerGlobal.HealthI == false and $Hover/YesNo/Activate.visible == false and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("Idle")
		
func _on_SkillButton_pressed():
	PlayerGlobal.active_skill = true
	if PlayerGlobal.skill_selector == 0 and PlayerGlobal.HealthI == false:
		$SkillButton/Skill/AnimationPlayer.play("Click")
		PlayerGlobal.skill_selector = 1
	
func _on_YesButton_pressed():
	PlayerGlobal.active_skill = false
	PlayerGlobal.skill_selector = 0
	PlayerGlobal.HealthI = true


func _on_NoButton_pressed():
	PlayerGlobal.active_skill = false
	PlayerGlobal.skill_selector = 0
	$SkillButton/Skill/AnimationPlayer.play("Idle")
