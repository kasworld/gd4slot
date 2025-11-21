extends Node3D
class_name 칸

var 글내용 :String
var 번호 :int

func init(n :int, sz :Vector2, r :float, t :String, co :Color) -> 칸:
	번호 = n
	글내용 = t
	$"판".mesh.size = sz
	$"글".mesh.text = 글내용
	$"글".mesh.font_size = sz.y*10
	$"글".mesh.material.albedo_color = co
	$"판".position.z = r
	$"글".position.z = r
	return self
