extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





#HealthII
func _on_SkillButton_mouse_entered():
	if $Hover/YesNo/Activate.visible == false and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("Hover")
	if PlayerGlobal.HealthII == true and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("ActiveHover")

func _on_SkillButton_mouse_exited():
	if !$SkillButton/Skill/AnimationPlayer.current_animation == "Click" and PlayerGlobal.HealthII == false and $Hover/YesNo/Activate.visible == false and PlayerGlobal.active_skill == false:
		$SkillButton/Skill/AnimationPlayer.play("Idle")
	if PlayerGlobal.HealthII == true:
		$SkillButton/Skill/AnimationPlayer.play("Active")

func _on_SkillButton_pressed():
	if PlayerGlobal.skillpoints > 0:
		if PlayerGlobal.Toughness == true:
			PlayerGlobal.active_skill = true
			if PlayerGlobal.skill_selector == 0 and PlayerGlobal.HealthII == false:
				$SkillButton/Skill/AnimationPlayer.play("Click")
				PlayerGlobal.skill_selector = 1

func _on_YesButton_pressed():
	PlayerStats.max_health = 110
	$SkillButton/Skill/AnimationPlayer.play("Active")
	PlayerGlobal.active_skill = false
	PlayerGlobal.skill_selector = 0
	PlayerGlobal.HealthII = true
	PlayerGlobal.skillpoints -= 1

func _on_NoButton_pressed():
	PlayerGlobal.active_skill = false
	PlayerGlobal.skill_selector = 0
	$SkillButton/Skill/AnimationPlayer.play("Idle")
