extends Node3D
class_name Slots

signal rotation_stopped(s :Slots)

var reellist := []
var cardcount :int = 13
var colorlist :Array = NamedColorList.make_dark_color_list()
var cardlist :Array = PlayingCard.make_deck()
var cardsize := Vector2(10,5)
func init() -> Slots:
	var clist :Array[Color] =[]
	for c in colorlist:
		clist.append(c[0])
	var radius := calc_radius()
	var reelcount := 4
	for i in reelcount:
		clist.shuffle()
		var rl = preload("res://reel/reel.tscn").instantiate().init(i, cardsize, cardlist.slice(i*cardcount,i*cardcount+cardcount), clist)
		rl.rotation_stopped.connect(결과가결정됨)
		rl.position =  Vector3(i*cardsize.x+i, 0, 0)
		add_child(rl)
		reellist.append(rl)

	$Bar.mesh.material.albedo_color = Color.GOLD
	$Bar.mesh.top_radius = 0.1
	$Bar.mesh.bottom_radius = $Bar.mesh.top_radius
	$Bar.mesh.height = (reellist[-1].position -reellist[0].position).x + cardsize.x
	$Bar.position = (reellist[-1].position + reellist[0].position) /2 + Vector3(0,0,radius*1.1)

	#var arrow_left = preload("res://arrow3d/arrow_3d.tscn").instantiate().set_color(random_color()).set_size(5,0.2,0.6)
	#arrow_left.position = reellist[0].position + Vector3(-cardsize.x/2-2.5,0,radius)
	#arrow_left.rotation.z = -PI/2
	#add_child(arrow_left)
	#var arrow_right = preload("res://arrow3d/arrow_3d.tscn").instantiate().set_color(random_color()).set_size(5,0.2,0.6)
	#arrow_right.position = reellist[-1].position + Vector3(cardsize.x/2 +2.5,0,radius)
	#arrow_right.rotation.z = PI/2
	#add_child(arrow_right)
	return self

func 결과가결정됨( _rl :Reel) -> void:
	var 모두멈추었나 = true
	for n in reellist:
		if n.회전중인가:
			모두멈추었나 = false

	if 모두멈추었나:
		rotation_stopped.emit(self)

func 선택된칸들얻기() -> Array:
	var rtn := []
	for n in reellist:
		rtn.append(n.선택된칸얻기())
	return rtn

func calc_radius() -> float:
	return cardcount * cardsize.y / (2*PI)

func random_color()->Color:
	return NamedColorList.color_list.pick_random()[0]

func 돌리기시작() -> void:
	for r in reellist:
		var rot = randfn(2*PI, PI/2)
		if randi_range(0,1) == 0:
			rot = -rot
		r.돌리기시작(rot)
