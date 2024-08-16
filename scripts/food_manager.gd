extends Node

var array: Array = []

func get_food() -> Food:
	return array.front()
	
func register_food(food: Food):
	array.append(food)
	
func unregister_food(food: Food):
	array.erase(food)
