#define init
global.sprPestMachinegun = sprite_add_weapon("sprites/Pest Machinegun.png", 6, 1);
#define weapon_name
return "PEST MACHINEGUN";

#define weapon_sprt
return global.sprPestMachinegun;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
return 6;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 5;

#define weapon_text
return "SIIIIICK";

#define weapon_fire

weapon_post(4,-5,4)
sound_play(sndMachinegun)
sound_play_pitch(sndToxicBoltGas,random_range(3,3.8))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_green)
with mod_script_call("mod", "defpack tools", "create_toxic_bullet",x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle)){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-7,7) * other.accuracy,10)
	image_angle = direction
}
