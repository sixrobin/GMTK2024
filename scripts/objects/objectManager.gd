extends Node

var array: Array[ObjectOfInterest] = []

func get_first_object() -> ObjectOfInterest:
	return array.front() if array.size() > 0 else null
	
func register_object(object: ObjectOfInterest):
	array.append(object)
	
func unregister_object(object: ObjectOfInterest):
	array.erase(object)
