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


var colorlist :Array = NamedColorList.filter_to_colorlist(NamedColorList.make_dark_color_list())
var cardlist :Array = PlayingCard.make_deck_with_joker()
func make_color_text_info_list() -> Array:
	var rtn := []
	for i in cardlist.size():
		rtn.append( [ colorlist[i%colorlist.size()], cardlist[i] ] )
	return rtn

var vp_size :Vector2
var slot :Slots
var symbol_size := Vector2(8,4)
var reel_count := 5

func _ready() -> void:
	timed_message_init()
	get_viewport().size_changed.connect(on_viewport_size_changed)
	var 짧은길이 = min(vp_size.x,vp_size.y)
	$"왼쪽패널".size = Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$오른쪽패널.size = Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)

	main_animation.animation_ended.connect(main_animation_ended)
	start_all_animation()
	slot = preload("res://slots/slots.tscn").instantiate().init(reel_count, symbol_size, make_color_text_info_list())
	add_child(slot)
	slot.rotation_stopped.connect(슬롯멈춤)

	$AxisArrow3D.set_size(slot.calc_radius()).set_colors()

	$OmniLight3D.position = Vector3( 0, 0, slot.calc_radius()*2)
	$OmniLight3D.omni_range = slot.calc_radius()*4
	set_fixedcamera_pos()

func timed_message_init() -> void:
	vp_size = get_viewport().get_visible_rect().size
	var msgrect := Rect2( vp_size.x * 0.1 ,vp_size.y * 0.4 , vp_size.x * 0.8 , vp_size.y * 0.25 )
	$TimedMessage.init(80, msgrect,
		"%s %s" % [
			ProjectSettings.get_setting("application/config/name"),
			ProjectSettings.get_setting("application/config/version")
			] )

	$TimedMessage.panel_hidden.connect(message_hidden)
	$TimedMessage.show_message("",0)


func 슬롯멈춤(sl :Slots) -> void:
	var symbol들 := sl.선택된symbol들얻기()
	var 결과 := ""
	for k in symbol들:
		결과 += k.글내용얻기() + " "
	$"왼쪽패널/점수".text = 결과

func random_color()->Color:
	return NamedColorList.color_list.pick_random()[0]

func on_viewport_size_changed():
	pass

func message_hidden(_s :String) -> void:
	pass

func _process(_delta: float) -> void:
	main_animation.handle_animation()
	var t := Time.get_unix_time_from_system() /2.3
	if $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(t,Vector3.ZERO,reel_count*symbol_size.x, slot.calc_radius()*1.5)
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(t,Vector3.ZERO,reel_count*symbol_size.x, slot.calc_radius()*1.5)

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
	MovingCameraLight.NextCamera()

func set_fixedcamera_pos()->void:
	$FixedCameraLight.set_center_pos_far(
		Vector3.ZERO,
		Vector3( 0, 0, slot.calc_radius() + reel_count*symbol_size.x ),
		slot.calc_radius()*4)

func _on_button_fov_up_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_dec()

func _on_돌리기_pressed() -> void:
	slot.돌리기시작()

func _on_h_slider_value_changed(value: float) -> void:
	slot.reel_list[0].rotation.x = deg_to_rad(value)
	$"오른쪽패널/LabelDebug".text = slot.reel_list[0].debug_str()
