class_name Player
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gun_point: Marker2D = $GunPoint

@export var bullet_scene: PackedScene

@export var speed: int

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

@rpc("call_local")
func shoot():
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.transform = gun_point.global_transform
	
func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc()
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
