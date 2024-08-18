extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreatureSingleton.creature.hunger_modified.connect(refresh)
	$TextureProgressBar.value = CreatureSingleton.creature.max_hunger


# Called every frame. 'delta' is the elapsed time since the previous frame.
func refresh(old_hunger, new_hunger):
	#print("hunger changed from %s to %s" % [old_hunger,new_hunger])
	$TextureProgressBar.value = new_hunger
