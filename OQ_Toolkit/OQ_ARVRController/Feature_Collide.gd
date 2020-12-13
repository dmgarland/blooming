extends Spatial

var body : RigidBody = null;
var controller : ARVRController = null;

signal oq_collision_started;
signal oq_colliding;
signal oq_collision_ended;

var collided = false;

export(vr.CONTROLLER_BUTTON) var grab_button = vr.CONTROLLER_BUTTON.GRIP_TRIGGER;

func _ready():
	controller = get_parent();
	if (not controller is ARVRController):
		vr.log_error(" in Feature_Collide: parent not ARVRController.");
	body = $RigidBody;
	
	
func _physics_process(_dt):
	body.global_transform = controller.get_palm_transform();
	
	if(collided):
		emit_signal("oq_colliding", controller)
		
func _on_GrabArea_body_entered(body):
	print('body entered')
	if(!collided):
		emit_signal("oq_collision_started", body, controller)		
		collided = true


func _on_GrabArea_body_exited(body):
	print('body exited')
	if(collided):
		emit_signal("oq_collision_ended", body, controller)
		collided = false
	
