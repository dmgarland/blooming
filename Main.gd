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
	var x1 = $OQ_ARVROrigin/OQ_LeftController.transform.origin.x
	var y1 = $OQ_ARVROrigin/OQ_LeftController.transform.origin.y
	var z1 = $OQ_ARVROrigin/OQ_LeftController.transform.origin.z
	var t1 = atan2(z1, x1)
	var p1 = t1 + 1

	var x2 = $OQ_ARVROrigin/OQ_RightController.transform.origin.x
	var y2 = $OQ_ARVROrigin/OQ_RightController.transform.origin.y
	var z2 = $OQ_ARVROrigin/OQ_RightController.transform.origin.z
	var t2 = atan2(z2, x2)
	var p2 = t2 + 1
	
	if p1 > 0:	
		$OQ_ARVROrigin/OQ_LeftController/LeftAudio.pitch_scale = p1
	if p2 > 0:
		$OQ_ARVROrigin/OQ_RightController/RightAudio.pitch_scale = p2
	
	if vr.button_just_pressed(vr.BUTTON.LEFT_INDEX_TRIGGER):				
		print("x = ", x1, " y = ", y1, " z = ", z1, " t = ", t1, " p1 = ", p1)
		$OQ_ARVROrigin/OQ_LeftController/LeftAudio.play()
	elif vr.button_just_released(vr.BUTTON.LEFT_INDEX_TRIGGER):		
		$OQ_ARVROrigin/OQ_LeftController/LeftAudio.stop()
	elif vr.button_just_pressed(vr.BUTTON.RIGHT_INDEX_TRIGGER):			
		print("x = ", x2, " y = ", y2, " z = ", z2, " t = ", t2, " p1 = ", p2)
		$OQ_ARVROrigin/OQ_RightController/RightAudio.play()
	elif vr.button_just_released(vr.BUTTON.RIGHT_INDEX_TRIGGER):		
		$OQ_ARVROrigin/OQ_RightController/RightAudio.stop()
