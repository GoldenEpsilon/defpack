#define init
global.sprGoldenPestPistol = sprite_add_weapon("../../sprites/weapons/iris/pest/sprGoldenPestRevolver.png", 0, 2);

#define weapon_name
return "GOLDEN PEST PISTOL";

#define weapon_sprt
return global.sprGoldenPestPistol;

#define weapon_gold
return true;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 5;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "THE ENEMY OF LUNGS";

#define weapon_fire

weapon_post(2,-3,2)
sound_play_pitch(sndMinigun,random_range(1.2,1.5))
sound_play_pitch(sndGoldPistol,random_range(.6,.8))
sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-3,3) * other.accuracy,16)
	image_angle = direction
}
