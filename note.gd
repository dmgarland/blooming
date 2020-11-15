extends Node

var shape
var spectrum
var r
var pitch
var bus
var player
var distance = 0

func _ready():
	#print("Ready bus count = %s" % AudioServer.bus_count)	
	shape = CSGSphere.new()
	var material = SpatialMaterial.new()
	shape.material = material
	player = AudioStreamPlayer3D.new()
	AudioServer.lock()
	
	AudioServer.add_bus()
	bus = AudioServer.bus_count - 1
	# Add a new bus just for this note
	var name = "Bus %s" % bus
	#print(name)
	
	AudioServer.set_bus_name(bus, name)
	AudioServer.set_bus_send(bus, "Master")
	AudioServer.add_bus_effect(bus, AudioEffectSpectrumAnalyzer.new(), 1)
	
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
	yield(get_tree().create_timer(r.randf_range(1.0, 3.0)), "timeout")
	shape.translate(Vector3(-distance, 0, 0))
	distance = 0
	player.play()

func _process(_delta):
	var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	var bass = spectrum.get_magnitude_for_frequency_range(20, 1000)
	var mid = spectrum.get_magnitude_for_frequency_range(1001, 4000)
	var top = spectrum.get_magnitude_for_frequency_range(4001, 20000)
	
	if magnitude.x > 0:
		shape.radius = magnitude.x * 1000 * _delta
		shape.material.albedo_color = Color(bass.x * 100.0, mid.x * 100.0, top.x * 100.0, 0.7)		
		var offset = player.get_playback_position() * _delta / 2
		distance += offset
		
		shape.translate(Vector3(offset, 0, 0))
	
