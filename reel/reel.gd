extends Node3D
class_name Reel

func init(card_size :Vector2, card_list :Array, color_list :Array[Color]) -> Reel:
	var count := card_list.size()
	var r := count * card_size.y / (2*PI)
	for i in count:
		var k :칸 = preload("res://reel/칸/칸.tscn").instantiate().init(card_size,r,card_list[i], color_list[i])
		k.rotation.x = 2*PI/count *i
		add_child(k)
	return self
