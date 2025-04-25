extends Node2D

##################################################
const WATER_DROP_SCENE: PackedScene = \
preload("res://scenes/water_drop/water_drop.tscn")
# 물방울 장면 프리로드
const spawn_interval: float = 0.025
# 물방울 생성 간격 설정

var spawn_timer: float = 0.0
# 물방울 생성 타이머 초기화

##################################################
func _process(delta: float) -> void:
	spawn_timer -= delta
	# 프레임 델타 값만큼 타이머 감소
	
	if spawn_timer <= 0:
	# 타이머가 0 이하일 때
		spawn_water()
		# 물방울 생성 함수 호출
		spawn_timer = spawn_interval
		# 타이머를 재설정

##################################################
func spawn_water() -> void:
	var water_drop_scene: RigidBody2D = WATER_DROP_SCENE.instantiate()
	# 물방울 장면 인스턴스화
	water_drop_scene.position = Vector2(630.0, -10.0)
	# 물방울 위치 설정
	water_drop_scene.linear_velocity += Vector2(randf_range(-10, 10), 0)
	# 물방울에 무작위 x축 속도를 추가
	add_child(water_drop_scene)
	# 인스턴스화된 물방울을 현재 노드의 자식으로 추가
