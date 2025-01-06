extends Control

# Reference to the AudioStreamPlayer
@onready var beep_player = $AudioStreamPlayer

func _ready():
	for button in $GridContainer.get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))

func _on_button_pressed(button):
	print("Button pressed:", button.text)
	beep_player.play()
