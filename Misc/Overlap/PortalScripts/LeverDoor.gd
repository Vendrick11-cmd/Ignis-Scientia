extends Area2D

export var posxGoTo = 0
export var posyGoTo = 0
onready var player = get_tree().current_scene.get_node("Hemwick")

onready var bardoor = $"../../BackgroundSprites/Doors/EntranceAnim"




func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if $RayCast2D.is_colliding() and Input.is_action_pressed("Interact") :
		if bardoor.get_node("AnimationPlayer").current_animation == "Open":
			$CollisionShape2D.disabled = false
	else :
		$CollisionShape2D.disabled = true


func _on_PortalInLevel_body_entered(_body):
	$CanvasLayer/Black/StartAnim.play("Quit")
	$Timer.start()






func _on_Timer_timeout():
	player.global_position.x = posxGoTo
	player.global_position.y = posyGoTo
