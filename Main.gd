extends Node
export (PackedScene) var Note
var r = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()


func playNote():
	var pitch = r.randf_range(1.0, 4.0)
	
	var note = Note.instance()
	note.r = r
	note.pitch = pitch
	#add_child(note)
	call_deferred("add_child", note)

func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		playNote()
