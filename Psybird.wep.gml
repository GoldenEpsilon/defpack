#define init//This weapon replaces Psy-V
global.Psybird = sprite_add_weapon("sprites/Psybird.png", 4, 4);

#define weapon_name
return "PSYBIRD";

#define weapon_sprt
return global.Psybird;

#define weapon_type
return 2;

#define weapon_auto
return false;

#define weapon_load
return 20;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapShotgun;

#define weapon_area
return 13	;

#define weapon_text
return choose("STRAFE FROM","QUETZAL STOMP","@p\|/","K'AW");

#define weapon_fire
with instance_create(x,y,CustomObject)
{
	creator = other.id
	ammo = 5
	time = 1
	team = other.team
	on_step = Psybird_step
}

#define Psybird_step
if instance_exists(creator)
{
	gunangle = creator.gunangle
	accuracy = creator.accuracy
	x = creator.x+lengthdir_x(1,gunangle)
	y = creator.y+lengthdir_y(1,gunangle)
	with creator weapon_post(4,-5,8)
	sound_play(sndShotgun)
time -= 1
if time = 0
{
	time = 1
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
			creator = other
			team = other.team
			motion_set(other.gunangle + random_range(7,16) * other.accuracy,random_range(9,14))
			on_step =  psy_shell_lcurve_step
			image_angle = direction
			friction = random_range(.5,.6)
	}
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
			creator = other
			team = other.team
			motion_set(other.gunangle + random_range(-1,1) * other.accuracy,random_range(7,15))
			image_angle = direction
			friction = random_range(.5,.6)
	}
		with mod_script_call("mod", "defpack tools", "create_psy_shell",x+lengthdir_x(5,gunangle),y+lengthdir_y(5,gunangle)){
			creator = other
			team = other.team
			motion_set(other.gunangle + random_range(-16,-7) * other.accuracy,random_range(9,14))
			on_step =  psy_shell_rcurve_step
			image_angle = direction
			friction = random_range(.5,.6)
		}
	ammo -= 1
}
if ammo = 0
instance_destroy()
wait(3)
}

#define psy_shell_lcurve_step
motion_add(direction+90,speed/10-0.36-skill_get(19)/2.5)
image_angle = direction
if timer > 0{
	timer -= 1
}
if timer = (og_timer - 2){
	damage -= 1
}
if timer = 0 && instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 200{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),1 * (1 + skill_get(15)))
		motion_add(direction,-.03  * (1 + skill_get(15)))
		image_angle = direction
	}
}
if image_index >= 1{
	image_speed = 0
}
if place_meeting(x + hspeed, y, Wall){
	hspeed /= -1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if place_meeting(x, y + vspeed, Wall){
	vspeed /= -1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if place_meeting(x + hspeed, y + vspeed, Wall){
	direction += 180
	speed /= 1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if speed < 3{
	instance_destroy()
}

#define psy_shell_rcurve_step
motion_add(direction-90,speed/10-0.36-skill_get(19)/2.5)
image_angle = direction
if timer > 0{
	timer -= 1
}
if timer = (og_timer - 2){
	damage -= 1
}
if timer = 0 && instance_exists(enemy){
	var closeboy = instance_nearest(x,y,enemy)
	if collision_line(x,y,closeboy.x,closeboy.y,Wall,0,0) < 0 && distance_to_object(closeboy) < 200{
		motion_add(point_direction(x,y,closeboy.x,closeboy.y),1 * (1 + skill_get(15)))
		motion_add(direction,-.03  * (1 + skill_get(15)))
		image_angle = direction
	}
}
if image_index >= 1{
	image_speed = 0
}
if place_meeting(x + hspeed, y, Wall){
	hspeed /= -1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if place_meeting(x, y + vspeed, Wall){
	vspeed /= -1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if place_meeting(x + hspeed, y + vspeed, Wall){
	direction += 180
	speed /= 1.25
	if speed + wallbounce >= 18{
		speed = 18
	}
	else{
		speed += wallbounce
	}
	wallbounce /= 1.05
	instance_create(x,y,Dust)
	sound_play_pitchvol(sndShotgunHitWall, 1, 50/distance_to_object(creator))
	image_angle = direction
}
if speed < 3{
	instance_destroy()
}
