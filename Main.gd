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

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()		
	vr.initialize()
	connectCollider($OQ_ARVROrigin/OQ_LeftController/Collision)
	connectCollider($OQ_ARVROrigin/OQ_RightController/Collision)
	helix  = $OQ_ARVROrigin/Helix
	
func connectCollider(c):
	c.connect("oq_collision_started", self, "handleCollideStart")
	c.connect("oq_colliding", self, "handleColliding")
	c.connect("oq_collision_ended", self, "handleCollideEnd")

var noteOn = false

func handleCollideStart(with, controller):
	noteOn = true
	controller.get_child(0).play()
	
func handleColliding(with, controller):
	if(noteOn):
		var x = controller.translation.x
		var y = controller.translation.y
		var z = controller.translation.z		
		if x != 0:
			var angle = atan2(z, x)
			if origin.z > z:
				angle += PI * 2
				
			var rely = y - helix.translation.y	
			var total_radians = OCTAVES * 2 * PI
			var octave = (rely / SPIRAL_HEIGHT) 
			var circular_distance = octave * total_radians
			#var octave = floor((rely) / OCTAVE_HEIGHT)				
			#var pitch = (angle / (2 * PI)) + octave 
			var pitch = circular_distance / (2 * PI) - 2
			print("pitch = ", pitch)
			
			if pitch > 0:
			  controller.get_child(0).pitch_scale = pitch
		
func handleCollideEnd(controller):
	noteOn = false
	
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
	pass
