extends Node3D
class_name Reel

signal rotation_stopped(rl :Reel)
var 번호 :int
var card_size :Vector2
var card_list :Array
var color_list :Array[Color]
var 칸들 :Array[칸]
var 한칸각도 :float

func calc_radius() -> float:
	return card_list.size() * card_size.y / (2*PI)

func init(n :int, card_sizea :Vector2, card_lista :Array, color_lista :Array[Color]) -> Reel:
	번호 = n
	card_size = card_sizea
	card_list = card_lista
	color_list = color_lista
	var count := card_list.size()
	한칸각도 = 2*PI / count

	var r := count * card_size.y / (2*PI)
	for i in count:
		var k :칸 = preload("res://reel/칸/칸.tscn").instantiate().init(i, card_size,r,card_list[i], color_list[i%color_list.size()])
		k.rotation.x = 2*PI/count *i
		add_child(k)
		칸들.append(k)

	$MeshInstance3D.mesh.material.albedo_color = Color.WHITE
	$MeshInstance3D.mesh.top_radius = calc_radius()
	$MeshInstance3D.mesh.bottom_radius = $MeshInstance3D.mesh.top_radius
	$MeshInstance3D.mesh.height = card_size.x
	$MeshInstance3D.mesh.radial_segments = card_list.size()
	$MeshInstance3D.rotation.x = 한칸각도/2

	return self

func _process(delta: float) -> void:
	if 회전중인가:
		돌리기(delta)

var 회전중인가 :bool # need emit
var rotation_per_second :float
var acceleration := 0.3 # per second
func 돌리기(dur_sec :float = 1.0) -> void:
	rotation.x += rotation_per_second * 2 * PI * dur_sec
	if acceleration > 0:
		rotation_per_second *= pow( acceleration , dur_sec)
	if 회전중인가 and abs(rotation_per_second) <= 0.01:
		회전중인가 = false
		rotation_per_second = 0.0
		rotation_stopped.emit(self)

# spd : 초당 회전수
func 돌리기시작(spd :float) -> void:
	rotation_per_second = spd
	회전중인가 = true

func 멈추기시작(accel :float=0.5) -> void:
	assert(accel < 1.0)
	acceleration = accel

func 칸중심각도(n :int) -> float:
	return 한칸각도 * n

func 선택된칸번호() -> int:
	var 현재각도 = fposmod(-rotation.x, 2*PI)
	return ceili( (현재각도-한칸각도/2) / 한칸각도 ) % 칸들.size()

func 선택된칸얻기() -> 칸:
	return 칸들[선택된칸번호()]
