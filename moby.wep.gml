#define init
global.sprMoby = sprite_add_weapon("sprites/sprMoby.png", 7, 2);

while 1{
    with Player{
        if is_object(wep) && wep.wep = mod_current goodstep(wep)
        if is_object(bwep) && bwep.wep = mod_current goodstep(bwep)
    }
    wait(0)
}


#define weapon_name
return "MOBY";

#define weapon_sprt
return global.sprMoby;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load(w)
if is_object(w) return 5-w.charge/5
return 5;

#define weapon_cost(w)
if is_object(w) && w.charge > 20 && ammo[1] > 1 return irandom(1)
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return 12;

#define weapon_text
return "HEAVY OCEAN";

#define weapon_fire(w)
sound_play(sndMinigun)

if !is_object(w){
    w = {
        wep: mod_current,
        charge : 1,
        persist : 0
    }
}
else{
    if "charge" in w{
        w.charge = min(w.charge + 2/w.charge, 24)
        w.persist = 5
    }
    else{
        w.charge = 1
        w.persist = 5
    }
}
weapon_post(5+random_range(w.charge/24,-w.charge/24),-9,2)
sound_play_pitch(sndTripleMachinegun,.7 + w.charge/50)


with instance_create(x,y,Shell){motion_add(other.gunangle+other.right*100+random(80)-40,3+random(3))}
with create_bullet(x+lengthdir_x(24,gunangle),y+ lengthdir_y(24,gunangle)){
		on_destroy = shell_destroy
		direction = other.gunangle + random_range(-20,20)*other.accuracy*(12/w.charge);
		image_angle = direction;
		creator = other
		team = other.team
		flashang = other.gunangle
}
wep = w

#define goodstep(w)
if w.persist > 0{
    w.persist-= current_time_scale
}
else if w.charge > 1{
    if random(100)<50* current_time_scale with instance_create(x+lengthdir_x(16,gunangle),y+lengthdir_y(16,gunangle),Smoke) {vspeed -= random(1); image_xscale/=2;image_yscale/=2; hspeed/=2}
    w.charge = max (w.charge - current_time_scale, 1)
}


#define create_bullet(_x,_y)
with instance_create(_x,_y,CustomProjectile){
	typ = 1
	creator = other
	team  = other.team
	image_yscale = .5
	trailscale = 1
	hyperspeed = 8
	sprite_index = mskNothing
	mask_index = mskBullet2
	force = 4
	damage = 2
	lasthit = -4
	dir = 0
	recycle = (skill_get(mut_recycle_gland) && !irandom(2))
	on_step 	 = sniper_step
	on_hit 		 = void
	return id
}


#define shell_destroy
x += lengthdir_x(hyperspeed,direction)
y += lengthdir_y(hyperspeed,direction)
instance_create(x,y,BulletHit)
line()

#define sniper_step
with instance_create(x,y,CustomObject)
{
	depth = -1
	sprite_index = sprBullet1
	image_speed = .9
	on_step = muzzle_step
	on_draw = muzzle_draw
	image_yscale = .5
	image_angle = other.flashang
}

while !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),Wall,1,1) && !collision_line(x,y,x+lengthdir_x(100,direction),y+lengthdir_y(100,direction),hitme,0,1) && dir <1000{
    x+=lengthdir_x(100,direction)
    y+=lengthdir_y(100,direction)
    dir+=100
}

do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	with instances_matching_ne([CrystalShield,PopoShield], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team){if place_meeting(x,y,other){with other{line()};other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with instances_matching_ne([Shank,EnergyShank], "team", team){if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with instances_matching_ne(CustomSlash, "team", team){if place_meeting(x,y,other){mod_script_call(on_projectile[0],on_projectile[1],on_projectile[2]);with other{line()};}}
	with instances_matching_ne(hitme, "team", team)
	{
		if distance_to_object(other) <= 4
		{
			projectile_hit(self,other.damage,other.force,other.direction)
			if other.recycle{
			    instance_create(x,y,RecycleGland)
			    sound_play(sndRecGlandProc)
			    with other.creator{
			        ammo[1] = min(ammo[1]+1,typ_amax[1])
			    }
			}
			with other instance_destroy()
			exit
		}
	}
  if place_meeting(x+lengthdir_x(hyperspeed,direction),y+lengthdir_y(hyperspeed,direction),Wall)
  {
    instance_destroy()
    exit
  }
}
while instance_exists(self) and dir < 1000
instance_destroy()

#define void

#define line()
var dis = point_distance(x,y,xstart,ystart) + 1;
var num = 20;
for var i = 0; i <= num; i++{
    if !irandom(2)
    with instance_create(xstart+lengthdir_x(dis/num * i,direction),ystart + lengthdir_y(dis/num * i,direction),BoltTrail){
        image_angle = other.direction
        image_yscale = other.trailscale * (i/num)
        image_xscale = dis/num
    }
}
xstart = x
ystart = y

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 2.5*image_xscale, 2*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);