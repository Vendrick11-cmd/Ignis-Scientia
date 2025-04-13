extends Node2D


#HATS
var none = preload("res://Entities/Hemwick/Accessories/Head/None.png")
var leaflantern = preload("res://Entities/Hemwick/Accessories/Head/LeafLantern.png")
var hornedhelmet = preload("res://Entities/Hemwick/Accessories/Head/HornedHelmet.png")
var oldhat = preload("res://Entities/Hemwick/Accessories/Head/OldHat.png")
var oldhat2 = preload("res://Entities/Hemwick/Accessories/Head/OldHat2.png")
var austrianpainter = preload("res://Entities/Hemwick/Accessories/Head/AustrianPainter.png")
var monocle = preload("res://Entities/Hemwick/Accessories/Head/Monocle.png")
var tophat = preload("res://Entities/Hemwick/Accessories/Head/TopHat.png")
var bell = preload("res://Entities/Hemwick/Accessories/Head/Bell.png")
var wizardhat = preload("res://Entities/Hemwick/Accessories/Head/WizardHat.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if PlayerGlobal.Hat != "leaflantern":
		$Hat/LeafCirclet.visible = false

	if PlayerGlobal.Hat != "bell":
		$Hat/GoldenBell.visible = false




	if PlayerGlobal.Hat == "none":
		$Hat.texture = none
	elif PlayerGlobal.Hat == "leaflantern":
		$Hat.texture = leaflantern
		$Hat/LeafCirclet.visible = true
	elif PlayerGlobal.Hat == "hornedhelmet":
		$Hat.texture = hornedhelmet
	elif PlayerGlobal.Hat == "oldhat":
		$Hat.texture = oldhat
	elif PlayerGlobal.Hat == "oldhat2":
		$Hat.texture = oldhat2
	elif PlayerGlobal.Hat == "austrianpainter":
		$Hat.texture = austrianpainter
	elif PlayerGlobal.Hat == "monocle":
		$Hat.texture = monocle
	elif PlayerGlobal.Hat == "tophat":
		$Hat.texture = tophat
	elif PlayerGlobal.Hat == "bell":
		$Hat.texture = bell
	elif PlayerGlobal.Hat == "wizardhat":
		$Hat.texture = wizardhat
