extends CharacterBody2D

func hit(damage):
	get_node('..').hit(damage)
