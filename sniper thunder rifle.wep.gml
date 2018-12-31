#define init
global.sprSniperThunderRifle = sprite_add_weapon("sprites/sprSniperThunderRifle.png", 5, 3);
global.sprLightningBullet 	 = sprite_add("defpack tools/Lightning Bullet.png", 2, 8, 8)
global.sprLightningBulletHit = sprite_add("defpack tools/Lightning Bullet Hit.png", 4, 8, 8)

#define weapon_chrg
return true;

#define weapon_name
return "SNIPER THUNDER RIFLE"

#define weapon_sprt
return global.sprSniperThunderRifle ;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 52;

#define weapon_cost
return 30;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper thunder charge"),"creator",self){return true}
return false;

#define weapon_reloaded
repeat(2)with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2), c_navy)
sound_play_pitchvol(sndSwapPistol,2,.4)
sound_play_pitchvol(sndRecGlandProc,1.4,1)
sound_play_pitchvol(sndLightningReload,1,.5)
weapon_post(-2,-4,5)
return -1;

#define weapon_area
return -1;

#define weapon_text
return choose("THE SPEED OF SOUND");

#define weapon_fire

with instance_create(x,y,CustomObject)
{
	name    = "sniper thunder charge"
	creator = other
	charge  = 0
	acc     = other.accuracy
	charged = 1
	holdtime = 5 * 30
	depth = TopCont.depth
	fired = 0
	index = creator.index
	undef = view_pan_factor[index]
	on_step 	 = snipercharge_step
	on_destroy = snipercharge_destroy
	btn = other.specfiring ? "spec" : "fire"
}

#define snipercharge_step
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if !instance_exists(creator){instance_destroy();exit}
if button_check(index,"swap"){creator.ammo[1] = min(creator.ammo[1] + weapon_cost(), creator.typ_amax[1]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec" creator.breload = weapon_get_load(creator.bwep) * array_length_1d(instances_matching(instances_matching(CustomObject, "name", "sniper thunder charge"),"creator",creator))
charge += timescale * 3.2 / acc
if charge > 100
{
	charge = 100
	if charged > 0
	{
		sound_play_pitch(sndSniperTarget,1.2)
	}
	charged = 0
}
if charged = 0
{
	with creator with instance_create(x,y,Dust)
	{
		motion_add(random(360),random_range(2,3))
	}
	holdtime -= timescale
}
view_pan_factor[index] = 2.1+charged/10
sound_play_pitchvol(sndFlameCannonLoop,10-charge/10,1)
sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)
x = mouse_x[index]
y = mouse_y[index]
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,0)}
if (button_check(index, btn) = false || holdtime <= 0) && !fired
{
    fired = 1
	repeat(2){
	    sound_stop(sndFlameCannonLoop)
		sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,1)
		sound_pitch(sndNoSelect,1)
		var _ptch = random_range(-.5,.5)
		sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
		sound_play_pitch(sndSawedOffShotgun,1.8-_ptch)
		sound_play_pitch(sndHeavyMachinegun,1.7+_ptch)
		sound_play_pitch(sndLightningRifleUpg,random_range(1.8,2.1))
		sound_play_pitchvol(sndGammaGutsKill,random_range(1.8,2.1),1*skill_get(17))
		sound_play_pitch(sndSniperFire,random_range(.6,.8))
		sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
 		var _c = charge;
		with creator
		{
			weapon_post(12,2,158)
			motion_add(gunangle -180,_c / 20)
			with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile){
				move_contact_solid(other.gunangle,18)
				typ = 1
				creator = other
				index = other.index
				team  = other.team
				image_yscale = .5
				trailscale = 1 + (_c/110)
				hyperspeed = 8
				sprite_index = mskNothing
				mask_index = mskBullet2
				force = 7
				damage = 12 + round(28*(_c/100))
				lasthit = -4
				dir = 0
				dd = 0
				recycleset = 0
				if irandom(2)=0 recycleset = 1
				image_angle = other.gunangle
				direction = other.gunangle
				on_end_step 	 = sniper_step
				on_destroy = sniper_destroy
				on_hit 		 = void
			}
			with instance_create(x,y,CustomObject)
			{
				move_contact_solid(other.gunangle,24)
				depth = -1
				sprite_index = global.sprLightningBullet
				image_speed = .4
				on_step = muzzle_step
				on_draw = muzzle_draw
			}
		}
		if (mod_variable_get("weapon", "stopwatch", "slowed") == 1){
		    repeat(4) wait(0)
		}
		else wait(4)
		if !instance_exists(self) exit
    }
	instance_destroy()
}

#define snipercharge_destroy
view_pan_factor[index] = undefined
//stealing from burg like a cool kid B)
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,1)}

#define void

#define sniper_step
do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	if random(17) < 2
	{
		with instance_create(x,y,Lightning)
		{
				image_angle = random(360)
				team = other.team
				creator = other.creator
				ammo = choose(1,2) + round((other.trailscale-1)*4)
				alarm0 = 1
				visible = 0
				with instance_create(x,y,LightningSpawn){image_angle = other.image_angle}
			}
	}
	//redoing reflection code since the collision event of the reflecters doesnt work in substeps (still needs slash reflection)
	with instances_matching_ne([CrystalShield,PopoShield], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with instances_matching_ne([Shank,EnergyShank], "team", team){if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);with other{line()};}}
	if dd > 0 dd -= hyperspeed
	if dd <= 0
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= other.trailscale * 3
		{
			if other.lasthit != self
			{
				with other
				{
				    projectile_hit(other,damage,force,direction)
					lasthit = other
					dd += 20
					view_shake_at(x,y,12)
					sleep(20)
					if skill_get(16) = true && recycleset = 0{
					    recycleset = 1;
					    instance_create(creator.x,creator.y,RecycleGland);
					    sound_play(sndRecGlandProc);
					    creator.ammo[1] = min(creator.ammo[1] + weapon_cost(), creator.typ_amax[1])
				    }
				}
			}
		}
	}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define line()
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_blend = c_blue
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}
xstart = x
ystart = y

#define sniper_destroy
with instance_create(x,y,BulletHit){sprite_index = global.sprLightningBulletHit}
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_blend = c_aqua
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 3*image_xscale, 3*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);










/*














































repeat(2)
{
	if fork()
	{
	var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyMachinegun,1.7+_ptch)
	sound_play_pitch(sndLightningRifleUpg,random_range(1.8,2.1))
	sound_play_pitchvol(sndGammaGutsKill,random_range(1.8,2.1),1*skill_get(17))
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitchvol(sndHeavySlugger,1.3+_ptch/2,.3)
	weapon_post(12,2,158)
	motion_add(gunangle -180,1)
	with instance_create(x,y,CustomObject)
	{
		move_contact_solid(other.gunangle,24)
		depth = -1
		sprite_index = global.sprLightningBullet
		image_speed = .4
		on_draw = muzzle_draw
		on_step = muzzle_step
	}
	with mod_script_call("mod", "defpack tools", "create_lightning_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle))
	{
			sleep(40)
			move_contact_solid(other.gunangle,20)
			typ = 1
			creator = other
			index = other.index
			team  = other.team
			image_yscale /= 2
			hitscan = true
			sprite_index = mskNothing
			mask_index = mskBullet1
			force = 7
			damage = 15
			dir = 0
			dd = 0
			recycleset=0
			image_angle = other.gunangle
			on_destroy = bolttrail_destroy
			direction = other.gunangle+random_range(-3,3)*other.accuracy
			do
			{
				dir += 1 x += lengthdir_x(1,direction) y += lengthdir_y(1,direction)
				if random(21) < 1*current_time_scale
				{
					with instance_create(x,y,Lightning)
					{
							image_angle = random(360)
							team = other.team
							creator = other.creator
							ammo = choose(1,2)
							alarm0 = 1
							visible = 0
							with instance_create(x,y,LightningSpawn){image_angle = other.image_angle}
						}
				}
				//redoing reflection code since the collision event on the reflecters doesnt work in substeps (still needs slash reflection)
				with instances_matching_ne(CrystalShield, "team", other.team){if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
				with instances_matching_ne(PopoShield, "team", other.team){if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndShielderDeflect,random_range(.9,1.1))}}}
				with instances_matching_ne(Slash, "team", other.team){if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction}}
				with instances_matching_ne(Slash, "team", other.team){if place_meeting(x,y,other){with other{instance_destroy()}}}
				with instances_matching_ne(hitme, "team", other.team)
				{
					if place_meeting(x,y,other)
					{
						if projectile_canhit_melee(other) = false
						{
							if my_health > 0{other.dd += my_health}
							projectile_hit(self,other.damage,other.force,other.direction)
							with other
							{
								if skill_get(16) = true{if recycleset=0{recycleset=1;instance_create(creator.x,creator.y,RecycleGland);sound_play(sndRecGlandProc);if irandom(2)!=0{if creator.ammo[1]+15 <= creator.typ_amax[1]{creator.ammo[1]+=15}else{creator.ammo[1] = creator.typ_amax[1]}}}}
								continue;
							}
						}
					}
				}
				if damage < dd{instance_destroy();exit}
				if place_meeting(x,y,Wall){instance_destroy();exit}
			}
			while instance_exists(self) and dir < 1000
			instance_destroy()
		}
	}
	wait(7)
}

#define muzzle_step
if image_index > 1{instance_destroy()}

#define bolttrail_destroy
with instance_create(x,y,BoltTrail)
{
	image_blend = c_blue
	image_yscale = 1.2+skill_get(17)*.2
	image_xscale = point_distance(x,y,x-lengthdir_x(other.dir,other.direction),y-lengthdir_y(other.dir,other.direction))
	image_angle = point_direction(x,y,x-lengthdir_x(other.dir,other.direction),y-lengthdir_y(other.dir,other.direction))
}
with instance_create(x,y,Lightning){
	image_angle = random(360)
	creator = other.creator
	team = other.team
	ammo = 6
	alarm0 = 1
	visible = 0
	with instance_create(x,y,LightningSpawn)
	{
	   image_angle = other.image_angle
	}
	sound_play_hit(sndHitWall,.2)
}
with instance_create(x,y,BulletHit){
	direction = other.direction
	sprite_index = global.sprLightningBulletHit
}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 0.2);
draw_set_blend_mode(bm_normal);
