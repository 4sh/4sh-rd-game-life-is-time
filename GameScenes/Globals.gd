extends Node

var level_attempts:int = 0
var help_protection:float = 0.0

func register_failed_level_attempt():
	level_attempts = level_attempts + 1
	help_protection = clamp(0.30 * pow(level_attempts, 1/2.0), 0, 0.80)
