extends Node

#autoload to handle the different functionalities of the camera and its container
#across various other scenes

var camera : GameCamera
var camera_container : CameraContainer

func apply_screen_shake(trauma:float) -> void:
	if camera == null:
		return
	
	camera.add_trauma(trauma)


func apply_procedural_recoil(newRecoil : Vector3) -> void:
	if camera_container == null:
		return
	
	camera_container.setRecoil(newRecoil)
	camera_container.recoilFire()
