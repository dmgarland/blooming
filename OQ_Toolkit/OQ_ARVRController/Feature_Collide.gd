extends RigidBody
var controller : ARVRController = null;
export var controller_name: String = "";

signal oq_collision_started;
signal oq_colliding;
signal oq_collision_ended;

var pressed = false;
var playing = false;


export(vr.BUTTON) var trigger_button = vr.BUTTON.LEFT_INDEX_TRIGGER;

func _ready():
	controller = get_parent().get_node(controller_name);
	if (not controller is ARVRController):
		vr.log_error(" in Feature_Collide: parent not ARVRController.");
	
func _integrate_forces(state):
	var target_position = controller.get_palm_transform().origin
	var current_position = get_global_transform().origin
	var current_transform = get_global_transform()
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
	var target_dir = (target_position - current_position).normalized()
	#var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
	#var position = up_dir * (rotation_angle / state.get_step())
	#state.set_angular_velocity(position)
	#state.add_force(target_dir, position)
	#print(target_dir)	
	#state.add_central_force(target_dir)	
	state.set_linear_velocity(target_dir)
	#if collided:
		#add_force(Vector3(0.1,0.1,0.1), controller.get_palm_transform().origin)
	#if(state.get_contact_count() > 0):
	#	collided = true
	#else:
	#	collided = false	
	#else:
		#print('adding force')
		#add_force(Vector3(0.1,0.1,0.1), controller.get_palm_transform().origin)	
	

func _physics_process(delta):
	if(vr.button_just_pressed(trigger_button)):
		print('pressed')
		pressed = true
	if(vr.button_just_released(trigger_button)):
		print('released')
		pressed = false
		if playing:
			emit_signal("oq_collision_ended", self, controller)
			playing = false
		
	
	#if !collided:
	#	global_transform = controller.get_palm_transform()

#	if !collided:
#		body.global_transform = controller.get_palm_transform()
#	area.global_transform = controller.get_palm_transform()
#	var overlapping_bodies = area.get_overlapping_bodies();
#	for b in overlapping_bodies:            
#		if(!collided):
#			collided = true			
#			emit_signal("oq_collision_started", body, controller)		
#			
##	if(overlapping_bodies.size() == 0):		
#		if(collided):
#			emit_signal("oq_collision_ended", body, controller)
#			collided = false

func _on_RigidBody_body_entered(body):
	if pressed:
		if !playing:	
			emit_signal("oq_collision_started", self, controller)
			playing = true
		else:
			emit_signal("oq_colliding", self, controller)


func _on_RigidBody_body_exited(body):
	pass
	#print('rb exited')
	#collided = false
