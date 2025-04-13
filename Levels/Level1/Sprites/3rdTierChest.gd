extends StaticBody2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_PickUpArea_area_entered(area):
	$AnimationPlayer.play("Open")
	$OpenTimer.start()
	$OpenTimer2.start()
	$OpenTimer3.start()
	set_collision_layer_bit(10, false)
	
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
	

func _silver_coins() :
	var Silvercoin = preload("res://Misc/Coins/10GoldCoin.tscn")
	var silvercoin = Silvercoin.instance()
	
	add_child(silvercoin)
	silvercoin.global_position = global_position
	
	var silvercoin2 = Silvercoin.instance()
	add_child(silvercoin2)
	silvercoin2.global_position = global_position
	
	var silvercoin3 = Silvercoin.instance()
	add_child(silvercoin3)
	silvercoin3.global_position = global_position
	
	var silvercoin4 = Silvercoin.instance()
	add_child(silvercoin4)
	silvercoin4.global_position = global_position
	
	var silvercoin5 = Silvercoin.instance()
	add_child(silvercoin5)
	silvercoin5.global_position = global_position
	
	var silvercoin6 = Silvercoin.instance()
	add_child(silvercoin6)
	silvercoin6.global_position = global_position
	
	var silvercoin7 = Silvercoin.instance()
	add_child(silvercoin7)
	silvercoin7.global_position = global_position
	

	
	
	
func _gold_coins() :
	var Goldcoin = preload("res://Misc/Coins/25GoldCoin.tscn")
	var goldcoin = Goldcoin.instance()
	
	add_child(goldcoin)
	goldcoin.global_position = global_position
	
	var goldcoin2 = Goldcoin.instance()
	add_child(goldcoin2)
	goldcoin2.global_position = global_position
	
	var goldcoin3 = Goldcoin.instance()
	add_child(goldcoin3)
	goldcoin3.global_position = global_position
	
	var goldcoin4 = Goldcoin.instance()
	add_child(goldcoin4)
	goldcoin4.global_position = global_position

	var goldcoin5 = Goldcoin.instance()
	add_child(goldcoin5)
	goldcoin5.global_position = global_position
	
	var goldcoin6 = Goldcoin.instance()
	add_child(goldcoin6)
	goldcoin6.global_position = global_position
	
	var goldcoin7 = Goldcoin.instance()
	add_child(goldcoin7)
	goldcoin7.global_position = global_position
	
	var goldcoin8 = Goldcoin.instance()
	add_child(goldcoin8)
	goldcoin8.global_position = global_position
	
	var goldcoin9 = Goldcoin.instance()
	add_child(goldcoin9)
	goldcoin9.global_position = global_position
	
	var goldcoin10 = Goldcoin.instance()
	add_child(goldcoin10)
	goldcoin10.global_position = global_position
	
	var goldcoin11 = Goldcoin.instance()
	add_child(goldcoin11)
	goldcoin11.global_position = global_position
	
	var goldcoin12 = Goldcoin.instance()
	add_child(goldcoin12)
	goldcoin12.global_position = global_position
	
	var goldcoin13 = Goldcoin.instance()
	add_child(goldcoin13)
	goldcoin13.global_position = global_position
	
	var goldcoin14 = Goldcoin.instance()
	add_child(goldcoin14)
	goldcoin14.global_position = global_position
	
	var goldcoin15 = Goldcoin.instance()
	add_child(goldcoin15)
	goldcoin15.global_position = global_position
	
	var goldcoin16 = Goldcoin.instance()
	add_child(goldcoin16)
	goldcoin16.global_position = global_position
	
	var goldcoin17 = Goldcoin.instance()
	add_child(goldcoin17)
	goldcoin17.global_position = global_position
	
	var goldcoin18 = Goldcoin.instance()
	add_child(goldcoin18)
	goldcoin18.global_position = global_position
	
	var goldcoin19 = Goldcoin.instance()
	add_child(goldcoin19)
	goldcoin19.global_position = global_position
	
	var goldcoin20 = Goldcoin.instance()
	add_child(goldcoin20)
	goldcoin20.global_position = global_position
	
	var goldcoin21 = Goldcoin.instance()
	add_child(goldcoin21)
	goldcoin21.global_position = global_position
	
	var goldcoin22 = Goldcoin.instance()
	add_child(goldcoin22)
	goldcoin22.global_position = global_position
	
	var goldcoin23 = Goldcoin.instance()
	add_child(goldcoin23)
	goldcoin23.global_position = global_position
	
	var goldcoin24 = Goldcoin.instance()
	add_child(goldcoin24)
	goldcoin24.global_position = global_position
	
	var goldcoin25 = Goldcoin.instance()
	add_child(goldcoin25)
	goldcoin25.global_position = global_position
	
func _on_OpenTimer_timeout():
	_bronze_coins()

func _on_OpenTimer2_timeout():
	_silver_coins()

func _on_OpenTimer3_timeout():
	_gold_coins()
