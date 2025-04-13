extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	pass

func _on_PickUpArea_area_entered(_area):
	$Timer.start()


func _on_Timer_timeout():
		if PlayerGlobal.boon_sword == false :
			PlayerGlobal.changed_weapon = true
			PlayerGlobal.sword = false
			PlayerGlobal.dagger = false
			PlayerGlobal.spear = false
			PlayerGlobal.boon_sword = true
			$BoonSword.visible = false
			$PickUpArea/CollisionShape2D.disabled = true

