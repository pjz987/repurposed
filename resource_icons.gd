extends Control

func _ready() -> void:
	refresh_resource_icons()
	Globals.refresh_resource_icons.connect(refresh_resource_icons)
	
func refresh_resource_icons() -> void:
	$Metal_Label.text = str(Globals.metal).pad_zeros(3)
	$Oil_Label.text = str(Globals.oil).pad_zeros(3)
	if Globals.hero:
		$HealthBar.value = float(Globals.hero.health) / float(Globals.hero.max_health)
