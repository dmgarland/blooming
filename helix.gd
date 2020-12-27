extends MeshInstance

var EQUAL_TEMPERAMENT_INTERVAL = (2 * PI) / 12
var scale_interval = EQUAL_TEMPERAMENT_INTERVAL

# Called when the node enters the scene tree for the first time.
func _ready():
	var height = 6.66666667	
	var octaves = 8.0
	var radius = 0.5
	var octave_height = height / octaves
	
	# Loop over rings.	
	for i in range(octaves):
		var t = 0
		while t < (PI * 2):
			var y = ((t / (2 * PI)) * octave_height) + (i * octave_height)
			var x = cos(t)
			var z = sin(t)
			var vert = Vector3(x * radius, y, z * radius)			
			t += scale_interval
			var notch = CSGSphere.new()
			notch.radius = 0.02
			notch.translate(vert) 
			add_child(notch)
