extends Node
export (PackedScene) var Note
var r = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	r.randomize()
	var note = Note.instance()
	note.bus = 1
	note.r = r
	add_child(note)
	
	var note2 = Note.instance()
	note2.bus = 2
	note2.r = r
	add_child(note2)

	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
