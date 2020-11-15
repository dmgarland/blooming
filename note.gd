extends Node

var shape = CSGSphere.new()
var player = AudioStreamPlayer3D.new()
var spectrum
var bus
var r

func _ready():	
	# Add a new bus just for this note
	AudioServer.add_bus(bus)
	var name = "Bus %s" % bus
	print(name)
	AudioServer.set_bus_name(bus, name)
	AudioServer.set_bus_send(bus, "Master")
	AudioServer.add_bus_effect(bus, AudioEffectSpectrumAnalyzer.new(), 0)
	
	# Get the effect we just added
	spectrum = AudioServer.get_bus_effect_instance(bus, 0)
	
	# Tell the player to play on our new bus
	player.bus = name
		
	# Setup the sound sample
	player.pitch_scale = r.randf_range(0.0, 4.0)
	player.stream = load('res://bowed.wav')
	
	# Add everything to the scene
	self.add_child(shape)
	shape.add_child(player)
	player.play()
	

func _process(delta):
	var magnitude = spectrum.get_magnitude_for_frequency_range(0, 44100)
	var energy = clamp((60 + linear2db(magnitude.length())) / 60, 0, 1)
	
	if magnitude.x > 0:
		shape.radius = magnitude.x * 100
	else:
		queue_free()
	
