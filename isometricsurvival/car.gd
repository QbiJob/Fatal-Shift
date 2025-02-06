extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 200.0
@export var friction: float = 100.0
@export var rotation_speed: float = 2.0
var is_player_inside: bool = false
var player = null
var in_zone = false
var speed = 0
var decerelation = 500

@onready var camera = $Camera2D

func _input(event):
	if event.is_action_pressed("ui_interact"):
		if is_player_inside and player:
			exit_car()
		else:
			enter_car()

func enter_car():
	if in_zone:
		$CollisionShape2D.disabled = true
		is_player_inside = true
		player.hide()  
		if camera:
			camera.make_current()  

func exit_car():
	$CollisionShape2D.disabled = false
	is_player_inside = false
	player.show()  
	player.global_position = global_position  
	if camera:
		player.get_node("Camera2D").make_current() 

func _process(delta):
	if is_player_inside:
		handle_movement(delta)
	if is_player_inside and player != null:
		player.global_position = global_position
		

func handle_movement(delta):
	var direction = Vector2(0,0)
	
	if Input.is_action_pressed("player_up"):
		direction.y -= 1
	if Input.is_action_pressed("player_down"):
		direction.y += 1
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
	if Input.is_action_pressed("player_right"):
		direction.x += 1
	direction = direction.normalized()

	if direction != Vector2.ZERO:
		rotation = lerp_angle(rotation, direction.angle(), rotation_speed * delta)
		velocity = Vector2(max_speed,0).rotated(rotation)
		speed +=acceleration * delta
		speed = min(speed, max_speed)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		speed -= decerelation * delta
		speed = min(speed, max_speed)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_zone = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_zone = false
		player = null
