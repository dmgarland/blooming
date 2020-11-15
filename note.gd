extends Node

var shape
var spectrum
var r
var pitch
var bus
var player

func _ready():
	shape = CSGSphere.new()
	player = AudioStreamPlayer3D.new()
	AudioServer.lock()
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
	AudioServer.unlock()
	
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
	print("Finished %s" % (bus))
	AudioServer.lock()
	AudioServer.remove_bus(bus)
	AudioServer.unlock()
	queue_free()

func _process(_delta):
	var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	if magnitude.x > 0:
		shape.radius = magnitude.x * 1000 * _delta
		shape.translate(Vector3(player.get_playback_position() * _delta, 0, 0))
	
