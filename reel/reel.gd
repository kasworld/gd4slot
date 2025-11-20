extends Node3D
class_name Reel

signal rotation_stopped(n :int)
var id :int
var card_size :Vector2
var card_list :Array
var color_list :Array[Color]
var 칸들 :Array[칸]
var 선택rad :float = 0.0

func init(n :int, card_sizea :Vector2, card_lista :Array, color_lista :Array[Color]) -> Reel:
	id = n
	card_size = card_sizea
	card_list = card_lista
	color_list = color_lista

	var count := card_list.size()
	var r := count * card_size.y / (2*PI)
	for i in count:
		var k :칸 = preload("res://reel/칸/칸.tscn").instantiate().init(card_size,r,card_list[i], color_list[i])
		k.rotation.x = 2*PI/count *i
		add_child(k)
		칸들.append(k)
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
	if 회전중인가 and abs(rotation_per_second) <= 0.001:
		회전중인가 = false
		rotation_per_second = 0.0
		rotation_stopped.emit(id)

# spd : 초당 회전수
func 돌리기시작(spd :float) -> void:
	rotation_per_second = spd
	회전중인가 = true

func 멈추기시작(accel :float=0.5) -> void:
	assert(accel < 1.0)
	acceleration = accel

func 선택된칸얻기() -> 칸:
	if 칸들.size() == 0 :
		return null
	var rad = rotation.x - 선택rad - PI/2
	rad = fposmod(rad, 2*PI)
	var 칸rad = 2*PI / 칸들.size()
	for 현재칸번호 in 칸들.size():
		if 칸rad/2 + 현재칸번호*칸rad > rad:
			return 칸들[현재칸번호]
	return 칸들[0]
