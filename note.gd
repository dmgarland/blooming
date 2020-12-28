extends Node

var shape: CSGShape
var spectrum
var r
var pitch
var bus
var player: AudioStreamPlayer3D
var distance = 0
var index
var targetRadius = 0
var targetColour = Color(0, 0, 0, 1)
var timer
var origin: Vector3 = Vector3(0,0,0);
var settings: Dictionary;
var sample_length;
var shift: AudioEffectPitchShift;
var time_begin
var time_delay

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
	shift = AudioEffectPitchShift.new()
	shift.pitch_scale = pitch
	shift.oversampling = 5
	shift.fft_size = AudioEffectPitchShift.FFT_SIZE_1024
	AudioServer.add_bus_effect(bus, shift)
	AudioServer.add_bus_effect(bus, AudioEffectSpectrumAnalyzer.new())
	
	
	# Get the effect we just added
	spectrum = AudioServer.get_bus_effect_instance(bus, 1)
	AudioServer.unlock()
	
	# Tell the player to play a sound on our new bus
	player.bus = name
	player.doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	player.stream = load(settings.sample.resource)
	if settings.looping:
		player.stream.loop_mode = AudioStreamSample.LOOP_FORWARD
		player.stream.loop_begin = settings.sample.loop.begin
		player.stream.loop_end = settings.sample.loop.end

	sample_length = player.stream.get_length()	
	#player.pitch_scale = pitch	
	shape.translate(origin)
	
	player.connect("finished", self, "on_finished")
	
	# Sample the sound every `wait_time` seconds
	timer = Timer.new()
	timer.wait_time = 0.05
	timer.autostart = true
	timer.connect("timeout", self, "measureFrequencies")
	self.add_child(timer)
	
	# Add everything to the scene
	self.add_child(shape)
	shape.add_child(player)
	time_begin = OS.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	player.play()
	
func on_finished():
	settings.notes.erase(self)
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
	targetRadius = magnitude.x * 80
	targetColour = Color(bass.x * 100.0, mid.x * 100.0, top.x * 100.0, 0.7)
	
func setColour(delta):	
	var ir = (targetColour.r - shape.material.albedo_color.r) * delta + shape.material.albedo_color.r
	var ig = (targetColour.g - shape.material.albedo_color.g) * delta + shape.material.albedo_color.g
	var ib = (targetColour.b - shape.material.albedo_color.b) * delta + shape.material.albedo_color.b
	shape.material.albedo_color = Color(ir, ig, ib, 0.7)

func percentageThroughSample():
	return player.get_playback_position() / sample_length
	
func setPosition(delta):	
	var offset = ((OS.get_ticks_usec() - time_begin) / 1000000.0) - time_delay
	var currentPosition = shape.transform.origin
	var targetPosition = Vector3(sin(offset) * 6, shift.pitch_scale - 1, cos(offset) * 6)
	var interpolator = (targetPosition - currentPosition) * delta 
	#print(currentPosition, targetPosition, interpolator)
	shape.translate(interpolator)
	
func setRadius():
	var interpolator = (targetRadius - shape.radius) * 0.2 + shape.radius	
	if interpolator > 0:
		shape.radius = interpolator
	
func _process(delta):	
	setColour(delta)		
	setPosition(delta)
	setRadius()
	
	
	
