extends Node
export (PackedScene) var Note
var r = RandomNumberGenerator.new()
var movementOffset = 0.2
var cameraAngle = 0
var maxNotes = 12
var notes = 0
var basePitch = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()		
	vr.initialize()


func playNote(index):
	notes += 1
	var randPitch = r.randf_range(-1.5, 1.5)
	
	var note = Note.instance()
	note.r = r
	note.pitch = basePitch + randPitch
	note.index = index
	#add_child(note)
	call_deferred("add_child", note)

func _physics_process(delta):
	if vr.button_just_pressed(vr.BUTTON.ENTER) && notes < maxNotes:
		playNote(1)
