extends CanvasLayer


export var livingendX = 0
export var livingendY = 0
export var healthendX = 0
export var healthendY = 0
export var staminaendX = 0
export var staminaendY = 0
export var manaendX = 0
export var manaendY = 0
export var GUIOn = false

onready var WeaponSecondary = $FrameSecondary/Weapons/Weapon
onready var WeaponPrimary = $FramePrimary/Weapons/Weapon

onready var bow = preload("res://Misc/UI elements/WeaponIcons/Bow.png")
onready var dagger = preload("res://Misc/UI elements/WeaponIcons/Dagger.png")
onready var fireball = preload("res://Misc/UI elements/WeaponIcons/Fireball.png")
onready var shovel = preload("res://Misc/UI elements/WeaponIcons/Hoe.png")
onready var celeste = preload("res://Misc/UI elements/WeaponIcons/HemwickSword.png")
onready var hemwicksword = preload("res://Misc/UI elements/WeaponIcons/HemwickSword.png")





# Called when the node enters the scene tree for the first time.
func _ready():
	$FramePrimary/EquipAnimPrimary.play("Weapon")
	$FrameSecondary/EquipAnimSecondary.play("Weapon")
	$GUIAnim.play("ChangeToPrimary")


func _physics_process(delta):


	if PlayerGlobal.inventory == true or PlayerGlobal.alchemy == true:
		$BarsAnim.play("On")
	else: $BarsAnim.play("Off")

	$DebugStats/TempNumber.text = "%s" % [PlayerGlobal.TEMP]
	$DebugStats/DreadNumber.text = "%s" %  [PlayerDmgModif.DREAD]



	if PlayerGlobal.is_on_floor == true:
		if Input.is_action_just_pressed("ChangeWeapon") and PlayerGlobal.PrimarySelect == true:
			$GUIAnim.play("ChangeToSecondary")
			PlayerGlobal.Current_Equipped = PlayerGlobal.Secondary
			PlayerGlobal.PrimarySelect = false

		elif Input.is_action_just_pressed("ChangeWeapon") and PlayerGlobal.PrimarySelect == false:
			$GUIAnim.play("ChangeToPrimary")
			PlayerGlobal.Current_Equipped = PlayerGlobal.Primary
			PlayerGlobal.PrimarySelect = true

	_livingbarend(delta)
	_healthbarend(delta)
	_staminabarend(delta)
	_manabarend(delta)
	_uivisibility(delta)


func _livingbarend(_delta) :
	$LivingUI/LivingEnd.position.x = livingendX
	$LivingUI/LivingEnd.position.y = livingendY
	livingendY = 46

	if PlayerStats.max_living == 30 :
		livingendX = 337
	elif PlayerStats.max_living == 50 :
		livingendX = 554
	elif PlayerStats.max_living == 70 :
		livingendX = 771
	elif PlayerStats.max_living == 90 :
		livingendX = 988
	elif PlayerStats.max_living == 110 :
		livingendX = 1205
	elif PlayerStats.max_living == 130 :
		livingendX = 1422
	elif PlayerStats.max_living == 150 :
		livingendX = 1639

func _healthbarend(_delta) :
	$HealthUI/HealthEnd.position.x = healthendX
	$HealthUI/HealthEnd.position.y = healthendY
	healthendY = 49

	if PlayerStats.max_health == 60 :
		healthendX = 666
	elif PlayerStats.max_health == 70 :
		healthendX = 778
	elif PlayerStats.max_health == 80 :
		healthendX = 886
	elif PlayerStats.max_health == 90 :
		healthendX = 991
	elif PlayerStats.max_health == 100 :
		healthendX = 1097
	elif PlayerStats.max_health == 110 :
		healthendX = 1211
	elif PlayerStats.max_health == 120 :
		healthendX = 1316
	elif PlayerStats.max_health == 130 :
		healthendX = 1421
	elif PlayerStats.max_health == 140 :
		healthendX = 1546
	elif PlayerStats.max_health == 150 :
		healthendX = 1646
	elif PlayerStats.max_health == 160 :
		healthendX = 1751
	elif PlayerStats.max_health == 170 :
		healthendX = 1866

func _staminabarend(_delta) :
	$StaminaUI/StaminaEnd.position.x = staminaendX
	$StaminaUI/StaminaEnd.position.y = staminaendY
	staminaendY = 49

	if PlayerStats.max_stamina == 30 :
		staminaendX = 341
	if PlayerStats.max_stamina == 45 :
		staminaendX = 501
	if PlayerStats.max_stamina == 60 :
		staminaendX = 661
	if PlayerStats.max_stamina == 75 :
		staminaendX = 831
	if PlayerStats.max_stamina == 90 :
		staminaendX = 990
	if PlayerStats.max_stamina == 105 :
		staminaendX = 1151
	if PlayerStats.max_stamina == 120 :
		staminaendX = 1321
	if PlayerStats.max_stamina == 135 :
		staminaendX = 1481
	if PlayerStats.max_stamina == 150 :
		staminaendX = 1641
	if PlayerStats.max_stamina == 165 :
		staminaendX = 1801

func _manabarend(_delta) :
	$ManaUI/ManaEnd.position.x = manaendX
	$ManaUI/ManaEnd.position.y = manaendY
	manaendY = 49

	if PlayerStats.max_mana == 30 :
		manaendX = 333
	if PlayerStats.max_mana == 45 :
		manaendX = 496
	if PlayerStats.max_mana == 60 :
		manaendX = 656
	if PlayerStats.max_mana == 75 :
		manaendX = 822
	if PlayerStats.max_mana == 90 :
		manaendX = 977
	if PlayerStats.max_mana == 105 :
		manaendX = 1146
	if PlayerStats.max_mana == 120 :
		manaendX = 1313
	if PlayerStats.max_mana == 135 :
		manaendX = 1474
	if PlayerStats.max_mana == 150 :
		manaendX = 1636
	if PlayerStats.max_mana == 165 :
		manaendX = 1796

func _uivisibility(_delta) :
	if PlayerGlobal.pickup_weaponprimary == true:
		$FramePrimary/EquipAnimPrimary.stop(true)
		$FramePrimary/EquipAnimPrimary.play("Weapon")
	if PlayerGlobal.pickup_weaponsecondary == true:
		$FrameSecondary/EquipAnimSecondary.stop(true)
		$FrameSecondary/EquipAnimSecondary.play("Weapon")


	if PlayerGlobal.Primary == "dagger":
		WeaponPrimary.texture = dagger
	elif PlayerGlobal.Secondary == "dagger":
		WeaponSecondary.texture = dagger

	if PlayerGlobal.Primary == "celeste":
		WeaponPrimary.texture = celeste
	elif PlayerGlobal.Secondary == "celeste":
		WeaponSecondary.texture = celeste

	if PlayerGlobal.Primary == "hemwicksword":
		WeaponPrimary.texture = hemwicksword
	elif PlayerGlobal.Secondary == "hemwicksword":
		WeaponSecondary.texture = hemwicksword


	if PlayerGlobal.Primary == "shovel":
		WeaponPrimary.texture = shovel

	elif PlayerGlobal.Secondary == "shovel":
		WeaponSecondary.texture = shovel


	if PlayerGlobal.Primary == "unarmed":
		$FramePrimary/EquipAnimPrimary.play("None")
	elif PlayerGlobal.Secondary == "unarmed":
		$FrameSecondary/EquipAnimSecondary.play("None")

	if PlayerGlobal.Primary == "fireball":
		WeaponPrimary.texture = fireball
	elif PlayerGlobal.Secondary =="fireball":
		WeaponSecondary.texture = fireball

	if PlayerGlobal.Primary == "bow":
		WeaponPrimary.texture = bow
	elif PlayerGlobal.Secondary == "bow":
		WeaponSecondary.texture = bow


	if PlayerGlobal.shield_buckler == true :
		pass

	if PlayerGlobal.shield_heater == true :
		pass



