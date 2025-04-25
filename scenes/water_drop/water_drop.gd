extends RigidBody2D

##################################################
const CIRCLE_RADIUS: float = 5.0
# 물방울의 반지름
const C_N_L_COLOR: Color = Color(0, 0.25, 0.5)
# 그리는 원과 선의 색상
const SCREE_SIZE: Vector2 = Vector2(640.0, 360.0)
# 화면 크기 정의
const LINE_WIDTH: float = 10.0
# 선의 두께

var connected_bodies: Array = []
# self(물방울)와 연결된 물방울들을 저장하는 배열

##################################################
func _ready() -> void:
	init_physics_material()
	# 물리 재질 초기화 함수
	z_index = -10
	# 그리기 레이어 순서 설정
	contact_monitor = true
	# 충돌 감지 활성화
	max_contacts_reported = 8
	# 보고할 최대 충돌 개수 설정
	add_to_group("WaterDrop")
	# "WaterDrop" 그룹에 이 노드 추가
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	# 충돌 신호 연결
	
	gravity_scale = 0.25
	# 중력 스케일 설정

##################################################
func _physics_process(delta: float) -> void:
	out_of_screen_n_erase()
	# 화면 밖으로 나가면 물방울을 삭제하는 함수
	check_body_n_erase()
	# 연결된 물체와의 거리 및 속도를 확인 후 삭제하는 함수

##################################################
func _process(delta: float) -> void:
	queue_redraw()
	# _draw()를 사용하기 때문에 그리기 요청

##################################################
func _draw() -> void:
	var local_position = to_local(global_position)
	draw_circle(local_position, CIRCLE_RADIUS, C_N_L_COLOR)
	# 물방울을 그리기
	
	for body in connected_bodies:
		if body:
			local_position = to_local(body.global_position)
			draw_line(Vector2.ZERO, local_position, C_N_L_COLOR, LINE_WIDTH)
			# 연결된 물방울과 선 그리기

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("WaterDrop") and not connected_bodies.has(body):
	# 그룹 "WaterDrop"에 속한 새로운 물체가 연결되면
		connected_bodies.append(body)
	# connected_bodies에 추가

##################################################
func init_physics_material() -> void:
	var physics_material_value: PhysicsMaterial = \
		PhysicsMaterial.new()
	# 물리 재질 초기화
	physics_material_value.friction = 0.0
	# 마찰 계수 설정
	physics_material_value.bounce = 0.2
	# 반발 계수 설정
	physics_material_override = physics_material_value
	# 물리 재질 설정

##################################################
func out_of_screen_n_erase() -> void:
	if global_position.x < -100.0 or \
	global_position.y > SCREE_SIZE.y + 100:
	# 노드가 화면 밖으로 벗어나면
		queue_free()
		# 삭제

##################################################
func check_body_n_erase() -> void:
	for body in connected_bodies:
		if body:
			var too_far = position.distance_to(body.position) > 50.0
			var too_slow = body.linear_velocity.length() < 4.0
			if too_far or too_slow:
			# 연결된 물체와의 거리 및 속도를 확인하여 조건에 따라
				connected_bodies.erase(body)
	 			# 연결 해제
