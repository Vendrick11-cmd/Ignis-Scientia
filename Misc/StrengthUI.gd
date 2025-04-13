extends Control

var base_damage = 100 setget set_base_damage
var max_base_damage = 100 setget set_max_base_damage

func set_base_damage(value) :
	base_damage = clamp(value, 0, max_base_damage)
	if $Strength != null :
		$Strength.rect_size.x = base_damage * 64

func set_max_base_damage(value) :
	max_base_damage = max(value, 1)
	self.base_damage = min(base_damage, max_base_damage*64)
	if $StrengthBackground != null:
		$StrengthBackground.rect_size.x = max_base_damage *64



func _ready() :

	self.base_damage = PlayerStats.base_damage
	self.max_base_damage = PlayerStats.max_base_damage

	PlayerStats.connect("base_damage_changed", self, "set_base_damage")
	PlayerStats.connect("max_base_damage_changed", self, "set_max_base_damage")
