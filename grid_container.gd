extends GridContainer

@onready var audio_player = $AudioStreamPlayer  # Reference to the AudioStreamPlayer
@onready var info_label = get_node('../Label')
var sound_queue = []  # List to hold the queue of sounds
var dial_sequence = []
var target_sequence = [8, 8, 8, 6, 6, 0, 5, 8, 9, 0]
var current_directory_path = "res://audio/voicebot1_main/"  # Start path


func _ready():
	# first customized that size
	var font_size = 24  # Desired font size
	
	for button in self.get_children():
		if button is Button:
			button.set_custom_minimum_size(Vector2(100, 100))
			# Get the button's default font
			
	var root_path = "res://audio/voicebot1_main"
	var folder_structure = read_directory_structure(root_path)
	print(folder_structure)
		
	# Connect the finished signal of the AudioStreamPlayer
	audio_player.connect("finished", Callable(self, "_on_audio_finished"))

	for button in self.get_children():
		if button is Button:
			button.connect("pressed", Callable(self, "_on_button_pressed").bind(button.text.to_int()))
			#button.connect("pressed", "_on_button_pressed")
			
# Function to recursively read directory structure and build a nested dictionary
func read_directory_structure(path):
	var structure = {}
	var directory = DirAccess.open(path)
	
	directory.list_dir_begin()
	var filename = directory.get_next()
	while filename != "":
		if filename != "." and filename != ".." and not filename.ends_with(".import"):
			if directory.current_is_dir():
				structure[filename] = read_directory_structure(path + "/" + filename)
			else:
				structure[filename] = "file"  # Or use null or any other placeholder for files
		filename = directory.get_next()
	directory.list_dir_end()
	return structure

func _on_button_pressed(value):
	dial_sequence.append(value)
	check_dial_sequence()

func check_dial_sequence():
	if dial_sequence.size() > target_sequence.size():
		dial_sequence.pop_front()  # Keep the sequence within the target size

	if dial_sequence == target_sequence:
		play_current_directory_audio()
		print("Dial sequence correct. Entering the folder.")

func play_current_directory_audio():
	var directory = DirAccess.open(current_directory_path)
	if directory:
		directory.list_dir_begin()
		var filename = directory.get_next()
		while filename != "":
			if filename.ends_with(".mp3") or filename.ends_with(".wav") :
				audio_player.stream = load(current_directory_path + filename)
				audio_player.play()
				break
			filename = directory.get_next()
		directory.list_dir_end()
	else:
		print("Failed to open directory: ", current_directory_path)
		
		
'''
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
'''
