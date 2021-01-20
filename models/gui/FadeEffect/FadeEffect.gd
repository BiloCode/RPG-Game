extends CanvasLayer

signal onFadeInEnd;
signal onFadeOutEnd;

func _ready():
	$Animation.play("FadeIn");

func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"FadeIn":
			emit_signal("onFadeInEnd");
			$Animation.play("FadeOut");
		"FadeOut":
			emit_signal("onFadeOutEnd");
			queue_free();
