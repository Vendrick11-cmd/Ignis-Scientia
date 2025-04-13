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
	if PlayerGlobal.shield_heater == false :
			PlayerGlobal.changed_weapon = true
			PlayerGlobal.shield_heater = true
			PlayerGlobal.shield_buckler = false
			$Heater.visible = false
			$PickUpArea/CollisionShape2D.disabled = true
