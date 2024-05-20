extends Node

var MainMenu : PackedScene
var Settings : PackedScene
var Upgrades : PackedScene
var Game : PackedScene
var LevelEditor : PackedScene
var GameOver : PackedScene

func initialize() -> void:
	MainMenu = load("res://Intro.tscn")
	Settings = load("res://Settings.tscn")
	Upgrades = load("res://Upgrades.tscn")
	Game = load("res://Dunkanoid.tscn")
	LevelEditor = load("res://LevelEditor.tscn")
	GameOver = load("res://GameOver.tscn")
	
