#define init
global.sprFireBulletCannon = sprite_add_weapon("sprites/sprFireBulletCannon.png", 4, 2);
global.sprFireBullet 			 = sprite_add("defpack tools/Fire Bullet.png", 2, 8, 8)
#define weapon_name
return "FIRE BULLET CANNON";

#define weapon_sprt
return global.sprFireBulletCannon;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 40;

#define weapon_cost
return 80;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "replace me please";

#define weapon_fire

weapon_post(8,-6,22)
sound_play_pitch(sndGrenade,.7)
sound_play_pitch(sndFlamerStop,.7)
sound_play_pitch(sndIncinerator,.7)
with instance_create(x,y,CustomProjectile)
{
	team = other.team
	creator = other
	speed = 28
	image_xscale *= 1.5
	image_yscale *= 1.5
	dir = random(359)
	timer = room_speed
	dirfac = random(359)
	sprite_index = global.sprFireBullet
	direction = other.gunangle+random_range(-12,12)*other.accuracy
	image_speed = 0
	on_step = script_ref_create(bullet_cannon)
	on_hit = script_ref_create(actually_nothing)
	on_wall = script_ref_create(actually_nothing)
	on_draw = script_ref_create(bullet_draw)
}

#define actually_nothing

#define bullet_cannon
if place_meeting(x + hspeed,y,Wall){
	hspeed *= -1
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if place_meeting(x,y +vspeed,Wall){
	vspeed *= -1
	sound_play_pitchvol(sndBouncerBounce,.5,1)
}
if (current_frame % 2) = 0{
	scale = random_range(0.9,1.1)
	image_xscale = 1.5*scale
	image_yscale = 1.5*scale
	image_speed = 0
	dirfac += irandom_range(8,43)
	if speed >= 1{
		speed /= 1.5
	}
	else{
		speed = 0
	};
	if speed = 0 {
		var ang = dirfac
		sound_play_pitch(sndMinigun,.8)
		sound_play_pitch(sndFiretrap,.8)
		sound_play_pitchvol(sndIncinerator,1,.7)
		repeat (5){
			with mod_script_call("mod", "defpack tools", "create_fire_bullet",x,y){
			    creator = other
			    team = other.team
					motion_set(ang, 16)
					ang += 360/5
				image_angle = direction
			}
		}
		timer -= 1;
		if timer <= 0
		{
			instance_destroy()
		}
	}
}

#define bullet_draw
draw_sprite_ext(sprite_index, image_index, x, y, .8*image_xscale, .8*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 1.5*image_xscale, 1.5*image_yscale, image_angle, image_blend, 0.25);
draw_set_blend_mode(bm_normal);