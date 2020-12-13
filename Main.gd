extends Node
export (PackedScene) var Note
var r = RandomNumberGenerator.new()
var movementOffset = 0.2
var cameraAngle = 0
var maxNotes = 12
var notes = 0
var basePitch = 0
var origin = Vector3(0, 0, 0)
var OCTAVES = 8.0
var SPIRAL_HEIGHT = 1.5
var OCTAVE_HEIGHT = SPIRAL_HEIGHT / OCTAVES
var helix
var total_radians = OCTAVES * 2 * PI

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()		
	vr.initialize()
	connectCollider($OQ_ARVROrigin/OQ_LeftController/Collide)
	connectCollider($OQ_ARVROrigin/OQ_RightController/Collide)
	helix  = $OQ_ARVROrigin/Helix
	setDefaults()
	
func setDefaults():
	$OQ_ARVROrigin/OQ_LeftController.sound = 'res://bowed.wav'
	$OQ_ARVROrigin/OQ_RightController.sound = 'res://bell.wav'
	
func connectCollider(c):
	c.connect("oq_collision_started", self, "handleCollideStart")
	c.connect("oq_colliding", self, "handleColliding")
	c.connect("oq_collision_ended", self, "handleCollideEnd")

var noteOn = false
var note = null;

func handleCollideStart(with, body):
	note = playNote(getPitchFor(body), body.translation, body.sound)
	
func handleColliding(with, body):
	if(note):
		note.player.pitch_scale = getPitchFor(body)
		
func handleCollideEnd(with, body):
	pass
	#if(note):
	#	remove_child(note)
	
func playNote(pitch, origin, sound):
	notes += 1
	var randPitch = r.randf_range(-1.5, 1.5)
	var note = Note.instance()
	note.r = r
	note.pitch = pitch
	note.index = notes
	note.origin = origin
	note.sample = sound
	call_deferred("add_child", note)
	return note
	
func getPitchFor(body):
	var y = body.translation.y
	var rely = y - helix.translation.y
	var octave = (rely / SPIRAL_HEIGHT) 
	var circular_distance = octave * total_radians
	var pitch = circular_distance / (2 * PI)
	print(pitch)
	if pitch > 0:
		return pitch

	return 1.0
