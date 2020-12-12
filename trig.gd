extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var angle = 0
var x
var y
var origin

# Called when the node enters the scene tree for the first time.
func _ready():
	x = get_viewport().size.x / 2
	y = get_viewport().size.y / 2
	origin = Vector2(x, y)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseMotion:
		#x = event.position.x - origin.x
		#y = origin.y - event.position.y
		x = event.position.x
		y = event.position.y		
		var relx = x - origin.x
		var rely = y - origin.y
	 
		if relx != 0:
			angle = atan(rely / relx)	
	
		# If we're to the left of the origin on the x-axis, we're in quadrant 2 or 3
		# so offset the angle by half
		if origin.x > x:
			angle += PI 	
		# If we're in quadrant 4 (top right), we'll have a negative angle from the origin
		# so essentially deduct from 2 PI to get the offset the other way	
		elif origin.y > y:
			angle += PI * 2	
		update()
	elif event is InputEventMouseButton and event.is_pressed():
		var pitch = (angle / (2 * PI))
		print(angle, ", ", pitch)		
		AudioServer.get_bus_effect(0, 0).pitch_scale = pitch
		$Player.play()
		
		
func _draw():	
	draw_circle(origin, 100.0, Color(1, 1, 1))
	draw_triangle(origin, x, y, Color(0, 1, 1))
	draw_points_arc(origin, 50.0, 0, angle, Color(1, 0, 0))
	
	
func draw_triangle(center, x, y, color):
	draw_line(center, Vector2(x, y), color)
	draw_line(center, Vector2(x, center.y), color)
	draw_line(Vector2(x, y), Vector2(x, center.y), color)
	
func draw_points_arc(center, radius, angle_from, angle_to, color):	
	var nb_points = 32
	var points_arc = PoolVector2Array()	
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
