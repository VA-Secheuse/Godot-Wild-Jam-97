extends State

func Update(_delta:float):
	if(Input.is_action_pressed("Up") || Input.is_action_pressed("Down") || Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
		Transitioned.emit(self,"Walking")
