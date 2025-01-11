extends GridContainer

@onready var audio_player = $AudioStreamPlayer  # Reference to the AudioStreamPlayer
@onready var info_label = get_node('../Label')
var sound_queue = []  # List to hold the queue of sounds


func _ready():
	# first customized that size
	var font_size = 24  # Desired font size
	
	for button in self.get_children():
		if button is Button:
			button.set_custom_minimum_size(Vector2(100, 100))
			# Get the button's default font
		
	# Connect the finished signal of the AudioStreamPlayer
	audio_player.connect("finished", Callable(self, "_on_audio_finished"))

	for button in self.get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))
			#button.connect("pressed", "_on_button_pressed")


func _on_button_pressed(button: Button):
	var button_text = button.text
	# Play the default beep sound first
	queue_next_sound("res://audio/button_beep.wav")  # Replace with your default beep sound path

	# Queue the button-specific sound to be played next
	match button_text:
		'1':
			queue_next_sound("res://audio/pay_rent.mp3")
			info_label.text = "Paying Rent..."
		'2':
			queue_next_sound("res://audio/check_balance.mp3")
			info_label.text = 'balance'
		"3":
			queue_next_sound("res://audio/outage.mp3")
			info_label.text = 'outage'
		"9":
			queue_next_sound("res://audio/help.mp3")
		_:
			print('bruh') # No specific sound for unmatched buttons

func queue_next_sound(audio_path: String):
	sound_queue.append(audio_path)  # Add the sound path to the queue
	if not audio_player.is_playing():
		play_next_sound()  # If nothing is currently playing, start playing

func play_next_sound():
	if sound_queue.size() > 0:
		var next_sound_path = sound_queue.pop_front()  # Remove the first element and get it
		play_voice(next_sound_path)

func _on_audio_finished():
	play_next_sound()  # Play the next sound in the queue when the current one finishes

func play_voice(audio_path: String):
	var sound = load(audio_path) as AudioStream
	if sound:
		audio_player.stream = sound
		audio_player.play()
	else:
		print("Failed to load sound:", audio_path)
