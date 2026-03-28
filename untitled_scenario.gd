extends Node2D


func _ready() -> void:
	$MultiplayerSpawner.add_spawnable_scene("res://characters/kris_player.tscn")


func _process(delta: float) -> void:
	pass

var peer = ENetMultiplayerPeer.new()
var player_scene = preload("res://characters/kris_player.tscn")

func _on_host_pressed() -> void:
	var result = peer.create_server(8910)
	if result != OK:
		print("Falha ao criar servidor")
		return
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	
	# adiciona o host como o primeiro player
	_add_player(1)
	hide_ui()
	print("Servidor iniciado na porta 8910")

func _on_join_pressed() -> void:
	var result = peer.create_client("localhost", 8910)
	if result != OK:
		print("Falha ao conectar ao servidor")
		return
	multiplayer.multiplayer_peer = peer
	hide_ui()
	print("Conectando ao localhost...")

func hide_ui():
	$Host.visible = false
	$Join.visible = false

func _add_player(id: int):
	# apenas o servidor deve instanciar players se usar MultiplayerSpawner
	if not multiplayer.is_server():
		return
		
	var player = player_scene.instantiate()
	player.name = str(id)
	add_child(player)

func _remove_player(id: int):
	if not multiplayer.is_server():
		return
		
	if has_node(str(id)):
		get_node(str(id)).queue_free()
