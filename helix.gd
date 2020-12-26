extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var EQUAL_TEMPERAMENT_INTERVAL = (2 * PI) / 12
var scale_interval = EQUAL_TEMPERAMENT_INTERVAL

# Called when the node enters the scene tree for the first time.
func _ready():
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var indices = PoolIntArray()
	
#	for i in range(100):
#		var vertex = Vector3(cos(i), sin(i), i)
#		vertices.append(vertex)
#		normals.append(vertex.normalized())
	var rings = 50
	var radial_segments = 50
	var height = get_child(0).get_aabb().size.y
	print("helix height is ", height)
	var octaves = 8.0
	var radius = 0.5
	var thisrow = 0
	var prevrow = 0
	var point = 0
	var octave_height = height / octaves
	
	# Loop over rings.	
	for i in range(octaves):
		var t = 0
		while t < (PI * 2):
			var y = ((t / (2 * PI)) * octave_height) + (i * octave_height)
			var x = cos(t)
			var z = sin(t)
			var vert = Vector3(x * radius, y, z * radius)
			vertices.append(vert)
			normals.append(vert.normalized())	
			point += 1
			t += scale_interval
			var notch = CSGSphere.new()
			notch.radius = 0.05
			notch.translate(vert) 
			add_child(notch)
			
			# Create triangles in ring using indices.
			if t > 0:
				indices.append(prevrow + t - 1)
				indices.append(prevrow + t)
				indices.append(thisrow + t - 1)

				indices.append(prevrow + t)
				indices.append(thisrow + t)
				indices.append(thisrow + t - 1)

	prevrow = thisrow
	thisrow = point			
	#var arrays = []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#arrays[Mesh.ARRAY_TEX_UV] = uvs
	#arrays[Mesh.ARRAY_NORMAL] = normals
	#arrays[Mesh.ARRAY_INDEX] = indices
	#add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
