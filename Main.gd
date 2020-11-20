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


func playNote(index):
	notes += 1
	var randPitch = r.randf_range(-2.0, 2.0)
	
	var note = Note.instance()
	note.r = r
	note.pitch = basePitch + randPitch
	note.index = index
	#add_child(note)
	call_deferred("add_child", note)

func _input(event):
	if event is InputEventMouseButton && event.is_pressed() && notes < maxNotes:
		playNote(event.button_index)
		
	if event is InputEventMouseMotion:
		var offset = -deg2rad(event.relative.y) * 0.5
		var newAngle = cameraAngle + offset
		if newAngle > -60 and newAngle < 60:
			cameraAngle += offset			
			$World/Camera.rotate_x(deg2rad(offset))
		basePitch = (((get_viewport().size.y - get_viewport().get_mouse_position().y) / get_viewport().size.y) - 0.5) * 15		
		
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_LEFT	:				
				$World/Camera.rotate_y(0.1)
			KEY_RIGHT:				
				$World/Camera.rotate_y(-0.1)
			KEY_UP:				
				$World/Camera.translate(Vector3(0, 0, -movementOffset))
			KEY_DOWN:				
				$World/Camera.translate(Vector3(0, 0, movementOffset))
		

