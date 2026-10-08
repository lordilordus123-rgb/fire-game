extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Kamera-Empfindlichkeit
@export var MOUSE_SENSITIVITY: float = 0.003

# Referenz zur Kamera
@onready var camera: Camera3D = $Camera3D

# Maus-Status
var mouse_captured: bool = true

func _ready() -> void:
	# Startet im fixierten Mausmodus
	_set_mouse_capture(true)

func _unhandled_input(event: InputEvent) -> void:
	# Freistellen / Sperren der Maus mit ESC (ui_cancel)
	if event.is_action_pressed("ui_cancel"):
		_set_mouse_capture(!mouse_captured)

	# Kamera drehen, wenn Maus gefangen ist
	if mouse_captured and event is InputEventMouseMotion:
		# Charakter um die Y-Achse drehen (links/rechts)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

# Diese Funktion hat gefehlt oder war an der falschen Stelle:
func _set_mouse_capture(capture: bool) -> void:
	mouse_captured = capture
	if capture:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	# Gravitation
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Sprung
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Bewegung: x = links/rechts, y = vor/zurück
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
