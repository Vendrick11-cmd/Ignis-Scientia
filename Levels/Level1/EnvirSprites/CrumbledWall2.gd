extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")


func _start_reset():
	$ResetTimer.start()


func _on_Area2D_body_entered(_body):
	$AnimationPlayer.play("Broke")




func _on_ResetTimer_timeout():
	$AnimationPlayer.play("Reset")


