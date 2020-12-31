extends Node
export (PackedScene) var Note
var r = RandomNumberGenerator.new()
var OCTAVES = 8.0
var SPIRAL_HEIGHT = 6.666666667 * 0.25
var OCTAVE_HEIGHT = SPIRAL_HEIGHT / OCTAVES
var helix
var total_radians = OCTAVES * 2 * PI
var total_notes = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()		
	vr.initialize()
	connectCollider($OQ_ARVROrigin/LeftCollide)
	connectCollider($OQ_ARVROrigin/RightCollide)
	helix  = $OQ_ARVROrigin/Helix	
	return
	for i in range(10):
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = i + 1
		timer.autostart = true
		timer.connect("timeout", self, "debugnote", [i])
		self.add_child(timer)
		
func debugnote(i):
	print(total_notes)
	playNote((i % 3) + 1, Settings.settings['OQ_RightController'])
	#playNote(5 - i, Settings.settings['OQ_LeftController'])	
func connectCollider(c):
	c.connect("oq_collision_started", self, "handleCollideStart")
	c.connect("oq_colliding", self, "handleColliding")
	c.connect("oq_collision_ended", self, "handleCollideEnd")

func handleCollideStart(body, controller):
	var note = playNote(getPitchFor(body), Settings.settings[controller.name])
	Settings.settings[controller.name].notes.append(note)
	return note
	
func handleColliding(body, controller):	
	var note = Settings.settings[controller.name].notes.back()
	if(note):
		note.shift.pitch_scale = getPitchFor(body)
		
func handleCollideEnd(_body, _controller):
	pass
	#if(note):
	#	remove_child(note)
	
func playNote(pitch, settings: Dictionary):	
	var note = Note.instance()
	note.r = r
	note.pitch = pitch # bug in docs? 
	note.index = total_notes
	note.origin = Vector3(0, pitch, 10)	
	note.settings = settings
	call_deferred("add_child", note)
	total_notes += 1
	
	return note
	
func getPitchFor(body):
	var y = body.translation.y
	var rely = y - helix.translation.y
	var octave = (rely / SPIRAL_HEIGHT) 
	var circular_distance = octave * total_radians
	var pitch = circular_distance / (2 * PI)
	#print(pitch)
	if pitch > 0:
		return pitch

	return 1.0

func _physics_process(_delta):
	if(vr.button_just_pressed(vr.BUTTON.LEFT_GRIP_TRIGGER)):
		Settings.settings['OQ_LeftController'].looping = true
	elif(vr.button_just_released(vr.BUTTON.LEFT_GRIP_TRIGGER)):
		cancelNotes(Settings.settings['OQ_LeftController'])
		
	if(vr.button_just_pressed(vr.BUTTON.RIGHT_GRIP_TRIGGER)):
		Settings.settings['OQ_RightController'].looping = true
	elif(vr.button_just_released(vr.BUTTON.RIGHT_GRIP_TRIGGER)):
		cancelNotes(Settings.settings['OQ_RightController'])

func cancelNotes(settings):
	settings.looping = false
	for note in settings.notes:
		if note.player.stream.loop_mode == AudioStreamSample.LOOP_FORWARD:			
			note.player.stream.set_loop_mode(AudioStreamSample.LOOP_DISABLED)
