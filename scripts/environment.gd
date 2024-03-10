extends Node

var timer_max : Dictionary = {
    "kamikaze_spawn_limit": 0.3,
    "kamikaze_cooldown": 5,
    "floater_cooldown": 9,
    "hunter_cooldown": 5
}

const kamikaze_wave_start : int = 5
const kamikaze_spawn_min : int = 0.16
const kamikaze_cooldown_min : int = 2
var kamikaze_wave : int = kamikaze_wave_start
var kamikaze_increase : int = 1
var kamikaze_max : int = 20

const floater_cooldown_min : int = 4

const hunter_cooldown_min : int = 2