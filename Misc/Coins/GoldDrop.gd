extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _gold():
		if PlayerSkills.Looting == true and PlayerGlobal.Current_Equipped in PlayerGlobal.DaggersWeapons:
			_dropmoneylooting()
		if PlayerGlobal.LuckI == true:
			_dropmoneyluckI()
		if PlayerGlobal.LuckII == true:
			_dropmoneyluckII()
		if PlayerGlobal.luckpotion == true:
			_dropmoneyluckI()
			_dropmoneyluckII()
		else :
			_dropmoney()

func _dropmoney():
	var anim = randi() % 3
	match anim :
		0 :
			var Bronzecoin = preload("res://Misc/Coins/5GoldCoin.tscn")
			var bronzecoin = Bronzecoin.instance()
			get_tree().current_scene.call_deferred("add_child",bronzecoin)
			bronzecoin.global_position = global_position
		1 :
			var Silvercoin = preload("res://Misc/Coins/10GoldCoin.tscn")
			var silvercoin = Silvercoin.instance()
			get_tree().current_scene.call_deferred("add_child",silvercoin)
			silvercoin.global_position = global_position
		2 : pass

func _dropmoneyluckI():
	var anim = randi() % 4
	match anim :
		0 :
			var Bronzecoin = preload("res://Misc/Coins/10GoldCoin.tscn")
			var bronzecoin = Bronzecoin.instance()
			get_tree().current_scene.call_deferred("add_child",bronzecoin)
			bronzecoin.global_position = global_position
		1 :
			var Silvercoin = preload("res://Misc/Coins/10GoldCoin.tscn")
			var silvercoin = Silvercoin.instance()
			get_tree().current_scene.call_deferred("add_child",silvercoin)
			silvercoin.global_position = global_position
		2:
			var Goldcoin = preload("res://Misc/Coins/25GoldCoin.tscn")
			var goldcoin = Goldcoin.instance()
			get_tree().current_scene.call_deferred("add_child",goldcoin)
			goldcoin.global_position = global_position
		3:
			pass


func _dropmoneyluckII():
	var anim = randi() % 4
	match anim :
		0 :
			var Bronzecoin = preload("res://Misc/Coins/25GoldCoin.tscn")
			var bronzecoin = Bronzecoin.instance()
			get_tree().current_scene.call_deferred("add_child",bronzecoin)
			bronzecoin.global_position = global_position
		1 :
			var Silvercoin = preload("res://Misc/Coins/10GoldCoin.tscn")
			var silvercoin = Silvercoin.instance()
			get_tree().current_scene.call_deferred("add_child",silvercoin)
			silvercoin.global_position = global_position
		2:
			var Goldcoin = preload("res://Misc/Coins/25GoldCoin.tscn")
			var goldcoin = Goldcoin.instance()
			get_tree().current_scene.call_deferred("add_child",goldcoin)
			goldcoin.global_position = global_position
		3:
			pass

func _dropmoneylooting():
		var anim = randi() % 4
		match anim :
			0 :
				var Bronzecoin = preload("res://Misc/Coins/10GoldCoin.tscn")
				var bronzecoin = Bronzecoin.instance()
				get_tree().current_scene.call_deferred("add_child",bronzecoin)
				bronzecoin.global_position = global_position
			1 :
				var Silvercoin = preload("res://Misc/Coins/10GoldCoin.tscn")
				var silvercoin = Silvercoin.instance()
				get_tree().current_scene.call_deferred("add_child",silvercoin)
				silvercoin.global_position = global_position
			2:
				var Goldcoin = preload("res://Misc/Coins/25GoldCoin.tscn")
				var goldcoin = Goldcoin.instance()
				get_tree().current_scene.call_deferred("add_child",goldcoin)
				goldcoin.global_position = global_position
			3:
				pass
