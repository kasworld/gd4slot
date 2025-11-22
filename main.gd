extends Node3D

const AnimationDuration := 1.0

var main_animation := Animation3D.new()
func main_animation_ended(_node :Node3D, _ani :Dictionary) -> void:
	if main_animation.is_empty():
		start_all_animation()
func start_rotate_animation(nd :Node3D, axis :int, ani_dur :float) -> void:
	var diff :float = [PI/2,-PI/2].pick_random()
	main_animation.start_rotate_subfield("ani_rot", nd, axis , nd.rotation[axis], nd.rotation[axis] + diff, ani_dur)
func start_all_animation() -> void:
	pass

var slot :Slots

func _ready() -> void:
	get_viewport().size_changed.connect(on_viewport_size_changed)
	var vp_size = get_viewport().get_visible_rect().size
	var 짧은길이 = min(vp_size.x,vp_size.y)
	$"왼쪽패널".size = Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$오른쪽패널.size = Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)

	var msgrect = Rect2( vp_size.x * 0.1 ,vp_size.y * 0.4 , vp_size.x * 0.8 , vp_size.y * 0.25 )
	$TimedMessage.init(80, msgrect, tr("gd4slot 2.0.0"))
	$TimedMessage.panel_hidden.connect(message_hidden)
	$TimedMessage.show_message("",0)

	main_animation.animation_ended.connect(main_animation_ended)
	start_all_animation()
	slot = preload("res://slots/slots.tscn").instantiate().init()
	add_child(slot)
	slot.rotation_stopped.connect(슬롯멈춤)

	$AxisArrow3D.set_size(slot.calc_radius())

	$OmniLight3D.position = slot.calc_center() + Vector3( 0, 0, slot.calc_radius()*2)
	$OmniLight3D.omni_range = slot.calc_size().length()*2
	reset_camera_pos()

func 슬롯멈춤(sl :Slots) -> void:
	var 칸들 := sl.선택된칸들얻기()
	var 결과 := ""
	for k in 칸들:
		결과 += k.글내용 + " "
	$"왼쪽패널/점수".text = 결과

func random_color()->Color:
	return NamedColorList.color_list.pick_random()[0]

func on_viewport_size_changed():
	pass

func message_hidden(_s :String) -> void:
	pass

var camera_move = false
func _process(_delta: float) -> void:
	if camera_move:
		$MovingCameraLight.make_current()
		$MovingCameraLight.move_hober_around_z(
			slot.calc_center(),
			slot.calc_width(),
			slot.calc_radius()*1.5,
			-3.0 )
	main_animation.handle_animation()

var key2fn = {
	KEY_ESCAPE : _on_button_esc_pressed,
	KEY_ENTER : _on_카메라변경_pressed,
	KEY_INSERT:_on_button_fov_up_pressed,
	KEY_DELETE:_on_button_fov_down_pressed,
	KEY_SPACE : _on_돌리기_pressed,
}
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()

func _on_카메라변경_pressed() -> void:
	camera_move = !camera_move
	if camera_move == false:
		reset_camera_pos()

func reset_camera_pos()->void:
	$FixedCameraLight.make_current()
	$FixedCameraLight.set_center_pos_far(
		slot.calc_center(),
		Vector3( 0, 0, slot.calc_radius() + slot.calc_width() ),
		slot.calc_size().length()*2)

func _on_button_fov_up_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_dec()

func _on_돌리기_pressed() -> void:
	slot.돌리기시작()
