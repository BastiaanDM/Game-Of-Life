extends Node2D

@export var cell_scene : PackedScene
@export var slow_factor : int = 3
var row_count : int = 45
var column_count : int = 80
var cell_width : int = 15
var time : int = 0
var simulation_running : bool = false

var cell_matrix : Array = []
var previous_cell_state : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.time_scale = .05
	var rng = RandomNumberGenerator.new()
	for column in range(column_count):
		cell_matrix.push_back([])
		previous_cell_state.push_back([])
		for row in range(row_count):
			var cell = cell_scene.instantiate()
			self.add_child(cell)
			cell.position = Vector2(column * cell_width, row * cell_width)
			previous_cell_state[column].push_back(false)
			cell_matrix[column].push_back(cell)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(Input.is_action_pressed("quit")):
		get_tree().quit()
	if(!simulation_running):
		return
	run_simulation()
	pass


func get_next_state(column, row):
	var count = 0
	for i in range(-1,2):
		for j in range(-1,2):
			if(i==0 && j ==0):
				continue
			if(previous_cell_state[column+i][row+j]):
				count += 1
	if(previous_cell_state[column][row]):
		if(count < 2 || count >3):
			return false
		else: return true
	else:
		if(count == 3):
			return true
		else: return false

func is_edge(column, row):
	return column == 0 or row == 0 or column == column_count - 1 or row == row_count -1

func run_simulation():
	time += 1
	time %= slow_factor
	if(time != 0): return
	
	for column in range(column_count):
		for row in range(row_count):
			previous_cell_state[column][row] = cell_matrix[column][row].visible
	
	for column in range(column_count):
		for row in range(row_count):
			if !is_edge(column, row):
				cell_matrix[column][row].visible = get_next_state(column, row)
