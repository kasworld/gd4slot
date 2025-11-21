extends Node3D
class_name Slots

signal rotation_stopped(s :Slots)

var colorlist :Array = NamedColorList.filter_to_colorlist(NamedColorList.make_dark_color_list())
var cardlist :Array = PlayingCard.make_deck_with_joker()
var cardsize := Vector2(10,5)
var reelcount := 4
var reellist := []

func init() -> Slots:
	for i in reelcount:
		var cdlist := cardlist.duplicate()
		cdlist.shuffle()
		var colist := colorlist.duplicate()
		colist.shuffle()
		var rl = preload("res://reel/reel.tscn").instantiate().init(i, cardsize, cdlist, colist)
		rl.rotation_stopped.connect(결과가결정됨)
		rl.position =  Vector3(i*cardsize.x+i, 0, 0)
		add_child(rl)
		reellist.append(rl)

	$Bar.mesh.material.albedo_color = Color.GOLD
	$Bar.mesh.top_radius = 0.1
	$Bar.mesh.bottom_radius = $Bar.mesh.top_radius
	$Bar.mesh.height = calc_width()
	$Bar.position = (reellist[-1].position + reellist[0].position) /2 + Vector3(0,0,reellist[0].calc_radius()*1.1)

	return self

func calc_radius() -> float:
	return reellist[0].calc_radius()

func calc_width() -> float:
	return (reellist[-1].position -reellist[0].position).x + cardsize.x

func calc_size() -> Vector3:
	return Vector3(calc_width(),calc_radius()*2,calc_radius()*2)

func calc_center() -> Vector3:
	return Vector3(calc_width()/2,0,0)

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

func random_color()->Color:
	return NamedColorList.color_list.pick_random()[0]

func 돌리기시작() -> void:
	for r in reellist:
		var rot = randfn(2*PI, PI/2)
		if randi_range(0,1) == 0:
			rot = -rot
		r.돌리기시작(rot)
