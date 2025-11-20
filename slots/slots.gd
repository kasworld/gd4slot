extends Node3D
class_name Slots

var reellist := []

func init() -> Slots:
	var cardcount := 13
	var colorlist := NamedColorList.make_dark_color_list()
	var cardlist := PlayingCard.make_deck()
	var clist :Array[Color] =[]
	for c in colorlist:
		clist.append(c[0])
	var cardsize := Vector2(10,5)
	var radius := cardcount * cardsize.y / (2*PI)
	var reelcount := 4
	for i in reelcount:
		clist.shuffle()
		var rl = preload("res://reel/reel.tscn").instantiate().init(i, cardsize, cardlist.slice(i*cardcount,i*cardcount+cardcount), clist)
		rl.position =  Vector3(i*cardsize.x+i, 0, 0)
		add_child(rl)
		reellist.append(rl)

	var arrow_left = preload("res://arrow3d/arrow_3d.tscn").instantiate().set_color(random_color()).set_size(5,0.2,0.6)
	arrow_left.position = reellist[0].position + Vector3(-cardsize.x/2-2.5,0,radius)
	arrow_left.rotation.z = -PI/2
	add_child(arrow_left)
	var arrow_right = preload("res://arrow3d/arrow_3d.tscn").instantiate().set_color(random_color()).set_size(5,0.2,0.6)
	arrow_right.position = reellist[-1].position + Vector3(cardsize.x/2 +2.5,0,radius)
	arrow_right.rotation.z = PI/2
	add_child(arrow_right)
	return self

func random_color()->Color:
	return NamedColorList.color_list.pick_random()[0]

func 돌리기시작() -> void:
	for r in reellist:
		var rot = randfn(2*PI, PI/2)
		if randi_range(0,1) == 0:
			rot = -rot
		r.돌리기시작(rot)
