extends CSGSphere

var spectrum
var r
var pitch
var bus
var player: AudioStreamPlayer3D
var distance = 0
var index
var targetRadius = 0
var targetColour = Color(0, 0, 0, 1)
var origin: Vector3 = Vector3(0,0,0);
var settings: Dictionary;
var shift: AudioEffectPitchShift;
var time_begin
var time_delay
var thread

func _ready():
	#print("Ready bus count = %s" % AudioServer.bus_count)	
	player = AudioStreamPlayer3D.new()
	AudioServer.lock()
	
	self.material = SpatialMaterial.new()
	
	AudioServer.add_bus()
	bus = AudioServer.bus_count - 1
	# Add a new bus just for this note
	var name = "Bus %s" % bus
	#print(name)
	
	AudioServer.set_bus_name(bus, name)
	AudioServer.set_bus_send(bus, "Speakers")
	shift = AudioEffectPitchShift.new()
	shift.pitch_scale = pitch * 2
	shift.oversampling = 4
	shift.fft_size = AudioEffectPitchShift.FFT_SIZE_256
	AudioServer.add_bus_effect(bus, shift)	
	
	# Get the effect we just added
	spectrum = AudioServer.get_bus_effect_instance(bus, 0)
	AudioServer.unlock()
	
	# Tell the player to play a sound on our new bus
	player.bus = name	
	player.stream = load(settings.sample.resource)
	if settings.looping:
		player.stream.loop_mode = AudioStreamSample.LOOP_FORWARD
		player.stream.loop_begin = settings.sample.loop.begin
		player.stream.loop_end = settings.sample.loop.end
	#player.pitch_scale = pitch	
	translate(origin)
	
	player.connect("finished", self, "on_finished")
	
	# Sample the sound every `wait_time` seconds
	#thread = Thread.new()
	#thread.start(self, "analyser")
	analyser()
	
	# Add everything to the scene	
	self.add_child(player)
	time_begin = OS.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	player.play()
	
func analyser(wait_time: float = 0.05):
	var timer = Timer.new()
	timer.wait_time = wait_time
	#timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", self, "measureFrequencies")
	add_child(timer)
	
#func _exit_tree():
#	thread.wait_to_finish()
	
func on_finished():
	AudioServer.lock()
	AudioServer.set_bus_bypass_effects(bus, false)
	AudioServer.unlock()
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
	targetRadius = magnitude.x * 100
	
	var bass = spectrum.get_magnitude_for_frequency_range(20, 1000)
	var mid = spectrum.get_magnitude_for_frequency_range(1001, 2000)
	var top = spectrum.get_magnitude_for_frequency_range(2001, 20000)	
	#print(bass, mid, top)		
	targetColour = Color(bass.x * 100.0, mid.x * 4000.0, top.x * 20000.0, 0.7)
	
	setRadius()
	setColour(0.5)
	
func setColour(delta):
	var ir = (targetColour.r - self.material.albedo_color.r) * delta + self.material.albedo_color.r
	var ig = (targetColour.g - self.material.albedo_color.g) * delta + self.material.albedo_color.g
	var ib = (targetColour.b - self.material.albedo_color.b) * delta + self.material.albedo_color.b
	self.material.albedo_color = Color(ir, ig, ib, 0.7)
	
func setPosition(delta):	
	var offset = ((OS.get_ticks_usec() - time_begin) / 1000000.0) - time_delay
	var currentPosition = self.transform.origin
	var targetPosition = Vector3(sin(offset) * 6, shift.pitch_scale - 1, cos(offset) * 6)
	var interpolator = (targetPosition - currentPosition) * delta 
	self.translate(interpolator)
	
func setRadius():
	var interpolator = (targetRadius - self.radius) * 0.2 + self.radius	
	if interpolator > 0:
		self.radius = interpolator
	
func _physics_process(delta):
	setPosition(delta)
