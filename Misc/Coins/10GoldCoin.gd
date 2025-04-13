extends RigidBody2D



onready var motion = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")
	linear_velocity.x = rand_range(-80,80)
	linear_velocity.y = rand_range(-40, -200)


func _physics_process(_delta):
	rotation_degrees = 0

	if angular_velocity < 3.5 :
		$CoinBounce.playing = false
		$CoinBounce2.playing = false
		$CoinBounce3.playing = false



func _on_Area2D_body_entered(_body):
	PlayerGlobal.coins += 3
	$AnimationPlayer.play("Idle")
	$Sprite.visible = false
	$Light.visible = false
	$Light2D.visible = false
	$Timer.start()
	$PickUp.playing = true



func _on_Timer_timeout():
	queue_free()


func _on_BounceArea_body_entered(_body):
		var anim = randi() % 2
		match anim :
			0 : $CoinBounce.playing = true
			1 : $CoinBounce2.playing = true
			2 : $CoinBounce3.playing = true




func _on_CanBePicked_timeout():
	$AnimationPlayer.play("CanBePicked")
