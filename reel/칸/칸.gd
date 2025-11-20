extends Node3D
class_name 칸

func init(sz :Vector2, r :float, t :String, co :Color) -> 칸:
	$"판".mesh.size = sz
	$"글".mesh.text = t
	$"글".mesh.font_size = sz.y*10
	$"글".mesh.material.albedo_color = co
	$"판".position.z = r
	$"글".position.z = r
	return self
