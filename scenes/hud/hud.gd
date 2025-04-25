extends CanvasLayer

##################################################
var fps_label: Label
# FPS를 표시할 Label 변수 선언

##################################################
func _ready() -> void:
	fps_label = $FPSLabel
	# FPSLabel 노드를 가져와 fps_label 변수에 저장

##################################################
func _process(delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"
	# FPS 정보를 가져와 Label의 텍스트로 설정
