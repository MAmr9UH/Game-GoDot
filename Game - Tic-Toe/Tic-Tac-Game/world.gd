extends Node2D
@export var o_scene:PackedScene
@export var X_scene:PackedScene
var winner:int
var player:int 
var temp_marker
var panel_player : Vector2i
var grid_data: Array
var grid :Vector2i
var board_size: Vector2
var moves:int
var cell_size: Vector2
 
var row_size:int 
var clo_size:int
var diag1_size:int 
var diag2_size:int




	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	board_size=Vector2(410,275)
	cell_size=board_size/3
	panel_player=Vector2(870,470)
	
	
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Check if the mouse is in the game area
			if event.position.x >= 160 and event.position.x <= 567 and \
					event.position.y >= 240 and event.position.y <= 514:
				
				# Calculate the row and column indices of the clicked cell
				var col_index = int((event.position.x - 160) / cell_size.x)
				var row_index = int((event.position.y - 240) / cell_size.y)
				if grid_data[col_index][row_index]==0 :
					moves+=1
				# Print the coordinates
					grid_data[col_index][row_index]=player
					
					
					

					var marker_position=Vector2(160 + col_index * cell_size.x + cell_size.x / 2,
											  240 + row_index * cell_size.y + cell_size.y / 2)
					
					create_marker(player, marker_position)
					if check_win()!=0 :
						print("GAME is finished ")
						get_tree().paused=true
						$gmaeover.show()
						if winner==1:
							$gmaeover.get_node("Rlabel").text= "Player 1 Wins"
						elif winner==-1:
							$gmaeover.get_node("Rlabel").text= "Player 1 Wins"
						
					elif moves==9:
						
						get_tree().paused=true
						$gmaeover.show()
						$gmaeover.get_node("Rlabel").text= "No One Wins"
						
					player*=-1
					temp_marker.queue_free()
					create_marker(player, panel_player,true)
					
					
					print(grid_data)
					
					
func new_game():
	winner=0
	player=1
	moves=0
	grid_data=[
	[0,0,0], 
	[0,0,0], 
	[0,0,0]
	]
	
	row_size=0
	clo_size=0
	diag1_size=0
	diag2_size=0
	#clear markers
	get_tree().call_group("circles","queue_free")
	get_tree().call_group("crosses","queue_free")

	create_marker(player, panel_player, true)
	$gmaeover.hide()
	get_tree().paused=false
	

func check_win():
	for i in len(grid_data):
		row_size= grid_data[i][0] +grid_data[i][1] + grid_data[i][2] 
		clo_size= grid_data[0][i]+grid_data[1][i] + grid_data[2][i]
		diag1_size=grid_data[0][0]+grid_data[1][1]+grid_data[2][2]
		diag2_size=grid_data[2][0]+grid_data[1][1]+ grid_data[0][2]

		if row_size==3 or clo_size==3  or diag1_size==3 or diag2_size==3 :
			winner=1
		elif row_size==-3 or clo_size==-3  or diag1_size==-3 or diag2_size==-3 :
			winner=-1
	return winner





func create_marker(player, position, temp= false):
	# Create marker and add it 
	if player == 1:
		var circle_instance = o_scene.instantiate()
		
		# Adjust the position to the center of the grid square
		circle_instance.position = position
		
		# Add the circle instance as a child of the current node
		add_child(circle_instance)
		if temp: temp_marker= circle_instance
		
		
	else :
		var X = X_scene.instantiate()
		
		# Adjust the position to the center of the grid square
		X.position = position
		
		# Add the x instance as a child of the current node
		add_child(X)
		if temp: temp_marker= X


func _on_gmaeover_restart():
	new_game()
