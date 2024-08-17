extends Node

var dictionary = {}
var highest_priority = -INF

func register_object(object: ObjectOfInterest):
	dictionary.get_or_add(object.priority, []).append(object)
	refresh_highest_priority()
	
func unregister_object(object: ObjectOfInterest):
	if !dictionary.has(object.priority):
		return
	var array = dictionary[object.priority] as Array[ObjectOfInterest]
	if !array.has(object):
		return
	array.erase(object)
	if array.size() == 0:
		dictionary.erase(object.priority)
	refresh_highest_priority()
	
func refresh_highest_priority():
	highest_priority = -INF
	for key in dictionary:
		if key > highest_priority:
			highest_priority = key
	
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
