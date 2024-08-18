extends Node2D


static func spawn(particles: Resource, position: Vector2):
	var particles_instance = particles.instantiate()
	particles_instance.global_position = position
	
	if particles_instance.has_method("restart"):
		particles_instance.restart()
	
	ParticlesHandler.add_child(particles_instance)
