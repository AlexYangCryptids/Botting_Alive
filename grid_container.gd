extends GridContainer

func _ready():
	var font_size = 24  # Desired font size
	
	for button in self.get_children():
		if button is Button:
			button.set_custom_minimum_size(Vector2(100, 100))
			# Get the button's default font
		
