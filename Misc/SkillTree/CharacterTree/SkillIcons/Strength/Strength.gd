extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





#Strength
func _on_SkillButton_mouse_entered():
	if $Hover/YesNo/Activate.visible == false and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("Hover")
	if PlayerGlobal.Strength == true and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("ActiveHover")

func _on_SkillButton_mouse_exited():
	if !$SkillButton/Skill/AnimationPlayer.current_animation == "Click" and PlayerGlobal.Strength == false and $Hover/YesNo/Activate.visible == false and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("Idle")
	if PlayerGlobal.Strength == true:
		$SkillButton/Skill/AnimationPlayer.play("Active")

func _on_SkillButton_pressed():
	if PlayerGlobal.Feared == true:
		PlayerGlobal.active_skill = true
		if PlayerGlobal.skill_selector == 0 and PlayerGlobal.Strength == false:
			$SkillButton/Skill/AnimationPlayer.play("Click")
			PlayerGlobal.skill_selector = 1

func _on_YesButton_pressed():
	PlayerStats.initial_base_damage += 0.5
	$SkillButton/Skill/AnimationPlayer.play("Active")
	PlayerGlobal.active_skill = false
	PlayerGlobal.skill_selector = 0
	PlayerGlobal.Strength = true


func _on_NoButton_pressed():
	PlayerGlobal.active_skill = false
	PlayerGlobal.skill_selector = 0
	$SkillButton/Skill/AnimationPlayer.play("Idle")
