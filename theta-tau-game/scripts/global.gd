# global.gd
extends Node

var player_current_attack = false
var curHealth = 100
var boss_current_attack = false
var goon_current_attack = false
var boss_enter = false

const background_music = preload("res://background_music.wav")
const boss_music = preload("res://Boss_Music.wav")

var music_player

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.stream = background_music
	add_child(music_player)
	music_player.play()

func switch_to_boss_music():
	if music_player:
		music_player.stop()
		music_player.stream = boss_music
		music_player.play()
func stop_music():
	if music_player:
		music_player.stop()
