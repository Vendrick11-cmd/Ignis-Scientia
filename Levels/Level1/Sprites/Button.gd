extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if $RayCast2D.is_colliding() and Input.is_action_just_pressed("Interact") :
		$AnimationPlayer.play("Pressed")
