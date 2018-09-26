#define init
global.sprboomerang = sprite_add_weapon("sprites/sprBOOMerang.png",3,3);

#define weapon_name
return "BOOMERANG";

#define weapon_type
return 4;

#define weapon_cost
return 1;

#define weapon_area
return -1;

#define weapon_load
return 1;//???

#define weapon_swap
return sndSwapHammer;

#define weapon_auto
return false;

#define weapon_melee
return true;

#define weapon_laser_sight
return false;

#define weapon_fire
sound_play(sndChickenThrow)
with instance_create(x,y,CustomObject)
{
  team = other.team
  creator = other
  sprite_index = global.sprboomerang
  mask_index   = sprEnemyBullet1
  image_speed = 0
  curse = other.curse
  other.wep = 0
  maxspeed = 14 + skill_get(13)*4
  phase = 0
  friction = 1
  lasthit = -4
  motion_add(other.gunangle,18)
  on_step       = boom_step
  with instance_create(x,y,MeleeHitWall){image_angle = other.direction-180}
}

#define boom_step
if instance_exists(creator){if current_frame mod 6 = 0{sound_play_pitchvol(sndAssassinAttack,random_range(.9,1.1),.6*(1-distance_to_object(creator)/200))}}
with Pickup
{
  if place_meeting(x,y,other) && ("rang" not in self || ("rang" in self && rang != other.id)){rang = other.id}
  if "rang" in self{if instance_exists(rang){x = rang.x;y = rang.y}}
}
with chestprop
{
  if self != GiantAmmoChest && self != GiantWeaponChest && self != BigCursedChest && self != BigWeaponChest
  if place_meeting(x,y,other) && ("rang" not in self || ("rang" in self && rang != other.id)){rang = other.id}
  if "rang" in self{if instance_exists(rang){x = rang.x;y = rang.y}}
}
with instances_matching_ne(hitme,"team",other.team)
{
  if place_meeting(x,y,other)
  {
    if projectile_canhit(other) = true
    {
      with other
      {
        if lasthit != other
        {
          lasthit = other
          sound_play(sndExplosionS)
          var meetx = (x + other.x)/2;
          var meety = (y + other.y)/2;
          instance_create(meetx,meety,SmallExplosion)
        }
      }
    }
  }
}
with instances_matching_ne(projectile,"team",other.team)
{
  if place_meeting(x,y,other)
  {
    with other if other.team != team with other instance_destroy()
  }
}
if curse = true{instance_create(x+random_range(-2,2),y+random_range(-2,2),Curse)}
image_angle += 20
if phase = 0 //move regularly
{
  if speed <= friction
  {
    phase = 1
    friction *= -1
  }
}
else//return to player
{
  if instance_exists(creator)
  {
    var _d = point_direction(x,y,creator.x,creator.y)
    if phase = 1 motion_add(_d,8)
    if place_meeting(x,y,creator)
    {
      if creator.wep  = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
      if creator.bwep = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
      //zphase = 2//not homing anymore
    }
    if creator.mask_index != mskNothing && place_meeting(x,y,Portal)
    {
      if creator.wep  = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.wep = mod_current;instance_destroy();exit}
      if creator.bwep = 0{sleep(30);sound_play(sndSwapHammer);instance_create(x,y,WepSwap);creator.bwep = mod_current;instance_destroy();exit}
      //zphase = 2//not homing anymore
    }
  }
}
if place_meeting(x+hspeed,y+vspeed,Wall)
{
  phase = 1
  lasthit = -4
  var _y = false;
  if instance_exists(creator){if !collision_line(x,y,creator.x,creator.y,Wall,0,0){_y = true}}else{_y = true}
  if _y = false
  {
    with instance_create(x,y,ThrownWep)
    {
      sprite_index = other.sprite_index
      wep = mod_current
      curse = other.curse
      motion_add(other.direction-180+random_range(-30,30),other.speed*.3)
      team = other.team
      creator = other.creator
    }
    sound_play(sndExplosionS)
    var meetx = (x + other.x)/2;
    var meety = (y + other.y)/2;
    instance_create(meetx,meety,SmallExplosion)
    instance_destroy()
    exit
  }
  else{speed = 0}
}
if speed > maxspeed speed = maxspeed

#define weapon_sprt
return global.sprboomerang

#define weapon_text
return choose("WATCH OUT FOR THAT 'RANG","BOOM OF RANGE")

#define step
with WepPickup if wep = 0 instance_delete(self)