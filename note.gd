extends Node

var shape
var spectrum
var r
var pitch
var bus

func _ready():
	shape = CSGSphere.new()
	var player = AudioStreamPlayer3D.new()
	AudioServer.add_bus()
	bus = AudioServer.bus_count - 1
	# Add a new bus just for this note
	var name = "Bus %s" % bus
	print(name)
	
	AudioServer.set_bus_name(bus, name)
	AudioServer.set_bus_send(bus, "Master")
	AudioServer.add_bus_effect(bus, AudioEffectSpectrumAnalyzer.new(), 0)
	
	# Get the effect we just added
	spectrum = AudioServer.get_bus_effect_instance(bus, 0)
	
	# Tell the player to play a sound on our new bus
	player.bus = name
	player.stream = load('res://bowed.wav')
	player.pitch_scale = pitch
	shape.translate(Vector3(pitch, pitch, pitch))
	
	player.connect("finished", self, "on_finished")
	
	# Add everything to the scene
	self.add_child(shape)
	shape.add_child(player)
	player.play()
	
func on_finished():
	print("Finished")
	AudioServer.remove_bus(bus)
	queue_free()

func _process(_delta):
	var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	if magnitude.x > 0:
		shape.radius = magnitude.x * 1000 * _delta
	
