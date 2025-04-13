extends Control

var simplearrow = preload("res://Entities/Hemwick/Bows/Arrows/SimpleArrow.png")
var firearrow = preload("res://Entities/Hemwick/Bows/Arrows/FireArrow.png")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(_delta):
	$ArrowFirst/FirstArrowNumber.text = "%s" % [PlayerGlobal.slot1number]



	#SLOT 1 ---------------------------------------------------------------------------------
	if PlayerGlobal.slot1 == "none":
		$ArrowFirst/X.visible = false
		$ArrowFirst/FirstArrowNumber.visible = false
		$ArrowFirst/Arrow.visible = false
	else:
		$ArrowFirst/X.visible = true
		$ArrowFirst/FirstArrowNumber.visible = true
		$ArrowFirst/Arrow.visible = true


	if PlayerGlobal.slot1 == "simplearrow":
		$ArrowFirst/Arrow.texture = simplearrow
	elif PlayerGlobal.slot1 == "firearrow":
		$ArrowFirst/Arrow.texture = firearrow


