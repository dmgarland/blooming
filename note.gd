extends Node

var shape: CSGShape
var spectrum
var r
var pitch
var bus
var player
var distance = 0
var index
var targetRadius = 0
var targetColour = Color(0, 0, 0, 1)
var timer
var origin: Vector3 = Vector3(0,0,0);
var sample;
var sample_length;

func _ready():
	#print("Ready bus count = %s" % AudioServer.bus_count)	
	shape = CSGSphere.new()	
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
	sample_length = player.stream.get_length()	
	player.pitch_scale = pitch	
	shape.translate(origin)
	
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
	# if loop:
	self.queue_free()
	return
	# else
	yield(get_tree().create_timer(r.randf_range(0.5, 5.0)), "timeout")
	var pitch_adjustment = r.randf_range(-0.1, 0.1)	
	player.pitch_scale += pitch_adjustment
	player.play()
	
func measureFrequencies():
	var magnitude = spectrum.get_magnitude_for_frequency_range(20, 20000)
	var bass = spectrum.get_magnitude_for_frequency_range(20, 1000)
	var mid = spectrum.get_magnitude_for_frequency_range(1001, 2000)
	var top = spectrum.get_magnitude_for_frequency_range(2001, 20000)	
	targetRadius = magnitude.x * 50	
	targetColour = Color(bass.x * 100.0, mid.x * 100.0, top.x * 100.0, 0.7)
	
func setColour(delta):	
	var ir = (targetColour.r - shape.material.albedo_color.r) * delta + shape.material.albedo_color.r
	var ig = (targetColour.g - shape.material.albedo_color.g) * delta + shape.material.albedo_color.g
	var ib = (targetColour.b - shape.material.albedo_color.b) * delta + shape.material.albedo_color.b
	shape.material.albedo_color = Color(ir, ig, ib, 0.7)

func percentageThroughSample():
	return player.get_playback_position() / sample_length
	
func setPosition(delta):
	#print(percentageThroughSample())
	#var offset = percentageThroughSample() * (2 * PI)
	var offset = player.get_playback_position()
	var currentPosition = shape.transform.origin
	var targetPosition = Vector3(sin(offset) * 10, currentPosition.y, cos(offset) * 10)
	var interpolator = (targetPosition - currentPosition) * delta 
	print(currentPosition, targetPosition, interpolator)
	shape.translate(interpolator)
	
func setRadius():
	var interpolator = (targetRadius - shape.radius) * 0.2 + shape.radius	
	if interpolator > 0:
		shape.radius = interpolator
	
func _process(delta):	
	setColour(delta)		
	setPosition(delta)
	setRadius()
	
	
	
