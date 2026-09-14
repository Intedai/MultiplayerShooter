class_name Player
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gun_point: Marker2D = $GunPoint
@onready var score_label: Label = $Score
@onready var name_label: Label = $Name
@onready var shoot_cooldown: Timer = $ShootCooldown

@export var bullet_scene: PackedScene
@export var speed: int

@onready var chat: Chat = get_parent().get_node("UI").get_node("MarginContainer").get_node("Chat")

var score = 0
var can_move = true

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _ready() -> void:
	name_label.text = str(name)
	chat.chat_opened.connect(disable_movement)
	chat.chat_closed.connect(enable_movement)

func enable_movement():
	can_move = true

func disable_movement() -> void:
	can_move = false

@rpc("call_local")
func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.shooter = self
	get_parent().add_child(bullet)
	bullet.transform = gun_point.global_transform

@rpc("any_peer", "call_local", "reliable")
func add_score(amount: int) -> void:
	score += amount
	score_label.text = "Score: " + str(score)

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority() or !can_move:
		return

	if Input.is_action_just_pressed("shoot") and shoot_cooldown.is_stopped():
		shoot.rpc()
		shoot_cooldown.start()

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
	position.x = clamp(position.x, Constraints.x_limit[0], Constraints.x_limit[1])
