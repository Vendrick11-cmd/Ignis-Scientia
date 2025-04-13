extends RigidBody2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass






func _bronze_coins() :
	var Bronzecoin = preload("res://Misc/Coins/5GoldCoin.tscn")
	var bronzecoin = Bronzecoin.instance()

	add_child(bronzecoin)
	bronzecoin.global_position = global_position

	var bronzecoin2 = Bronzecoin.instance()
	add_child(bronzecoin2)
	bronzecoin2.global_position = global_position

	var bronzecoin3 = Bronzecoin.instance()
	add_child(bronzecoin3)
	bronzecoin3.global_position = global_position

	var bronzecoin4 = Bronzecoin.instance()
	add_child(bronzecoin4)
	bronzecoin4.global_position = global_position

	var bronzecoin5 = Bronzecoin.instance()
	add_child(bronzecoin5)
	bronzecoin5.global_position = global_position

	var bronzecoin6 = Bronzecoin.instance()
	add_child(bronzecoin6)
	bronzecoin6.global_position = global_position

	var bronzecoin7 = Bronzecoin.instance()
	add_child(bronzecoin7)
	bronzecoin7.global_position = global_position

	var bronzecoin8 = Bronzecoin.instance()
	add_child(bronzecoin8)
	bronzecoin8.global_position = global_position

	var bronzecoin9 = Bronzecoin.instance()
	add_child(bronzecoin9)
	bronzecoin9.global_position = global_position

	var bronzecoin10 = Bronzecoin.instance()
	add_child(bronzecoin10)
	bronzecoin10.global_position = global_position

	var bronzecoin11 = Bronzecoin.instance()
	add_child(bronzecoin11)
	bronzecoin11.global_position = global_position

	var bronzecoin12 = Bronzecoin.instance()
	add_child(bronzecoin12)
	bronzecoin12.global_position = global_position

	var bronzecoin13 = Bronzecoin.instance()
	add_child(bronzecoin13)
	bronzecoin13.global_position = global_position

	var bronzecoin14 = Bronzecoin.instance()
	add_child(bronzecoin14)
	bronzecoin14.global_position = global_position

	var bronzecoin15 = Bronzecoin.instance()
	add_child(bronzecoin15)
	bronzecoin15.global_position = global_position

	var bronzecoin16 = Bronzecoin.instance()
	add_child(bronzecoin16)
	bronzecoin16.global_position = global_position


func _silver_coins() :
	var Silvercoin = preload("res://Misc/Coins/10GoldCoin.tscn")
	var silvercoin = Silvercoin.instance()

	add_child(silvercoin)
	silvercoin.global_position = global_position

	var silvercoin2 = Silvercoin.instance()
	add_child(silvercoin2)
	silvercoin2.global_position = global_position





func _gold_coins() :
	var Goldcoin = preload("res://Misc/Coins/25GoldCoin.tscn")
	var goldcoin = Goldcoin.instance()

	add_child(goldcoin)
	goldcoin.global_position = global_position

	var goldcoin2 = Goldcoin.instance()
	add_child(goldcoin2)
	goldcoin2.global_position = global_position


func _gold():
	_gold_coins()
	_silver_coins()
	_bronze_coins()


func _on_HurtBox_area_entered(area):
	$AnimationPlayer.play("Open")

