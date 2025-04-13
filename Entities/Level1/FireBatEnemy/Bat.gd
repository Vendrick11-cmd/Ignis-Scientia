extends KinematicBody2D


var knockback = Vector2.ZERO
const BloodEffect = preload("res://Misc/Overlap/BloodEffect.tscn") 
onready var player = get_tree().get_nodes_in_group("player")[0]
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state = IDLE
var motion = Vector2.ZERO
var facing_right = false
var facing_left = false
var knockback_dir = Vector2.ZERO
export var Hostile = true


export var GRAVITY = 0
export var MAXSPEED = 100

enum {
	IDLE,
	CHASE
}

func _ready():
	$AnimationTree.active = true
	
func _physics_process(delta):
	
	if $Bat.scale.x == 1 :
		facing_right = true
		facing_left = false
	elif $Bat.scale.x == -1 :
		facing_right = false
		facing_left = true
	
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	if motion.x < 0 :
		$Bat.scale.x = 1
	elif motion.x > 0 :
		$Bat.scale.x = -1
	
	if state == IDLE: 
		motion.y = -60
		motion.x = 0
		if $CeilingDetect.is_colliding() :
			motion.y = -60
			state_machine.travel("Idle")
	
	if state == CHASE :
		var player = $PlayerDetectionZone.player
		if player != null :
			var direction = (player.global_position - global_position).normalized()
			motion = motion.move_toward(direction * MAXSPEED, 70 * delta)
			knockback_dir = direction
		elif player == null :
			state = IDLE
	
	if MAXSPEED >= 100 :
		MAXSPEED = 100
	
	
	motion.y += GRAVITY
	motion = move_and_slide(motion)
		
	if $Detect.is_colliding() :
		$CeilingDetect.enabled = false
		state = CHASE
		state_machine.travel("Move")
	else :
		$CeilingDetect.enabled = true

func _on_HurtBox_area_entered(area):
	state_machine.travel("Hurt")
	$Stats.health -= area.damage
	if PlayerGlobal.Current_Equipped in PlayerGlobal.MagicWeapons:
		knockback = (global_position - area.global_position) * 4
	elif PlayerGlobal.Current_Equipped in PlayerGlobal.RangedWeapons:
		knockback = (global_position - area.global_position) * 5
	else:
		knockback = (global_position - player.global_position) * 8
	$GoldDrop._gold()
	


func _on_Stats_no_health():
	state_machine.travel("Die")
	set_physics_process(false)
	motion.x = 0
	




func _on_ShieldDetect_area_entered(_area):
	knockback = (global_position - player.global_position) * 20
	


