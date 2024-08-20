extends Node

signal new_highest_priority(previous_highest, new_highest)
var dictionary = {}
var all_objects: Array[ObjectOfInterest]
var highest_priority = -INF

func register_object(object: ObjectOfInterest):
	all_objects.append(object)

func unregister_object(object: ObjectOfInterest):
	all_objects.erase(object)

func register_object_priority(object: ObjectOfInterest, priority: int):
	var array = dictionary.get_or_add(priority, [])
	if array.has(object):
		return
	array.append(object)
	refresh_highest_priority()
	
func unregister_object_priority(object: ObjectOfInterest, priority: int):
	if !dictionary.has(priority):
		return
	var array = dictionary[priority] as Array[ObjectOfInterest]
	if !array.has(object):
		return
	array.erase(object)
	if array.size() == 0:
		dictionary.erase(priority)
	refresh_highest_priority()
	
func refresh_highest_priority():
	var old_priority = highest_priority
	highest_priority = -INF
	for key in dictionary:
		if key > highest_priority:
			highest_priority = key
	if highest_priority != old_priority:
		new_highest_priority.emit(old_priority, highest_priority)

func get_any_random():
	all_objects.sort_custom(sort_by_distance)
	return all_objects.front()

func get_best_object() -> ObjectOfInterest:
	if dictionary.size() == 0:
		return null
	var array = dictionary[highest_priority] as Array[ObjectOfInterest]
	array.sort_custom(sort_by_distance)
	return array.front()

func sort_by_distance(a: ObjectOfInterest, b: ObjectOfInterest):
	var creaturePosition = CreatureSingleton.creature.position
	if a.global_position.distance_squared_to(creaturePosition) < b.global_position.distance_squared_to(creaturePosition):
		return true
	return false;
