extends Node

var shape
var spectrum
var r
var pitch
var bus
var player
var distance = 0
var samples = ['res://bowed.wav', 'res://bell.wav', 'res://bass.wav']
var index
var targetRadius = 0
var targetColour = Color(0, 0, 0, 1)
var timer
var origin: Vector3 = Vector3(0,0,0);
var sample;

func _ready():
	#print("Ready bus count = %s" % AudioServer.bus_count)	
	shape = CSGSphere.new()
	shape.transform.scaled(Vector3(0.2, 0.2, 0.2))	
	shape.rings = 6
	shape.radial_segments = 12
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
	#player.stream = load(samples[randi() % samples.size()])	
	#player.stream = load(samples[clamp(index - 1, 0, samples.size() - 1)])
	player.stream = load(sample)
	player.pitch_scale = pitch	
	shape.translate(Vector3(origin.x + pitch, origin.y + pitch, origin.z + pitch * 2))
	
	player.connect("finished", self, "on_finished")
	
	# Sample the sound every 50ms
	timer = Timer.new()
	timer.wait_time = 0.05
	timer.autostart = true
	timer.connect("timeout", self, "measureFrequencies")
	self.add_child(timer)
	
	# Add everything to the scene
	self.add_child(shape)
	shape.add_child(player)
	player.play()
	
func on_finished():
	yield(get_tree().create_timer(r.randf_range(0.5, 5.0)), "timeout")
	self.queue_free()
	#var pitch_adjustment = r.randf_range(-0.1, 0.1)
	#shape.translate(Vector3(-distance + pitch_adjustment, pitch_adjustment, pitch_adjustment))
	#distance = 0
	#player.pitch_scale += pitch_adjustment
	#player.play()
	
func measureFrequencies():
	var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	var bass = spectrum.get_magnitude_for_frequency_range(20, 1000)
	var mid = spectrum.get_magnitude_for_frequency_range(1001, 2000)
	var top = spectrum.get_magnitude_for_frequency_range(2001, 20000)	
	targetRadius = magnitude.x * 100	
	targetColour = Color(bass.x * 100.0, mid.x * 100.0, top.x * 100.0, 0.7)
	
func setColour():	
	var ir = (targetColour.r - shape.material.albedo_color.r) * 0.2 + shape.material.albedo_color.r
	var ig = (targetColour.g - shape.material.albedo_color.g) * 0.2 + shape.material.albedo_color.g
	var ib = (targetColour.b - shape.material.albedo_color.b) * 0.2 + shape.material.albedo_color.b
	shape.material.albedo_color = Color(ir, ig, ib, 0.7)
	
func setPosition(delta):
	var offset = player.get_playback_position() * delta / 2
	distance += offset	
	shape.translate(Vector3(offset, 0, 0))
	
func setRadius():
	var interpolator = (targetRadius - shape.radius) * 0.2 + shape.radius	
	if interpolator > 0:
		shape.radius = interpolator
	
func _process(delta):	
	setColour()		
	setPosition(delta)
	setRadius()
	
	
	
