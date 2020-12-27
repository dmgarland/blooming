extends ReferenceRect

func _ready():
	for sample in Settings.samples:	
		$TimbreSettings/LeftTimbre.add_item(sample.label)
		$TimbreSettings/RightTimbre.add_item(sample.label)

func _on_LeftTimbre_item_selected(index):	
	Settings.settings['OQ_LeftController']['sample'] = Settings.samples[index].resource
	
func _on_RightTimbre_item_selected(index):	
	Settings.settings['OQ_RightController']['sample'] = Settings.samples[index].resource
