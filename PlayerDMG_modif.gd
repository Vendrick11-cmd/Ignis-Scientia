extends Node



onready var DREAD = 0
onready var MAX_DREAD = 30
onready var has_dread = false
onready var has_dread_damage = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):




	if DREAD < -MAX_DREAD :
		DREAD = -MAX_DREAD
	if DREAD > MAX_DREAD :
		DREAD = MAX_DREAD

	if PlayerDmgModif.DREAD > 20 and has_dread_damage == false:
		has_dread_damage = true
		if PlayerGlobal.FeralDread == true:
			PlayerStats.base_damage = PlayerStats.initial_base_damage + 1
		elif PlayerGlobal.DreadedHeal == true:
			PlayerStats.base_damage = PlayerStats.initial_base_damage - 0.7
		else:
			PlayerStats.base_damage = PlayerStats.initial_base_damage - 0.5
	elif !PlayerDmgModif.DREAD > 20:
		PlayerStats.base_damage = PlayerStats.initial_base_damage
		has_dread_damage = false





	if DREAD > 0:
		if PlayerGlobal.FeralDread == true:
			DREAD -= 0.001
		elif PlayerGlobal.DreadedHeal == true:
			DREAD -= 0.003
		else :
			DREAD -= 0.005
		if DREAD < 0:
			DREAD = 0
