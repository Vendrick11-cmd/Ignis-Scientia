extends StaticBody2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(_delta):
	if $InteractRay.is_colliding() and Input.is_action_just_pressed("Interact"):
		$InteractRay.enabled = false
		$PickUpArea/CollisionShape2D.disabled = true
		$AnimationPlayer.play("Open")











