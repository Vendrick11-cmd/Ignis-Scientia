extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	pass
	
func _on_PickUpArea_area_entered(area):
	$Timer.start()


func _on_Timer_timeout():
	if PlayerGlobal.spear == false :
			PlayerGlobal.changed_weapon = true
			PlayerGlobal.spear = true
			PlayerGlobal.dagger = false
			PlayerGlobal.sword = false
			PlayerGlobal.boon_sword = false
			$Spear.visible = false
			$PickUpArea/CollisionShape2D.disabled = true
