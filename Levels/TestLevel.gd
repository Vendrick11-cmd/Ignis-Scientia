extends Node2D

var reticle_fireball = preload("res://Misc/UI elements/Reticles/Fireball_reticle.png")
var reticle_sword = preload("res://Misc/UI elements/Reticles/Dagger_reticle.png")
var rubble1 = preload("res://Levels/Level1/Sprites/Rubbles/Candle/CandleRubble.tscn")
var rubble2 = preload("res://Levels/Level1/Sprites/Rubbles/PaperRubble.tscn")
var rubble3 = preload("res://Levels/Level1/Sprites/Rubbles/woodRubble.tscn")
var rubble4 = preload("res://Levels/Level1/Sprites/Rubbles/woodRubbleLess.tscn")
#var level = preload("res://Levels/Begin/LevelBegin.tscn")

onready var player = get_tree().get_nodes_in_group("player")[0]




# Called when the node enters the scene tree for the first time.
func _ready():
	#load_game()
	pass


func _pause():
	PlayerGlobal.in_dialogue = true

func _unpause():
	PlayerGlobal.in_dialogue = false






func _physics_process(delta):
	_chests()

	if $Hemwick/HemwickSword.scale.x == 1:
		$Camera2D.offset_h = lerp($Camera2D.offset_h, 0.4, 2 * delta)
	if $Hemwick/HemwickSword.scale.x == -1:
		$Camera2D.offset_h = lerp($Camera2D.offset_h, -0.4, 2 * delta)

	#PlayerStats.health = PlayerStats.max_health
	PlayerStats.stamina = PlayerStats.max_stamina
	PlayerStats.mana = PlayerStats.max_mana


	_weapons()

	if PlayerGlobal.Current_Equipped in PlayerGlobal.MagicWeapons or PlayerGlobal.Current_Equipped in PlayerGlobal.RangedWeapons:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_custom_mouse_cursor(reticle_fireball)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()

	if Input.is_action_just_pressed("DOwN"):
		save_game()

	if Input.is_action_just_pressed("UP"):
		load_game()
func _weapons():

	if $LevelControl/Dagger/DgrRay.is_colliding() and Input.is_action_just_pressed("Interact"):
		if PlayerGlobal.Primary != "dagger" and PlayerGlobal.Secondary != "dagger":

			if PlayerGlobal.PrimarySelect == true:
				PlayerGlobal.pickup_weaponprimary = true
				PlayerGlobal.pickup_weaponsecondary = false
				PlayerGlobal.Primary = "dagger"
				PlayerGlobal.Current_Equipped = "dagger"
			elif PlayerGlobal.PrimarySelect != true:
				PlayerGlobal.pickup_weaponprimary = false
				PlayerGlobal.pickup_weaponsecondary = true
				PlayerGlobal.Secondary = "dagger"
				PlayerGlobal.Current_Equipped = "dagger"


	elif $LevelControl/Shovel/InteractRay.is_colliding() and Input.is_action_just_pressed("Interact"):
		if PlayerGlobal.Primary != "shovel" and PlayerGlobal.Secondary != "shovel":

			if PlayerGlobal.PrimarySelect == true:
				PlayerGlobal.pickup_weaponprimary = true
				PlayerGlobal.pickup_weaponsecondary = false
				PlayerGlobal.Primary = "shovel"
				PlayerGlobal.Current_Equipped = "shovel"
			elif PlayerGlobal.PrimarySelect != true:
				PlayerGlobal.pickup_weaponprimary = false
				PlayerGlobal.pickup_weaponsecondary = true
				PlayerGlobal.Secondary = "shovel"
				PlayerGlobal.Current_Equipped = "shovel"


	elif $LevelControl/Fireball/InteractRay.is_colliding() and Input.is_action_just_pressed("Interact"):
		if PlayerGlobal.Primary != "fireball" and PlayerGlobal.Secondary != "fireball" :

			if PlayerGlobal.PrimarySelect == true:
				PlayerGlobal.pickup_weaponprimary = true
				PlayerGlobal.pickup_weaponsecondary = false
				PlayerGlobal.Primary = "fireball"
				PlayerGlobal.Current_Equipped = "fireball"

			elif PlayerGlobal.PrimarySelect != true:
				PlayerGlobal.pickup_weaponprimary = false
				PlayerGlobal.pickup_weaponsecondary = true
				PlayerGlobal.Secondary = "fireball"
				PlayerGlobal.Current_Equipped = "fireball"



	elif $LevelControl/Celeste/InteractRay.is_colliding() and Input.is_action_just_pressed("Interact"):
		if PlayerGlobal.Primary != "celeste" and PlayerGlobal.Secondary != "celeste" :

			if PlayerGlobal.PrimarySelect == true:
				PlayerGlobal.pickup_weaponprimary = true
				PlayerGlobal.pickup_weaponsecondary = false
				PlayerGlobal.Primary = "celeste"
				PlayerGlobal.Current_Equipped = "celeste"

			elif PlayerGlobal.PrimarySelect != true:
				PlayerGlobal.pickup_weaponprimary = false
				PlayerGlobal.pickup_weaponsecondary = true
				PlayerGlobal.Secondary = "celeste"
				PlayerGlobal.Current_Equipped = "celeste"

	else:
		PlayerGlobal.pickup_weaponprimary = false
		PlayerGlobal.pickup_weaponsecondary = false


func _camera():
	if PlayerGlobal.in_dialogue == true:
		$Camera2D.smoothing_enabled = true
		if DialogueStats.talking == "hemwick":
			$Hemwick/RemoteTransform2D.global_position = $Hemwick.global_position

		if DialogueStats.talking == "cruxius":
			$Hemwick/RemoteTransform2D.global_position = $NPCs/Cruxius.global_position




func _chests():
	if $ItemChest/InteractRay.is_colliding() and Input.is_action_just_pressed("Interact"):
		PlayerGlobal.PickUp = true
		PlayerGlobal.Name = "150x Gold"
		IAdd.start()
		PlayerGlobal.coins += 150

		PlayerGlobal.Name = "Health Vial Recipe"
		IAdd.start()
		InventoryLoad.recipepotionhealthvial = true



func save_game():
	var config = ConfigFile.new()

	config.set_value("Player", "player_pos_x",$Hemwick.position.x)
	config.set_value("Player", "player_pos_y",$Hemwick.position.y)
	config.set_value("Player", "player_health", PlayerStats.health)
	config.set_value("Player", "player_maxhealth", PlayerStats.max_health)
	config.set_value("Player", "player_stamina", PlayerStats.stamina)
	config.set_value("Player", "player_maxstamina", PlayerStats.max_stamina)
	config.set_value("Player", "player_armor", PlayerStats.armor)
	config.set_value("Player", "player_maxarmor", PlayerStats.max_armor)
	config.set_value("Player", "player_mana", PlayerStats.mana)
	config.set_value("Player", "player_maxmana", PlayerStats.max_mana)
	config.set_value("Player", "Coins", PlayerGlobal.coins)

	#config.set_value("Ghost2", "ghost2_pos_y",$Enemies/Ghost2.position.y)
	#config.set_value("Ghost2", "ghost2_pos_x",$Enemies/Ghost2.position.x)
	#config.set_value("Ghost2", "ghost2_alive", $Enemies/Ghost2.alive)
	#config.set_value("Ghost2", "ghost2_health", $Enemies/Ghost2/Stats.health)

	var error = config.save("res://Saves/save.ini")
	if error == OK:
		print("Game Saved")
	else:
		print("Error Saving")

func load_game():
	var config = ConfigFile.new()

	var error = config.load("res://Saves/save.ini")
	if error == OK:

		#yield(get_tree().create_timer(1), "timeout")
		player.position.x = config.get_value("Player", "player_pos_x",$Hemwick.position.x)
		player.position.y = config.get_value("Player", "player_pos_y",$Hemwick.position.y)
		PlayerStats.health = config.get_value("Player", "playerhealth", PlayerStats.health)
		PlayerStats.max_health = config.get_value("Player", "player_maxhealth", PlayerStats.max_health)
		PlayerStats.stamina = config.get_value("Player", "player_stamina", PlayerStats.stamina)
		PlayerStats.max_stamina = config.get_value("Player", "player_maxstamina", PlayerStats.max_stamina)
		PlayerStats.armor = config.get_value("Player", "player_armor", PlayerStats.armor)
		PlayerStats.max_armor = config.get_value("Player", "player_maxarmor", PlayerStats.max_armor)
		PlayerStats.mana = config.get_value("Player", "player_mana", PlayerStats.mana)
		PlayerStats.max_mana = config.get_value("Player", "player_maxmana", PlayerStats.max_mana)
		PlayerGlobal.coins = config.get_value("Player", "Coins", PlayerGlobal.coins)

		#$Enemies/Ghost2.position.y = config.get_value("Ghost2", "ghost2_pos_y",$Enemies/Ghost2.position.y)
		#$Enemies/Ghost2.position.x = config.get_value("Ghost2", "ghost2_pos_x",$Enemies/Ghost2.position.x)
		#$Enemies/Ghost2.alive = config.get_value("Ghost2", "ghost2_alive", $Enemies/Ghost2.alive)
		#$Enemies/Ghost2/Stats.health = config.get_value("Ghost2", "ghost2_health", $Enemies/Ghost2/Stats.health)
		print("Game Loaded")
	else:
		print("Loading Failed")



