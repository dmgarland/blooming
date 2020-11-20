extends Node
export (PackedScene) var Note
var r = RandomNumberGenerator.new()
var movementOffset = 0.2
var cameraAngle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()


func playNote(index):
	var pitch = r.randf_range(1.0, 3.0)
	
	var note = Note.instance()
	note.r = r
	note.pitch = pitch
	note.index = index
	#add_child(note)
	call_deferred("add_child", note)

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		playNote(event.button_index)
	if event is InputEventMouseMotion:
		var offset = -deg2rad(event.relative.y) * 0.5
		var newAngle = cameraAngle + offset
		if newAngle > -50 and newAngle < 50:
			cameraAngle += offset	
			$World/Camera.rotate_x(deg2rad(offset))
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
		

