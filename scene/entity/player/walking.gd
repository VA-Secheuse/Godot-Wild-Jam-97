extends State

var player : Player

func Enter():
	player = owner

func Update(_delta:float):
	if (player.velocity.x < 0):
		$"../../Sprite2D".flip_h = false
	elif(player.velocity.x > 0):
		$"../../Sprite2D".flip_h = true
	
	if(Input.get_vector("Left","Right","Up","Down") != Vector2(0,0)):
		player.velocity = Input.get_vector("Left","Right","Up","Down") * player.speed
		player.move_and_slide()
	else:
		Transitioned.emit(self,"Idle")
