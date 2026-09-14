extends State

var player : Player

func Enter():
	player = owner

func Update(_delta:float):
	if(Input.get_vector("Left","Right","Up","Down") != Vector2(0,0)):
		player.velocity = Input.get_vector("Left","Right","Up","Down") * player.speed
		player.move_and_slide()
	else:
		Transitioned.emit(self,"Idle")
