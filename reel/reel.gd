extends Node3D
class_name Reel

signal rotation_stopped(rl :Reel)
var 번호 :int
var 칸크기 :Vector2
var 칸정보목록 :Array # [ text, color ]
var 칸들 :Array[칸]
var 한칸각도 :float

func calc_radius() -> float:
	return 칸정보목록.size() * 칸크기.y / (2*PI)

func init(n :int, 칸크기a :Vector2, 칸정보목록a :Array) -> Reel:
	번호 = n
	칸크기 = 칸크기a
	칸정보목록 = 칸정보목록a
	var count := 칸정보목록.size()
	한칸각도 = 2*PI / count

	var r := count * 칸크기.y / (2*PI)
	for i in count:
		var k :칸 = preload("res://reel/칸/칸.tscn").instantiate().init(i, 칸크기,r,칸정보목록[i][0], 칸정보목록[i][1])
		k.rotation.x = 2*PI/count *i
		add_child(k)
		칸들.append(k)

	$MeshInstance3D.mesh.material.albedo_color = Color.WHITE
	$MeshInstance3D.mesh.top_radius = calc_radius()
	$MeshInstance3D.mesh.bottom_radius = $MeshInstance3D.mesh.top_radius
	$MeshInstance3D.mesh.height = 칸크기.x
	$MeshInstance3D.mesh.radial_segments = 칸정보목록.size()
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
	#if 회전중인가 and abs(rotation_per_second) <= 0.01:
	if 회전중인가 and (abs(rotation_per_second) <= 0.1 and 칸중심근처인가()) or (abs(rotation_per_second) <= 0.01):
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

func 칸중심근처인가() -> bool:
	var 현재각도 = fposmod(-rotation.x, 2*PI)
	var 중심각도 = 칸중심각도(선택된칸번호())
	return abs(현재각도 - 중심각도) <= 한칸각도/100

func 선택된칸번호() -> int:
	var 현재각도 = fposmod(-rotation.x, 2*PI)
	return ceili( (현재각도-한칸각도/2) / 한칸각도 ) % 칸들.size()

func 선택된칸얻기() -> 칸:
	return 칸들[선택된칸번호()]
