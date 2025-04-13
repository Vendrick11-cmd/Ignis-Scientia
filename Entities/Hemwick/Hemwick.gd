extends KinematicBody2D





export var FALLDAMAGE = 0
export var ATTACKSPEED = 350
export var ACCELERATION = 350
export var FRICTION = 1800
export var GRAVITY = 25
export var ROLLSPEED = 250
export var ADDITIONAL_FALL_GRAVITY = 6
export var entered_pick_up = false
export var air_attacked = false
export var push_force = 40
export var default_direction = Vector2.RIGHT
export var can_jump_hang = true


var reborn = false
var unleash_revive = false
var bandage_regen = false
var life_steal_on_hit = false
var is_blocking_left = false
var is_blocking_right = false
var is_facing_left = false
var is_facing_right = false
var motion = Vector2.ZERO
var roll_vectorR = Vector2.RIGHT
var roll_vectorL = Vector2.LEFT
var knockback = Vector2.ZERO
var Hostile = false





enum {
	PICKUP,
	BUFF,
	HEAL,
	ROLLFIGHT,
	FIGHT,
	ATTACKLIGHT,
	ATTACKHEAVY,
	AIRRANGEDATTACK,
	RANGEDATTACK,
	AIRATTACK,
	DASHATTACK,
	AIRATTACKSLAM,
	FIGHTDIE,
	BLOCK,
	BLOCKHIT,
	AIRCOMBO,
	COMBO,
	COMBO2,
	COMBO3,
	COMBO4,
	HEAVYCOMBO,
	SPECIAL,
	DASH,
	AIRDASH,
	HANG,
	REVIVE,
	REBIRTH
}

var state = FIGHT
onready var stats = PlayerStats
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var state_machine_dagger = $AnimationTree.get("parameters/Dagger/playback")
onready var state_machine_shortsword = $AnimationTree.get("parameters/Shortsword/playback")
onready var state_machine_shovel = $AnimationTree.get("parameters/Shovel/playback")
onready var state_machine_unarmed = $AnimationTree.get("parameters/Unarmed/playback")
onready var state_machine_magic = $AnimationTree.get("parameters/Magic/playback")
onready var state_machine_bow = $AnimationTree.get("parameters/Bow/playback")
onready var state_machine_sword = $AnimationTree.get("parameters/Sword/playback")
onready var enemies = get_tree().get_nodes_in_group("enemies")[0]
onready var player = get_tree().get_nodes_in_group("player")[0]


func _ready():
	if PlayerGlobal.SpawnPosX != 0 or PlayerGlobal.SpawnPosY != 0:
		global_position.x = PlayerGlobal.SpawnPosX
		global_position.y = PlayerGlobal.SpawnPosY

	#VOLUME EFFECTS MOD------------------------------------------------------------------------------------------------------------
	$Sounds/Effects/Dread/DreadOff.volume_db = -80
	$Sounds/Effects/Fire/FireOff.volume_db = -80

	#MAIN/DEBUG ------------------------------------------------------------------------------------------------------------------
	$Sounds/Effects/EnterTimer.start()
	$AnimationTree.active = true
	$HemwickSword/ElementDamage/Fire.visible = false
	#$GUI/ElementDamage.visible = true






func _process(_delta):

	_sounds()






func _physics_process(delta):

	#DEBUG-------------------------------------------------------------------------------------------------------------------------------------
	if state == ATTACKLIGHT or state == ATTACKHEAVY or state == DASHATTACK or state == COMBO or state == COMBO2 or state == COMBO3 or state == COMBO4 or state == HEAVYCOMBO:
		$"../Camera2D".smoothing_enabled = true
	else:
		$"../Camera2D".smoothing_enabled = false

	if PlayerGlobal.Current_Equipped == "bow":
		if  PlayerGlobal.slot1number > 0:
			$HemwickSword/AdditionalAssets/Arrow.visible = true
			if state == AIRRANGEDATTACK or state == RANGEDATTACK:
				$HemwickSword/AdditionalAssets/Arrow.visible = false
		else :
			$HemwickSword/AdditionalAssets/Arrow.visible = false
	else:
		$HemwickSword/AdditionalAssets/Arrow.visible = false

	if PlayerGlobal.slot1number > 0:
		PlayerGlobal.can_shoot = true
	else:
		PlayerGlobal.can_shoot = false


	$DebugStats/DaggerDamage/Label4.text = "%s" % [$HemwickSword/HitBoxDagger.damage]
	$DebugStats/Strength/Label.text = "%s" % [PlayerStats.initial_base_damage]
	$DebugStats/Jump/Label.text = "%s" % [PlayerGlobal.JUMPFORCE]
	$DebugStats/Speed/Label.text = "%s" % [PlayerGlobal.MAXSPEED]
	$DebugStats/StaminaFactor/Label.text = "%s" % [PlayerGlobal.stamina_factor]




	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)


	#MISC-------------------------------------------------------------------------------------------------------------------------------------
	if PlayerGlobal.undying == true:
		$HemwickSword/HurtBox/CollisionShape2D.disabled = true
	else:
		$HemwickSword/HurtBox/CollisionShape2D.disabled = false

	if PlayerGlobal.invis == true:
		$HemwickSword.visible = false
	else:
		$HemwickSword.visible = true

	if PlayerGlobal.buttonschemeactive == "none":
		$GUI/ButtonScheme/Fight.visible = false
		$GUI/ButtonScheme/Air.visible = false
		$GUI/ButtonScheme/OnWall.visible = false
	elif PlayerGlobal.buttonschemeactive == "fight":
		$GUI/ButtonScheme/Fight.visible = true
		$GUI/ButtonScheme/Air.visible = false
		$GUI/ButtonScheme/OnWall.visible = false
	elif PlayerGlobal.buttonschemeactive == "air":
		$GUI/ButtonScheme/Fight.visible = false
		$GUI/ButtonScheme/Air.visible = true
		$GUI/ButtonScheme/OnWall.visible = false
	elif PlayerGlobal.buttonschemeactive == "onwall":
		$GUI/ButtonScheme/Fight.visible = false
		$GUI/ButtonScheme/Air.visible = false
		$GUI/ButtonScheme/OnWall.visible = true

	if DialogueTimer.time_left == 0:
		PlayerGlobal.can_attack = true
	else:
		PlayerGlobal.can_attack = false

	if PlayerGlobal.in_vehicle == true:
		$HemwickSword/TorsoHead.visible = false
	else:
		$HemwickSword/TorsoHead.visible = true

	if PlayerGlobal.fire == true:
		$HemwickSword/TorsoHead.visible = false
	else:
		$HemwickSword/TorsoHead.visible = true

	if $HemwickSword.scale.x == 1:
		$Collision.position.x = 1.95
		$CollisionSlopes2.position.x =1.902
		$CollisionSlopes.position.x = 2.578
	elif $HemwickSword.scale.x == -1:
		$Collision.position.x = -1.209
		$CollisionSlopes2.position.x =-1.257
		$CollisionSlopes.position.x = -0.581

	if $FloorDetect.is_colliding():
		PlayerGlobal.is_on_floor = true
	else:
		PlayerGlobal.is_on_floor = false

	if $HemwickSword.scale.x ==1:
		$HemwickSword/Dust/DustAnim.play("RIGHT")
	else:
		$HemwickSword/Dust/DustAnim.play("LEFT")

	if PlayerGlobal.in_dialogue:
		$GUI.visible = false
	else:
		$GUI.visible = true


	$Crosshair.look_at(get_global_mouse_position())



	if $SlopeDetect.is_colliding() :
		$CollisionSlopes.disabled = false
		$CollisionSlopes2.disabled = false
		$Collision.disabled = true

	else:
		$CollisionSlopes.disabled = true
		$CollisionSlopes2.disabled = true
		$Collision.disabled = false


	if $HemwickSword.scale.x == 1:
		PlayerGlobal.is_facing_left = false
	elif $HemwickSword.scale.x == -1:
		PlayerGlobal.is_facing_left = true

	if state == BLOCK :
		PlayerGlobal.is_blocking = true
	else :
		PlayerGlobal.is_blocking = false





# DIALOGUE POSITION -------------------------------------------------------------------------------------------
	if $HemwickSword.scale.x == -1:
		$InnerDialogues/DialoguePos.play("Left")
	elif $HemwickSword.scale.x == 1:
		$InnerDialogues/DialoguePos.play("Right")
#ARMS -------------------------------------------------------------------------------------------------------------------
#print($AnimationPlayer.get_animation("FightMove").find_track(".:PlayerGlobal.MAXSPEED"))
	if PlayerSkills.Rogue == true :
		if PlayerGlobal.Current_Equipped in PlayerGlobal.DaggersWeapons:
			PlayerGlobal.MAXSPEED = 120
		else :
			PlayerGlobal.MAXSPEED = 100
	if PlayerSkills.Rogue == true and PlayerSkills.Agility == true:
		if PlayerGlobal.Current_Equipped in PlayerGlobal.DaggersWeapons:
			PlayerGlobal.MAXSPEED = 135
		else :
			PlayerGlobal.MAXSPEED = 100

	if PlayerGlobal.Current_Equipped == "unarmed":
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.unarmed_damage
		$ArmsChanger.play("Unarmed")

	if PlayerGlobal.Current_Equipped == "dagger":
		$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage
		$ArmsChanger.play("Dagger")

	if PlayerGlobal.Current_Equipped == "celeste":
		$HemwickSword/HitBoxShortSword.damage = PlayerStats.base_damage * PlayerGlobal.shortsword_damage
		$ArmsChanger.play("Celeste")

	if PlayerGlobal.Current_Equipped == "shovel" :
		$ArmsChanger.play("Shovel")
		$HemwickSword/HitBoxSpear.damage = PlayerStats.base_damage * PlayerGlobal.special_damage

	if PlayerGlobal.Current_Equipped == "fireball":
		$ArmsChanger.play("Magic-Fireball")
		$HemwickSword/Magic/Fireball/FireballAnim.play("On")
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.fireball_damage
	else:
		$HemwickSword/Magic/Fireball/FireballAnim.play("Off")

	if PlayerGlobal.Current_Equipped == "bow":
		$HemwickSword/HitBoxBow.damage = PlayerStats.base_damage * PlayerGlobal.bow_damage
		$ArmsChanger.play("Bow")

	if PlayerGlobal.Current_Equipped == "hemwicksword":
		$ArmsChanger.play("HemwickSword")
		$HemwickSword/HitBoxSword.damage = PlayerStats.base_damage * PlayerGlobal.hemwicksword_damage
#-------------------------------------------------------------------------------------------------------------------

#BANDAGE REGEN FEATURE -------------------------------------------------------------------------------------------------------
	if bandage_regen == true:
		$HemwickSword/CharacterEffects/BandageHeal/BandageHealAnim.play("Start")
		stats.health += 0.05
#LIFESTEAL FEATURE
	if life_steal_on_hit == true:
		stats.health += 0.03
#MANA REGEN
	if PlayerSkills.ManaRegen == true:
		stats.mana += 0.02
#-------------------------------------------------------------------------------------------------------------------

	if stats.health <= 0 :
		if state == ATTACKHEAVY or state == ATTACKLIGHT or state == ROLLFIGHT or state == FIGHT :
				if PlayerGlobal.SecondChance == true and reborn == false:
					state = REBIRTH
				else :
					state = FIGHTDIE

	if stats.health <= stats.max_health/5 and PlayerGlobal.Unleash == true and unleash_revive == false:
				state = REVIVE





	if state == BLOCK :
		if $HemwickSword.scale.x == -1 :
			is_blocking_left = true
			is_blocking_right = false
		elif $HemwickSword.scale.x == 1 :
			is_blocking_right = true
			is_blocking_left = false
	else :
		stats.stamina += PlayerGlobal.stamina_factor

	PlayerStats.health -= PlayerGlobal.poison_factor
	PlayerStats.health += PlayerGlobal.heal_factor
	if stats.armor > stats.max_armor *50:
		stats.armor = stats.max_armor *50
	if stats.health > stats.max_health :
		stats.health = stats.max_health
	if stats.mana > stats.max_mana:
		stats.mana = stats.max_mana
	if stats.living > stats.max_living :
		stats.living = stats.max_living
	if stats.stamina > stats.max_stamina :
		stats.stamina = stats.max_stamina
	if stats.stamina < 0 :
		stats.stamina = 0
	if stats.health <= stats.max_health / 4 and stats.health > 0 :
		$Visuals/VisualsAnim.play("LowHealth")
	else :
		$Visuals/VisualsAnim.play("Default")

# ELEMENTS DAMAGE -----------------------------------------------------------------------------------------------------------------
	# FIRE
	if PlayerGlobal.fire == true :
		if PlayerGlobal.FireProt == true:
			PlayerGlobal.TEMP += 0.025
		else:
			PlayerGlobal.TEMP += 0.1
	elif PlayerGlobal.fire == false and PlayerGlobal.TEMP > 0:
		PlayerGlobal.TEMP -= 0.1
		if PlayerGlobal.TEMP < 0:
			PlayerGlobal.TEMP = 0

	if PlayerGlobal.TEMP >= 10 :
		$HemwickSword/ElementDamage/ElementsAnim.play("Fire")
		$GUI/ElementDamage/Fire/FireAnim.play("Fire")
		if PlayerGlobal.FireProt == true:
			PlayerStats.health -= 0.025
		else :
			PlayerStats.health -= 0.05
		$Sounds/Effects/Fire/FireSoundAnim.play("On")
	else:

		$HemwickSword/ElementDamage/ElementsAnim.play("FireOff")
		$GUI/ElementDamage/Fire/FireAnim.play("FireOff")
		$Sounds/Effects/Fire/FireSoundAnim.play("Off")




	if PlayerDmgModif.DREAD > PlayerDmgModif.MAX_DREAD / 1.5 :

		$Sounds/Effects/Dread/DreadSoundAnim.play("On")
		$GUI/ElementDamage/Dread/DreadAnim.play("Dread")
		$HemwickSword/ElementDamage/Dread/DreadAnim.play("Dread")

	else:
		$Sounds/Effects/Dread/DreadSoundAnim.play("Off")
		$GUI/ElementDamage/Dread/DreadAnim.play("DreadOff")





	match state :
		AIRDASH:
			_airdash(delta)
		PICKUP :
			_pickup(delta)
		ROLLFIGHT :
			_rollfight_state(delta)
		FIGHT :
			_fight(delta)
		ATTACKLIGHT:
			_attacklight(delta)
		ATTACKHEAVY :
			_attackheavy(delta)
		AIRRANGEDATTACK:
			_airrangedattack(delta)
		RANGEDATTACK:
			_rangedattack(delta)
		AIRATTACK :
			_airattack(delta)
		DASHATTACK:
			_dashattack(delta)
		AIRATTACKSLAM :
			_airattackslam(delta)
		FIGHTDIE :
			_fightdie(delta)
		BLOCK :
			_block(delta)
		BLOCKHIT :
			_blockhit(delta)
		COMBO :
			_combo(delta)
		COMBO2:
			_combo2(delta)
		COMBO3:
			_combo3(delta)
		COMBO4:
			_combo4(delta)
		HEAVYCOMBO:
			_heavycombo(delta)
		SPECIAL:
			_attackspecial(delta)
		DASH:
			_dash(delta)
		HANG:
			_hang(delta)
		BUFF:
			_buff(delta)
		HEAL:
			_heal(delta)
		REVIVE:
			_revive(delta)
		REBIRTH:
			_rebirth(delta)

func _pickup(_delta):
	motion.x = 0
	state_machine.travel("PickUp")


func _fight(_delta) :


	PlayerGlobal.buttonschemeactive = "fight"

	if PlayerGlobal.in_dialogue == false and PlayerGlobal.alchemy == false:

		motion.y += GRAVITY
		if motion.y >= 350:
			motion.y = 350

		motion = move_and_slide(motion, Vector2.UP,true,4,0.785398,false)


		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("RigidBodies"):
				collision.collider.apply_central_impulse(-collision.normal * push_force)

		if $HemwickSword/PickUpRay.is_colliding() and Input.is_action_just_pressed("Interact"):
			state = PICKUP



		if Input.is_action_pressed("LEFT") :
				motion.x = -PlayerGlobal.MAXSPEED
				$HemwickSword.scale.x = -1
				state_machine.travel("FightMove")
				if PlayerGlobal.submerged == true:
					$HemwickSword/Dust/DustRun.emitting = false
				else: $HemwickSword/Dust/DustRun.emitting = true

		elif Input.is_action_pressed("RIGHT") :
				motion.x = PlayerGlobal.MAXSPEED
				$HemwickSword.scale.x = 1
				state_machine.travel("FightMove")
				if PlayerGlobal.submerged == true:
					$HemwickSword/Dust/DustRun.emitting = false
				else: $HemwickSword/Dust/DustRun.emitting = true
		else :
			$HemwickSword/Dust/DustRun.emitting = false
			state_machine.travel("Fight")
			motion.x = 0

		if Input.is_action_just_pressed("jump") and PlayerGlobal.has_jumped == false and stats.stamina > 10 and $FloorDetect.is_colliding():
			motion.y = -PlayerGlobal.JUMPFORCE
			PlayerGlobal.has_jumped = true
			stats.stamina -= 10

		if Input.is_action_just_pressed("HeavyAttack") and stats.stamina > 10 and $FloorDetect.is_colliding() and PlayerGlobal.Current_Equipped != "shovel":

			if PlayerGlobal.Current_Equipped == "dagger":
				state = ATTACKHEAVY
				stats.stamina -= PlayerGlobal.dagger_stamina *2
			elif PlayerGlobal.Current_Equipped == "celeste":
				state = ATTACKHEAVY
				stats.stamina -= PlayerGlobal.shortsword_stamina * 2
			elif PlayerGlobal.Current_Equipped == "unarmed" :
				state = ATTACKHEAVY
				stats.stamina -= PlayerGlobal.unarmed_stamina*2
			elif PlayerGlobal.Current_Equipped == "fireball" and stats.mana > 10:
				state = ATTACKHEAVY
				stats.stamina -= PlayerGlobal.unarmed_stamina*2
				stats.mana -= 7
			elif PlayerGlobal.Current_Equipped == "shovel":
				state = ATTACKHEAVY
				stats.stamina -= PlayerGlobal.shovel_stamina*2


		if Input.is_action_pressed("HeavyAttack") and stats.stamina > 10 and $FloorDetect.is_colliding() and PlayerGlobal.Current_Equipped in PlayerGlobal.RangedWeapons:
			if PlayerGlobal.can_shoot == true:
				state = RANGEDATTACK
			else : state = FIGHT


		if Input.is_action_just_pressed("LightAttack") and stats.stamina > 10 and $FloorDetect.is_colliding() and PlayerGlobal.can_attack == true:
			state = ATTACKLIGHT
		if Input.is_action_just_pressed("SpecialAttack") and $FloorDetect.is_colliding() :
			state = SPECIAL

		if !is_on_floor():
			$HemwickSword/Dust/DustRun.emitting = false
			if $HangR.is_colliding() or $HangL.is_colliding():
				if !$FloorHang.is_colliding():
					$HemwickSword/Dust/DustRun.emitting = false
					$HangTimer.start()
					state = HANG

			if motion.y < 0 or motion.y == 0 or motion.y > 0:
				if !is_on_floor() and !$HangL.is_colliding() and !$HangR.is_colliding():
					PlayerGlobal.buttonschemeactive = "air"
					if !$FloorDetect.is_colliding():
						state_machine.travel("FightJump")

					if Input.is_action_just_pressed("Dash") and 	PlayerGlobal.airdashed == false and stats.stamina > 10:
						state = AIRDASH
						PlayerGlobal.airdashed = true
						var anim = randi() % 2
						match anim:
							0:
								$Sounds/AirDash.play()
								$Sounds/AirDash.pitch_scale = rand_range(0.8,1.2)
							1:
								$Sounds/AirDash2.play()
								$Sounds/AirDash2.pitch_scale = rand_range(0.8,1.2)


					if Input.is_action_just_pressed("LightAttack") and stats.stamina > 10 and air_attacked == false and PlayerGlobal.Current_Equipped != "shovel":
						state = AIRATTACK
						if PlayerGlobal.submerged == true:
							$HemwickSword/Dust/DustAirAttack.emitting = false
						else: $HemwickSword/Dust/DustAirAttack.emitting = true

						if PlayerGlobal.Current_Equipped == "dagger":
							stats.stamina -= PlayerGlobal.dagger_stamina
						elif PlayerGlobal.Current_Equipped == "celeste":
							stats.stamina -= PlayerGlobal.shortsword_stamina
						elif PlayerGlobal.Current_Equipped == "unarmed" or PlayerGlobal.Current_Equipped == "fireball":
							stats.stamina -= PlayerGlobal.unarmed_stamina



					if Input.is_action_pressed("LightAttack") and stats.stamina >10 and air_attacked == false and PlayerGlobal.Current_Equipped in PlayerGlobal.RangedWeapons:
						state = AIRRANGEDATTACK

					if Input.is_action_pressed("DOwN") and Input.is_action_just_pressed("HeavyAttack") and PlayerGlobal.Slam == true and PlayerGlobal.Current_Equipped != "shovel":
						state = AIRATTACKSLAM

			if motion.y > 0 and !$FloorDetect.is_colliding():
				state_machine.travel("FightFall")


		else :
			PlayerGlobal.has_jumped = false
			PlayerGlobal.airdashed = false

		if is_on_floor() :
			if Input.is_action_just_pressed("Roll") and stats.stamina > 10:
				state = ROLLFIGHT
				stats.stamina -= 15
			if Input.is_action_just_pressed("Dash") and stats.stamina > 10 and PlayerGlobal.Dash == true:
				if PlayerGlobal.submerged == true:
					$HemwickSword/Dust/DustSlide.emitting = false
				else: $HemwickSword/Dust/DustSlide.emitting = true
				state = DASH
				stats.stamina -= 10
				var anim = randi() % 2
				match anim:
					0:
						$Sounds/Dash.play()
					1:
						$Sounds/Dash2.play()


			if Input.is_action_just_pressed("Buff"):
				state = BUFF
			if Input.is_action_just_pressed("Heal"):
				state = HEAL
	else:
		state_machine.travel("Fight")
func _roll_animation_finished():
	if state == ROLLFIGHT :
		state = FIGHT
	if state == DASH:
		state = FIGHT
	if state == DASHATTACK:
		state = FIGHT
	if state == REVIVE:
		state = FIGHT
	if state == PICKUP:
		state = FIGHT
	if state == AIRDASH:
		state = FIGHT

func _attack_combo():
	state = COMBO

func _attack_finish():
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED
		$HemwickSword.scale.x = -1
	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED

		$HemwickSword.scale.x = 1
	else :
		motion.x = 0

	if $ComboTimerDgr.time_left < 0.05 :
		state = FIGHT



func _attacklight(_delta) :
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED
	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED
	else :
		motion.x = 0

	if PlayerGlobal.Current_Equipped == "dagger":
		state_machine.travel("Dagger")
		state_machine_dagger.travel("DgrAttackL")
	elif PlayerGlobal.Current_Equipped == "celeste":
		state_machine.travel("Shortsword")
		state_machine_shortsword.travel("ShortswordAttackL")
	elif PlayerGlobal.Current_Equipped == "hemwicksword":
		state_machine.travel("Sword")
		state_machine_sword.travel("SwordAttackL")
	elif PlayerGlobal.Current_Equipped == "shovel":
		state_machine.travel("Shovel")
		state_machine_shovel.travel("SpearAttackL")
	elif PlayerGlobal.Current_Equipped == "unarmed":
		state_machine.travel("Unarmed")
		state_machine_unarmed.travel("UnarmedAttackL")
	elif PlayerGlobal.Current_Equipped == "fireball":
		state_machine.travel("Magic")
		state_machine_magic.travel("MagicAttackL")
	elif PlayerGlobal.Current_Equipped == "bow":
		state_machine.travel("Bow")
		state_machine_bow.travel("BowAttackL")

func _heavycombo(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED
	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED
	else :
		motion.x = 0

	if PlayerGlobal.Current_Equipped == "dagger":
		if PlayerSkills.CriticalStrike == true:
			if randf() < 0.9:
				$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage *2 +2.5
			else :
				$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage + 2.5
		else:
			$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage + 2.5
		state_machine_dagger.travel("DgrAttackHCombo")

	elif PlayerGlobal.Current_Equipped == "shovel":
		$HemwickSword/HitBoxSpear.damage = PlayerStats.base_damage * PlayerGlobal.special_damage + 5
		state_machine_shovel.travel("SpearAttackHCombo")

	elif PlayerGlobal.Current_Equipped == "unarmed":
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.unarmed_damage + 1
		state_machine_unarmed.travel("UnarmedAttackHCombo")

func _combo(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED

	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED

	else :
		motion.x = 0


	if $ComboTimerDgr.time_left > 0.05 :
		if Input.is_action_just_pressed("LightAttack") and stats.stamina > 10:
			state = COMBO2
			if PlayerGlobal.Current_Equipped == "dagger":
				state_machine_dagger.travel("DgrAttackL2")
			elif PlayerGlobal.Current_Equipped == "celeste":
				state_machine_shortsword.travel("ShortswordAttackL2")
			elif PlayerGlobal.Current_Equipped == "shovel":
				state_machine_shovel.travel("SpearAttackL2")
			elif PlayerGlobal.Current_Equipped == "unarmed":
				state_machine_unarmed.travel("UnarmedAttackL2")
			elif PlayerGlobal.Current_Equipped == "fireball":
				state_machine_magic.travel("MagicAttackL2")

	else :
		state = FIGHT
		if Input.is_action_pressed("RIGHT") or Input.is_action_pressed("LEFT"):
			state_machine.travel("FightIdleMove")
			state_machine_unarmed.travel("FightIdleMove")
			state_machine_shovel.travel("FightIdleMove")
			state_machine_dagger.travel("FightIdleMove")
			state_machine_magic.travel("FightIdleMove")
			state_machine_shortsword.travel("FightIdleMove")
			state_machine_sword.travel("FightIdleMove")


func _combo2(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED

	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED

	else :
		motion.x = 0


	if $ComboTimerDgr.time_left > 0.05 :
		if PlayerGlobal.ThreeCombo == true:
			if Input.is_action_just_pressed("LightAttack"):
				state = COMBO3
				if PlayerGlobal.Current_Equipped == "dagger":
					state_machine_dagger.travel("DgrAttackL3")
				elif PlayerGlobal.Current_Equipped == "celeste":
					state_machine_shortsword.travel("ShortswordAttackL3")
				elif PlayerGlobal.Current_Equipped == "shovel":
					state_machine_shovel.travel("SpearAttackL3")
				elif PlayerGlobal.Current_Equipped == "unarmed":
					state_machine_unarmed.travel("UnarmedAttackL3")
		if Input.is_action_just_pressed("HeavyAttack") and PlayerGlobal.HeavyChain == true and PlayerGlobal.Current_Equipped != "celeste":
			if PlayerGlobal.Current_Equipped == "dagger":
				stats.stamina -= PlayerGlobal.dagger_stamina *2
			elif PlayerGlobal.Current_Equipped == "unarmed":
				stats.stamina -= PlayerGlobal.unarmed_stamina*2
			elif PlayerGlobal.Current_Equipped == "shovel":
				stats.stamina -= PlayerGlobal.shovel_stamina*2
			state = HEAVYCOMBO


	else :
		state = FIGHT
		if Input.is_action_pressed("RIGHT") or Input.is_action_pressed("LEFT"):
			state_machine.travel("FightIdleMove")
			state_machine_unarmed.travel("FightIdleMove")
			state_machine_shovel.travel("FightIdleMove")
			state_machine_dagger.travel("FightIdleMove")
			state_machine_shortsword.travel("FightIdleMove")
			state_machine_sword.travel("FightIdleMove")


func _combo3(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED

	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED

	else :
		motion.x = 0


	if $ComboTimerDgr.time_left > 0.05 :
		if PlayerGlobal.FiveCombo == true:
			if Input.is_action_just_pressed("LightAttack"):
				state = COMBO4
				if PlayerGlobal.Current_Equipped == "dagger":
					state_machine_dagger.travel("DgrAttackL4")
				elif PlayerGlobal.Current_Equipped == "celeste":
					state_machine_shortsword.travel("ShortswordAttackL4")
				elif PlayerGlobal.Current_Equipped == "shovel":
					state_machine_shovel.travel("SpearAttackL4")
				elif PlayerGlobal.Current_Equipped == "unarmed":
					state_machine_unarmed.travel("UnarmedAttackL4")
		if Input.is_action_just_pressed("HeavyAttack") and PlayerGlobal.HeavyChain == true and PlayerGlobal.Current_Equipped != "celeste":
			if PlayerGlobal.Current_Equipped == "dagger":
				stats.stamina -= PlayerGlobal.dagger_stamina *2
			elif PlayerGlobal.Current_Equipped == "unarmed":
				stats.stamina -= PlayerGlobal.unarmed_stamina*2
			elif PlayerGlobal.Current_Equipped == "shovel":
				stats.stamina -= PlayerGlobal.shovel_stamina*2
			state = HEAVYCOMBO

	else :
		state = FIGHT
		if Input.is_action_pressed("RIGHT") or Input.is_action_pressed("LEFT"):
			state_machine.travel("FightIdleMove")
			state_machine_unarmed.travel("FightIdleMove")
			state_machine_shovel.travel("FightIdleMove")
			state_machine_dagger.travel("FightIdleMove")
			state_machine_shortsword.travel("FightIdleMove")
			state_machine_sword.travel("FightIdleMove")

func _combo4(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED

	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED

	else :
		motion.x = 0


	if $ComboTimerDgr.time_left > 0.05 :
		if Input.is_action_just_pressed("LightAttack"):
			if PlayerGlobal.Current_Equipped == "dagger":
				state_machine_dagger.travel("DgrAttackL5")
			elif PlayerGlobal.Current_Equipped == "celeste":
				state_machine_shortsword.travel("ShortswordAttackL5")
			elif PlayerGlobal.Current_Equipped == "shovel":
				state_machine_shovel.travel("SpearAttackL5")
			elif PlayerGlobal.Current_Equipped == "unarmed":
				state_machine_unarmed.travel("UnarmedAttackL5")
	else :
		state = FIGHT
		if Input.is_action_pressed("RIGHT") or Input.is_action_pressed("LEFT"):
			state_machine.travel("FightIdleMove")
			state_machine_unarmed.travel("FightIdleMove")
			state_machine_shovel.travel("FightIdleMove")
			state_machine_dagger.travel("FightIdleMove")
			state_machine_shortsword.travel("FightIdleMove")
			state_machine_sword.travel("FightIdleMove")

func _combotimeradd():
	if PlayerGlobal.Current_Equipped == "unarmed" or PlayerGlobal.Current_Equipped == "fireball":
		stats.stamina -= PlayerGlobal.unarmed_stamina
		$ComboTimerDgr.start(0.45)
	if PlayerGlobal.Current_Equipped in PlayerGlobal.DaggersWeapons:
		stats.stamina -= PlayerGlobal.dagger_stamina
		$ComboTimerDgr.start(0.5)
	elif PlayerGlobal.Current_Equipped in PlayerGlobal.SpecialWeapons:
		stats.stamina -= PlayerGlobal.shovel_stamina
		$ComboTimerDgr.start(0.7)
	elif PlayerGlobal.Current_Equipped in PlayerGlobal.ShortSwordsWeapons:
		$ComboTimerDgr.start(0.7)
		stats.stamina -= PlayerGlobal.shortsword_stamina
	elif PlayerGlobal.Current_Equipped in PlayerGlobal.SwordWeapons:
		$ComboTimerDgr.start(0.6)
		stats.stamina -= PlayerGlobal.hemwicksword_stamina

func _rollfight_state(_delta) :

	motion.y += GRAVITY * 7
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if $HemwickSword.scale.x == 1 :
		if PlayerGlobal.submerged == true:
			motion = roll_vectorR * ROLLSPEED /3.6
		else:
			motion = roll_vectorR * ROLLSPEED /1.2
	elif $HemwickSword.scale.x == -1:
		if PlayerGlobal.submerged == true:
			motion = roll_vectorL * ROLLSPEED /3.6
		else:
			motion = roll_vectorL * ROLLSPEED /1.2
	state_machine.travel("RollFight")

func _dash(_delta):


	motion.y += GRAVITY * 7
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	state_machine.travel("Dash")
	if Input.is_action_pressed("RIGHT"):
		if PlayerGlobal.submerged == true:
			motion = roll_vectorR * ROLLSPEED /4.5
		else: motion = roll_vectorR * ROLLSPEED /1.5
		$HemwickSword.scale.x = 1
	elif Input.is_action_pressed("LEFT"):
		if PlayerGlobal.submerged == true:
			motion = roll_vectorL * ROLLSPEED /4.5
		else: motion = roll_vectorL * ROLLSPEED /1.5
		$HemwickSword.scale.x = -1
	elif $HemwickSword.scale.x == 1:
		if PlayerGlobal.submerged == true:
			motion = roll_vectorR * ROLLSPEED /4.5
		else: motion = roll_vectorR * ROLLSPEED /1.5
	elif $HemwickSword.scale.x == -1:
		if PlayerGlobal.submerged == true:
			motion = roll_vectorL * ROLLSPEED /4.5
		else:motion = roll_vectorL * ROLLSPEED /1.5


	if Input.is_action_pressed("LightAttack") or Input.is_action_just_pressed("LightAttack"):
		if PlayerGlobal.Current_Equipped in PlayerGlobal.DaggersWeapons and PlayerSkills.InscrutableRush == true:
			state = DASHATTACK

func _airdash(_delta):
	motion.y = GRAVITY
	motion = move_and_slide(motion, Vector2.UP)
	state_machine.travel("DashAir")


	if $HemwickSword.scale.x == 1:

		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /3

		else:
			motion.x = ATTACKSPEED /1.5

	if $HemwickSword.scale.x == -1:
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /3
		else:
			motion.x = -ATTACKSPEED /1.5









func _hang(_delta):
	PlayerGlobal.airdashed = false
	PlayerGlobal.buttonschemeactive = "onwall"
	motion.y += 4
	if motion.y >= 350:
		motion.y = 350


	state_machine.travel("Hang")
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)
	#motion = move_and_slide_with_snap(motion,Vector2.UP)


	if $HangL.is_colliding():
		$HemwickSword.scale.x = 1
		motion.y = 10
	elif $HangR.is_colliding():
		$HemwickSword.scale.x = -1
		motion.y = 10


	if $WallDetect.is_colliding():
		motion.y =  $WallDetect.get_collider().PlayerGlobal.MAXSPEED




	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)








	if can_jump_hang == true:
		if Input.is_action_just_pressed("jump") and stats.stamina > 10:
			$HangTimer.start()
			stats.stamina -= 10
			if $HangL.is_colliding():
				$HangL.enabled = false
				$HangR.enabled = true
				motion.y = -PlayerGlobal.JUMPFORCE - 80
			if $HangR.is_colliding():
				$HangR.enabled = false
				$HangL.enabled = true
				motion.y = -PlayerGlobal.JUMPFORCE - 80
			state = FIGHT
		elif Input.is_action_just_pressed("RIGHT") or Input.is_action_just_pressed("LEFT"):
			state = FIGHT
			if $HemwickSword.scale.x == 1:
				$HangL.enabled = false
				$HangR.enabled = true
			if $HemwickSword.scale.x == -1:
				$HangL.enabled = true
				$HangR.enabled = false

	if $FloorDetect.is_colliding():
		state = FIGHT
		$HangL.enabled = false
		$HangR.enabled = false
	elif !$HangL.is_colliding() and !$HangR.is_colliding():
		state = FIGHT






func _on_HurtBox_area_entered(area):

	if area.Hostile == true and !state == ROLLFIGHT and !state == BLOCK and !state == BLOCKHIT and !state == ATTACKHEAVY and !state == ATTACKLIGHT and !state == REVIVE and $AnimationPlayer.current_animation != "Hurt":
		if area.global_position.x < $HemwickSword/HurtBox.global_position.x:
			if area.damage > 10:
				knockback = Vector2.RIGHT * 30 * area.damage/2
			else:
				knockback = Vector2.RIGHT * 30 * area.damage
			motion.y = -300
		elif area.global_position.x > $HemwickSword/HurtBox.global_position.x:
			if area.damage > 10:
				knockback = Vector2.LEFT * 30 * area.damage/2
			else:
				knockback = Vector2.LEFT * 30 * area.damage
			motion.y = -300
	elif area.Hostile == true and state == BLOCK or state == BLOCKHIT:
		if area.global_position.x < $HemwickSword/HurtBox.global_position.x:
			if area.damage > 10:
				knockback = Vector2.RIGHT * 15 * area.damage/2
			else:
				knockback = Vector2.RIGHT * 15 * area.damage
			if $HemwickSword.scale.x == 1:
				if area.damage > 10:
					knockback = Vector2.RIGHT * 30 * area.damage/2
				else:
					knockback = Vector2.RIGHT * 30 * area.damage
				motion.y = -300
		elif area.global_position.x > $HemwickSword/HurtBox.global_position.x:
			knockback = Vector2.LEFT * 15 * area.damage
			if $HemwickSword.scale.x == -1:
				knockback = Vector2.LEFT * 30 * area.damage
				motion.y = -300


	if !state == REVIVE:
		$Sounds/Hurt.play()
		$AnimationPlayer.play("Hurt")
		stats.health -= area.damage
		stats.armor -= area.damage *3
		frameFreeze(0.3, 0.2)
		#PlayerGlobal.camera.shake(400,0.2,900)
		$Visuals/VisualsAnim.play("Blood")
		$HemwickSword/HurtBox.hurteffect_show = true
		if stats.armor > 0:
			stats.health += stats.armor/50
		if PlayerSkills.Riposte == true and state != DASHATTACK:
			if randf() < 0.2:
				state = DASHATTACK
				if area.global_position.x < $HemwickSword/HurtBox.global_position.x:
					$HemwickSword.scale.x = -1
				elif area.global_position.x > $HemwickSword/HurtBox.global_position.x:
					$HemwickSword.scale.x = 1
				PlayerStats.initial_base_damage += 1
				$DashAttackTimer.start()



	if PlayerGlobal.Bandage == true:
		if randf() < 0.2:
			$RegenLifeTimer.start()
			bandage_regen = true







func _attackspecial(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED
	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED
	else :
		motion.x = 0

	state_machine.travel("DgrSpecial")

func _attackheavy(_delta) :
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if Input.is_action_pressed("LEFT") :
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED
	elif Input.is_action_pressed("RIGHT") :
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED
	else :
		motion.x = 0

	if PlayerGlobal.Current_Equipped == "dagger":
		if PlayerSkills.CriticalStrike == true:
			if randf() < 0.9:
				$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage *2 +2.5
			else :
				$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage + 2.5
		else:
			$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage + 2.5
		var anim = randi() % 2
		match anim:
			0:
				state_machine.travel("Dagger")
				state_machine_dagger.travel("DgrAttackH")
			1:
				state_machine.travel("Dagger")
				state_machine_dagger.travel("DgrAttackH2")

	elif PlayerGlobal.Current_Equipped == "shovel":
		$HemwickSword/HitBoxSpear.damage = PlayerStats.base_damage * PlayerGlobal.special_damage + 5
		var anim = randi() % 2
		match anim:
			0:
				state_machine.travel("Shovel")
				state_machine_shovel.travel("SpearAttackH")
			1:
				state_machine.travel("Shovel")
				state_machine_shovel.travel("SpearAttackH2")

	elif PlayerGlobal.Current_Equipped == "celeste":
		$HemwickSword/HitBoxShortSword.damage = PlayerStats.base_damage * PlayerGlobal.shortsword_damage + 5
		var anim = randi() % 2
		match anim:
			0:
				state_machine.travel("Shortsword")
				state_machine_shortsword.travel("ShortswordAttackH")
			1:
				state_machine.travel("Shortsword")
				state_machine_shortsword.travel("ShortswordAttackH2")

	elif PlayerGlobal.Current_Equipped == "hemwicksword":
		$HemwickSword/HitBoxSword.damage = PlayerStats.base_damage * PlayerGlobal.hemwicksword_damage + 5
		var anim = randi() % 2
		match anim:
			0:
				state_machine.travel("Sword")
				state_machine_sword.travel("SwordAttackH")
			1:
				state_machine.travel("Sword")
				state_machine_sword.travel("SwordAttackH2")


	elif PlayerGlobal.Current_Equipped == "unarmed":
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.unarmed_damage + 1
		var anim = randi() % 2
		match anim:
			0:
				state_machine.travel("Unarmed")
				state_machine_unarmed.travel("UnarmedAttackH2")
			1:
				state_machine.travel("Unarmed")
				state_machine_unarmed.travel("UnarmedAttackH3")


	elif PlayerGlobal.Current_Equipped == "fireball":
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.fireball_damage + 2
		state_machine.travel("Magic")
		state_machine_magic.travel("MagicThrow")
		if !get_global_mouse_position().x > global_position.x and $HemwickSword.scale.x == -1 or !get_global_mouse_position().x < global_position.x and $HemwickSword.scale.x == 1:
			if $HemwickSword.scale.x == 1:
				$Crosshair.rotation_degrees = clamp($Crosshair.rotation_degrees, -90, 90)
			elif $HemwickSword.scale.x == -1:
				$Crosshair.rotation_degrees = clamp($Crosshair.rotation_degrees, -270, -90)



func _dashattack(_delta):
	$ComboTimerDgr.start(0.3)
	air_attacked = true
	motion.y = GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if $HemwickSword.scale.x == 1:
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /4
		else:
			motion.x = ATTACKSPEED + 150
	if $HemwickSword.scale.x == -1:
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /4
		else:
			motion.x = -ATTACKSPEED - 150

	state_machine.travel("DashAttack")

func _airattackslam(_delta):
	motion.y = GRAVITY * 20
	motion.x = 0
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if !$FloorDetect.is_colliding():
		if PlayerGlobal.Current_Equipped == "dagger":
			$HemwickSword/HitBoxSpecial.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage
			state_machine.travel("DgrAttackAirHTravel")
		elif PlayerGlobal.Current_Equipped == "shovel":
			$HemwickSword/HitBoxSpear.damage = PlayerStats.base_damage * PlayerGlobal.special_damage
			state_machine.travel("SpearAttackSlam")
		elif PlayerGlobal.Current_Equipped == "unarmed":
			$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.unarmed_damage
			state_machine.travel("UnarmedAttackSlam")
		elif PlayerGlobal.Current_Equipped == "fireball":
			$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.fireball_damage
			state_machine.travel("MagicAttackSlam")
		elif PlayerGlobal.Current_Equipped == "celeste":
			$HemwickSword/HitBoxShortSword.damage = PlayerStats.base_damage * PlayerGlobal.shortsword_damage
			state_machine.travel("ShortswordAttackSlam")
		elif PlayerGlobal.Current_Equipped == "hemwicksword":
			$HemwickSword/HitBoxSword.damage = PlayerStats.base_damage * PlayerGlobal.hemwicksword_damage
			state_machine.travel("SwordAttackSlam")
	else :
		$HemwickSword/Dust/DustSlam.emitting = true
		if PlayerGlobal.Current_Equipped == "dagger":
			$HemwickSword/HitBoxSpecial.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage * 2
			state_machine.travel("DgrAttackAirHLand")
		elif PlayerGlobal.Current_Equipped == "shovel":
			$HemwickSword/HitBoxSpecial.damage = PlayerStats.base_damage * PlayerGlobal.special_damage * 2
			state_machine.travel("SpearAttackSlamLand")
		elif PlayerGlobal.Current_Equipped == "unarmed":
			$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.unarmed_damage * 2
			state_machine.travel("UnarmedAttackSlamLand")
		elif PlayerGlobal.Current_Equipped == "fireball":
			$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.fireball_damage * 2
			state_machine.travel("MagicAttackSlamLand")
		elif PlayerGlobal.Current_Equipped == "celeste":
			$HemwickSword/HitBoxShortSword.damage = PlayerStats.base_damage * PlayerGlobal.shortsword_damage * 2
			state_machine.travel("ShortswordAttackSlamLand")
		elif PlayerGlobal.Current_Equipped == "hemwicksword":
			$HemwickSword/HitBoxSword.damage = PlayerStats.base_damage * PlayerGlobal.hemwicksword_damage * 2
			state_machine.travel("SwordAttackSlamLand")


func _airattack(_delta) :
	air_attacked = true
	motion.y = GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	if $HemwickSword.scale.x == 1:
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED /2
		else:
			motion.x = ATTACKSPEED + 50
	if $HemwickSword.scale.x == -1:
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED /2
		else:
			motion.x = -ATTACKSPEED - 50
	if PlayerGlobal.Current_Equipped == "dagger":
		$HemwickSword/HitBoxDagger.damage = PlayerStats.base_damage * PlayerGlobal.dagger_damage
		state_machine.travel("DgrAttackAir")
	elif PlayerGlobal.Current_Equipped == "shovel" :
		$HemwickSword/HitBoxSpear.damage = PlayerStats.base_damage * PlayerGlobal.special_damage
		state_machine.travel("SpearAttackAir")
	elif PlayerGlobal.Current_Equipped == "unarmed":
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.unarmed_damage
		state_machine.travel("UnarmedAttackAir")
	elif PlayerGlobal.Current_Equipped == "fireball":
		$HemwickSword/HitBoxUnarmed.damage = PlayerStats.base_damage * PlayerGlobal.fireball_damage
		state_machine.travel("MagicAttackAir")
	elif PlayerGlobal.Current_Equipped == "celeste":
		$HemwickSword/HitBoxShortSword.damage = PlayerStats.base_damage * PlayerGlobal.shortsword_damage
		state_machine.travel("ShortswordAttackAir")
	elif PlayerGlobal.Current_Equipped == "hemwicksword":
		$HemwickSword/HitBoxSword.damage = PlayerStats.base_damage * PlayerGlobal.hemwicksword_damage
		state_machine.travel("SwordAttackAir")

func _airrangedattack(_delta):
	air_attacked = true
	motion.y = 5
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)


	if $HemwickSword.scale.x == 1:
		if PlayerGlobal.submerged == true:
			motion.x = ATTACKSPEED / 3
		else:
			motion.x = ATTACKSPEED + 140
	if $HemwickSword.scale.x == -1:
		if PlayerGlobal.submerged == true:
			motion.x = -ATTACKSPEED / 3
		else:
			motion.x = -ATTACKSPEED - 140

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)



	state_machine.travel("BowAttackAir")

	if PlayerGlobal.can_shoot and !PlayerGlobal.slot1 == "none":
		stats.stamina -= 0.25
		$HemwickSword/AdditionalAssets/Bow/BowAnim.play("DrawAir")
	else:
		state = FIGHT








	if $HemwickSword.scale.x == 1:
		$Crosshair.rotation_degrees = clamp($Crosshair.rotation_degrees, -60, 60)

		$HemwickSword/Accessories/Hat.rotation_degrees = $Crosshair.rotation_degrees / 4
		$HemwickSword/AdditionalAssets/Bow/RightHand.rotation_degrees = $Crosshair.rotation_degrees
		$HemwickSword/AdditionalAssets/Bow/RightHand.scale.x =1


	else:
		$Crosshair.rotation_degrees = clamp($Crosshair.rotation_degrees, 120, 240)

		$HemwickSword/Accessories/Hat.rotation_degrees = -$Crosshair.rotation_degrees / 4 +40
		$HemwickSword/AdditionalAssets/Bow/RightHand.rotation_degrees = -$Crosshair.rotation_degrees
		$HemwickSword/AdditionalAssets/Bow/RightHand.scale.x =-1





func _rangedattack(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)



	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)


	motion.x = 0
	state_machine.travel("Bow")
	state_machine_bow.travel("BowAttackH")


	if PlayerGlobal.slot1number >= 0 :
		if Input.is_action_pressed("LightAttack") and PlayerGlobal.can_shoot == true:
			stats.stamina -= 0.25
			if stats.stamina <= 10:
				$HemwickSword/AdditionalAssets/Bow/BowAnim.play("Shoot")
				PlayerGlobal.can_shoot = false
			if PlayerGlobal.can_shoot == true and $HemwickSword/AdditionalAssets/Bow/BowAnim.current_animation != "Shoot":
				$HemwickSword/AdditionalAssets/Bow/BowAnim.play("Draw")


		if Input.is_action_just_released("LightAttack") and PlayerGlobal.can_shoot == true:


			$HemwickSword/AdditionalAssets/Bow/BowAnim.play("Shoot")
			PlayerGlobal.can_shoot = false
	else:
		state = FIGHT

	if $HemwickSword.scale.x == 1:
		$Crosshair.rotation_degrees = clamp($Crosshair.rotation_degrees, -60, 60)

		$HemwickSword/Accessories/Hat.rotation_degrees = $Crosshair.rotation_degrees / 4
		$HemwickSword/AdditionalAssets/Bow/RightHand.rotation_degrees = $Crosshair.rotation_degrees
		$HemwickSword/AdditionalAssets/Bow/RightHand.scale.x =1


	else:
		$Crosshair.rotation_degrees = clamp($Crosshair.rotation_degrees, 120, 240)

		$HemwickSword/Accessories/Hat.rotation_degrees = -$Crosshair.rotation_degrees / 4 +40
		$HemwickSword/AdditionalAssets/Bow/RightHand.rotation_degrees = -$Crosshair.rotation_degrees
		$HemwickSword/AdditionalAssets/Bow/RightHand.scale.x =-1




	if Input.is_action_just_released("HeavyAttack"):
		$HemwickSword/AdditionalAssets/Bow._speedreset()
		state = FIGHT
		state_machine_bow.travel("Fight")
		state_machine.travel("Fight")






func _fightdie(_delta) :
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	state_machine.travel("FightDie")
	if is_on_floor() :
		set_physics_process(false)
func _block(_delta) :


	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)




	if Input.is_action_pressed("LEFT") :
		motion.x = -PlayerGlobal.MAXSPEED
		$HemwickSword.scale.x = -1
		state_machine.travel("BlockMove")

	elif Input.is_action_pressed("RIGHT") :
		motion.x = PlayerGlobal.MAXSPEED
		$HemwickSword.scale.x = 1
		state_machine.travel("BlockMove")
	else :
		state_machine.travel("Block")
		motion.x = 0

	if Input.is_action_just_released("Block") :
		state = FIGHT

	if Input.is_action_just_pressed("LightAttack") :
		if PlayerGlobal.sword == true :
			stats.stamina -= 15
		elif PlayerGlobal.spear == true :
			stats.stamina -= 17
		elif PlayerGlobal.Current_Equipped == "dagger" :
			stats.stamina -= 8
		state = ATTACKLIGHT
	if Input.is_action_just_pressed("HeavyAttack") :
		if PlayerGlobal.sword == true :
			stats.stamina -= 30
		elif PlayerGlobal.spear == true :
			stats.stamina -= 32
		elif PlayerGlobal.Current_Equipped == "dagger" :
			stats.stamina -= 20
		state = ATTACKHEAVY
	if stats.health <= 0 :
		state = FIGHTDIE
func _blockhit(_delta) :
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	state_machine.travel("BlockHit")
	if stats.health <= 0 :
		state = FIGHTDIE

func _blockhit_finished() :
	state = FIGHT



func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1


func _on_HitBox_area_entered(_area):
	if PlayerGlobal.Current_Equipped != "shovel":
		frameFreeze(0.1, 0.3)
		PlayerGlobal.camera.shake(400,0.1,100)
		if PlayerGlobal.LifeSteal == true:
			if randf() < 0.05:
				life_steal_on_hit = true
				$LifeStealTimer.start()
	else:
		PlayerGlobal.harvested = true
		var InstanceDirt = preload("res://Entities/Hemwick/Hoe/DirtSplash.tscn")
		var instanceDirt = InstanceDirt.instance()
		add_child(instanceDirt)
		instanceDirt.global_position = $HemwickSword/HitBoxHoe.global_position




	if PlayerGlobal.Current_Equipped in PlayerGlobal.DaggersWeapons:
		var anim = randi() % 10
		match anim:
			0:
				$HemwickSword/HitSounds/Daggers/HitDagger.play()
			1:
				$HemwickSword/HitSounds/Daggers/HitDagger2.play()
			2:
				$HemwickSword/HitSounds/Daggers/HitDagger3.play()
			3:
				$HemwickSword/HitSounds/Daggers/HitDagger4.play()
			4:
				$HemwickSword/HitSounds/Daggers/HitDagger5.play()
			5:
				$HemwickSword/HitSounds/Daggers/HitDagger6.play()
			6:
				$HemwickSword/HitSounds/Daggers/HitDagger7.play()
			7:
				$HemwickSword/HitSounds/Daggers/HitDagger8.play()
			8:
				$HemwickSword/HitSounds/Daggers/HitDagger9.play()
			9:
				$HemwickSword/HitSounds/Daggers/HitDagger10.play()

	if PlayerGlobal.Current_Equipped in PlayerGlobal.SwordWeapons:
		var anim = randi() % 5
		match anim:
			0:
				$HemwickSword/HitSounds/Shortswords/HitShortsword.play()
			1:
				$HemwickSword/HitSounds/Shortswords/HitShortsword2.play()
			2:
				$HemwickSword/HitSounds/Shortswords/HitShortsword3.play()
			3:
				$HemwickSword/HitSounds/Shortswords/HitShortsword4.play()
			4:
				$HemwickSword/HitSounds/Shortswords/HitShortsword5.play()

	if PlayerGlobal.Current_Equipped in PlayerGlobal.ShortSwordsWeapons:
		var anim = randi() % 11
		match anim:
			0:
				$HemwickSword/HitSounds/Swords/HitSword.play()
			1:
				$HemwickSword/HitSounds/Swords/HitSword2.play()
			2:
				$HemwickSword/HitSounds/Swords/HitSword3.play()
			3:
				$HemwickSword/HitSounds/Swords/HitSword4.play()
			4:
				$HemwickSword/HitSounds/Swords/HitSword5.play()
			5:
				$HemwickSword/HitSounds/Swords/HitSword6.play()
			6:
				$HemwickSword/HitSounds/Swords/HitSword7.play()
			7:
				$HemwickSword/HitSounds/Swords/HitSword8.play()
			8:
				$HemwickSword/HitSounds/Swords/HitSword9.play()
			9:
				$HemwickSword/HitSounds/Swords/HitSword10.play()
			10:
				$HemwickSword/HitSounds/Swords/HitSword11.play()

	if PlayerGlobal.Current_Equipped in PlayerGlobal.SpecialWeapons:

		var anim = randi() % 5
		match anim:
			0:
				$HemwickSword/HitSounds/Blunt/HitBlunt.play()
			1:
				$HemwickSword/HitSounds/Blunt/HitBlunt2.play()
			2:
				$HemwickSword/HitSounds/Blunt/HitBlunt3.play()
			3:
				$HemwickSword/HitSounds/Blunt/HitBlunt4.play()
			4:
				$HemwickSword/HitSounds/Blunt/HitBlunt5.play()
			5:
				$HemwickSword/HitSounds/Blunt/HitBlunt6.play()
			6:
				$HemwickSword/HitSounds/Blunt/HitBlunt7.play()
			7:
				$HemwickSword/HitSounds/Blunt/HitBlunt8.play()










func _buff(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	state_machine.travel("Buff")

func _heal(_delta):
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2.UP,false,4,0.785398,false)

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	state_machine.travel("Heal")

func _revive(_delta):
	motion.y += GRAVITY
	if motion.y >= 400 :
		motion.y = 400

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	state_machine.travel("Revive")
	unleash_revive = true
	stats.health = stats.max_health/3

func _rebirth(_delta):
	motion.y += GRAVITY
	if motion.y >= 400 :
		motion.y = 400

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("RigidBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push_force)

	reborn = true
	stats.health = stats.max_health / 2


func _sounds() :
	_type_of_floor()



func _type_of_floor() :
	if $TypeOfFloorDetect/Concrete.is_colliding() :
		PlayerGlobal.on_concrete = true
	else :
		PlayerGlobal.on_concrete = false

	if $TypeOfFloorDetect/Grass.is_colliding() :
		PlayerGlobal.on_grass = true
	else :
		PlayerGlobal.on_grass = false

	if $TypeOfFloorDetect/Planks.is_colliding() :
		PlayerGlobal.on_planks = true
	else :
		PlayerGlobal.on_planks = false

	if $TypeOfFloorDetect/Metal.is_colliding() :
		PlayerGlobal.on_metal = true
	else :
		PlayerGlobal.on_metal = false

	if PlayerGlobal.on_concrete == true :
		$Sounds/TypesOfFloorSounds/Concrete.max_distance = 2000
		$Sounds/TypesOfFloorSounds/Planks.max_distance = 1
		$Sounds/TypesOfFloorSounds/Grass.max_distance = 1
		$Sounds/TypesOfFloorSounds/Metal.max_distance = 1

	if PlayerGlobal.on_grass == true :
		$Sounds/TypesOfFloorSounds/Concrete.max_distance = 1
		$Sounds/TypesOfFloorSounds/Planks.max_distance = 1
		$Sounds/TypesOfFloorSounds/Grass.max_distance = 2000
		$Sounds/TypesOfFloorSounds/Metal.max_distance = 1

	if PlayerGlobal.on_planks == true :
		$Sounds/TypesOfFloorSounds/Concrete.max_distance = 1
		$Sounds/TypesOfFloorSounds/Planks.max_distance = 2000
		$Sounds/TypesOfFloorSounds/Grass.max_distance = 1
		$Sounds/TypesOfFloorSounds/Metal.max_distance = 1

	if PlayerGlobal.on_metal == true :
		$Sounds/TypesOfFloorSounds/Concrete.max_distance = 1
		$Sounds/TypesOfFloorSounds/Planks.max_distance = 1
		$Sounds/TypesOfFloorSounds/Grass.max_distance = 1
		$Sounds/TypesOfFloorSounds/Metal.max_distance = 2000





func _on_EnterTimer_timeout():
	$Sounds/Effects/Dread/DreadOff.volume_db = 0
	$Sounds/Effects/Fire/FireOff.volume_db = 0



func _on_RegenLifeTimer_timeout():
	bandage_regen = false
	$HemwickSword/CharacterEffects/BandageHeal/BandageHealAnim.play("Stop")





func _on_LifeStealTimer_timeout():
	life_steal_on_hit = false



func _on_DashAttackTimer_timeout():
	PlayerStats.initial_base_damage -= 1

func _throwmagic():


	if PlayerGlobal.Current_Equipped == "fireball":
		var Fireball = preload("res://Effects/Spells/FireballPhysics.tscn")
		var fireball = Fireball.instance()
		get_tree().current_scene.add_child(fireball)
		fireball.transform = $Crosshair/Position2D.global_transform
		if get_global_mouse_position().x > global_position.x and $HemwickSword.scale.x == -1:
			$HemwickSword.scale.x = 1
		elif get_global_mouse_position().x < global_position.x and $HemwickSword.scale.x == 1:
			$HemwickSword.scale.x = -1

func _landdust():
	if state == FIGHT:
		if PlayerGlobal.submerged == true:
			$HemwickSword/Dust/DustLand.emitting = false
		else:
			$HemwickSword/Dust/DustLand.emitting = true
	elif state == ROLLFIGHT:
		if PlayerGlobal.submerged == true:
			$HemwickSword/Dust/DustRoll.emitting = false
		else:
			$HemwickSword/Dust/DustRoll.emitting = true


func _landdust2():
	if state == ROLLFIGHT:
		if PlayerGlobal.submerged == true:
			$HemwickSword/Dust/DustLandRoll.emitting = false
		else: $HemwickSword/Dust/DustLandRoll.emitting = true


func _hangland():
	$HemwickSword/Dust/DustHangLand.emitting = true
	if $HemwickSword.scale.x == 1:
		$HemwickSword/Dust/DustHangLand/DustHangAnim.play("RIGHT")
	else:
		$HemwickSword/Dust/DustHangLand/DustHangAnim.play("LEFT")





func _on_HangTimer_timeout():
	if is_on_wall():
		$HangR.enabled = false
		$HangL.enabled = false

func _can_shoot():
	if PlayerGlobal.slot1number > 0:
		PlayerGlobal.can_shoot = true
	else :
		PlayerGlobal.can_shoot = false
		state = FIGHT

func _shoot_arrow():

	if !PlayerGlobal.slot1 == "none":
		PlayerGlobal.slot1number -= 1



	if PlayerGlobal.Current_Equipped in PlayerGlobal.RangedWeapons:
		if PlayerGlobal.slot1number >= 0:
			var Arrow = preload("res://Entities/Hemwick/Bows/Arrows/SimpleArrow.tscn")
			var arrow = Arrow.instance()
			get_tree().current_scene.add_child(arrow)
			arrow.transform = $Crosshair/Position2D.global_transform
			if $HemwickSword/AdditionalAssets/Bow.speedone == true:
				arrow.get_node("HitBox").damage = PlayerGlobal.arrow_damage + 1
				arrow.speed = 100
				arrow.gravity_scale = 3
			if $HemwickSword/AdditionalAssets/Bow.speedtwo == true:
				arrow.get_node("HitBox").damage = PlayerGlobal.arrow_damage + 2
				arrow.speed = 200
				arrow.gravity_scale = 2
			if $HemwickSword/AdditionalAssets/Bow.speedthree == true:
				arrow.get_node("HitBox").damage = PlayerGlobal.arrow_damage + 3
				arrow.speed = 300
				arrow.gravity_scale = 1
			if $HemwickSword/AdditionalAssets/Bow.speedfour == true:
				arrow.get_node("HitBox").damage = PlayerGlobal.arrow_damage + 5
				arrow.speed = 400
				arrow.gravity_scale = 0.75
			if $HemwickSword/AdditionalAssets/Bow.speedfive == true:
				arrow.get_node("HitBox").damage = PlayerGlobal.arrow_damage + 8
				arrow.speed = 500
				arrow.gravity_scale = 0.5

func _shootarrowsounds():
	var anim = randi() % 5
	match anim:
		0: $HemwickSword/HitSounds/Bows/BowShoot1.play()
		1: $HemwickSword/HitSounds/Bows/BowShoot2.play()
		2: $HemwickSword/HitSounds/Bows/BowShoot3.play()
		3: $HemwickSword/HitSounds/Bows/BowShoot4.play()
		4: $HemwickSword/HitSounds/Bows/BowShoot5.play()

