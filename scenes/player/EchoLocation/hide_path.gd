extends FakeWall

func on_echo_hit():
	self.tile_set.set_occlusion_layer_light_mask(0, 2)
	# 	make tilemap layer glow
	touched_wall = true
