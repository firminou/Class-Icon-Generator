@tool
extends Node

enum ColorOptions {
	NODE2D,
	NODE3D,
	CONTROL
}
@export var with_color:ColorOptions = ColorOptions.NODE2D
@export var icon_name:String = "Hello World!"
@export var size:int = 5
@export var create:bool = false

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if create:
			var new_color:String
			match with_color:
				ColorOptions.CONTROL:
					new_color = "#8eef97"
				ColorOptions.NODE2D:
					new_color = "#8da5f3"
				ColorOptions.NODE3D:
					new_color = "#fc7f7f"
				_:
					new_color = "#ffffff"
			create_svg_file(icon_name, new_color)

			create = false

func create_svg_file(key: String, color: String) -> void:
	seed(hash(key))

	var pixel_map: Dictionary[Vector2, bool]

	# Creates to hold HALF the icon, the rest will be mirrored
	for x:int in range(0, ceilf(size / 2) ):
		for y:int in range(0, size - 1):
			pixel_map[Vector2(x,y)] = randi_range(0, 1) == 1

	# Create the base of the svg file
	var svg_content:String = "<svg width=\"%s\" height=\"%s\"> \n" % [size * 20, size * 20]

	for coord:Vector2 in pixel_map.keys():
		if not pixel_map[coord]:
			continue
		svg_content += "<rect x=\"%s\" y=\"%s\" width=\"20\" height=\"20\" fill=\"%s\"/> \n" % [coord.x*20, coord.y*20, color]
		# Add the mirrored pixel
		svg_content += "<rect x=\"%s\" y=\"%s\" width=\"20\" height=\"20\" fill=\"%s\"/> \n" % [size*20-20 - coord.x*20, coord.y*20, color]

	svg_content += "</svg>"

	var file = FileAccess.open("res://addons/class_icon_generator/output/%s.svg" % key, FileAccess.WRITE)
	var err_file:int = file.store_string(svg_content)
	print("SVG file created, there is an error with godot not knowing the file is created, so just move your mose outside the editor and back in to see the file")