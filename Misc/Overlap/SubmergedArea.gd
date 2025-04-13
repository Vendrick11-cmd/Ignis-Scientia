extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SubmergedArea_body_entered(_body):
	PlayerGlobal.MAXSPEED /= 2
	PlayerGlobal.JUMPFORCE /= 1.5
	PlayerGlobal.submerged = true


func _on_SubmergedArea_body_exited(_body):
	PlayerGlobal.MAXSPEED *= 2
	PlayerGlobal.JUMPFORCE *= 1.5
	PlayerGlobal.submerged = false
