extends Spatial

var body: RigidBody = null;
var area: Area = null; 
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
	area = $Area	
	
func _physics_process(_dt):
	if !collided:
		body.global_transform = controller.get_palm_transform();
	area.global_transform = controller.get_palm_transform()
	var overlapping_bodies = area.get_overlapping_bodies();
	for b in overlapping_bodies:            
		if(!collided):
			collided = true			
			emit_signal("oq_collision_started", body, controller)		
			
	if(overlapping_bodies.size() == 0):		
		if(collided):
			emit_signal("oq_collision_ended", body, controller)
			collided = false
	
func _on_GrabArea_body_entered(body):	
	if(collided):
		emit_signal("oq_colliding", body, controller)				
