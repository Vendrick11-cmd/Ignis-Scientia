extends CanvasLayer


var animfinish = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _reset():
	$MoveBasic.visible = false
	$Interact.visible = false
	$WallJumping.visible = false
	$Harvesting.visible = false
	$Attack.visible = false
	$AirAttack.visible = false
	$DodgeDash.visible = false
	$SlamAttack.visible = false
	$Gardening.visible = false
	$Alchemy.visible = false
	$Inventory.visible = false
	$SkillPoints.visible = false
	$Dread.visible = false

func _physics_process(_delta):
	if animfinish == true:
		$Label/AnimationPlayer.play("Idle")
		if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept"):
			self.visible = false
			_reset()
			get_tree().paused = false


func _on_Resume_mouse_entered():
	$Resume/StartAnim.play("Hover")
func _on_Resume_mouse_exited():
	$Resume/StartAnim.play("Inactive")


func _on_Resume_pressed():
	self.visible = false
	_reset()
	get_tree().paused = false


func _on_AnimationPlayer_animation_finished(_Start):
	animfinish = true

func _animstart():
	animfinish = false
