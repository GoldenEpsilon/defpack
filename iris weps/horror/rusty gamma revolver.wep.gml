#define init
global.sprRustyHorrorRevolver = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprRustyHorrorRevolverOn.png", -2, 1);

#define weapon_name
return "RUSTY GAMMA REVOLVER";

#define weapon_sprt
return global.sprRustyHorrorRevolver;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 8;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "OLD RELIABLE";

#define weapon_fire

weapon_post(2,-8,2)
sound_play_pitchvol(sndRadPickup,1.2, 1.7)
sound_play_pitchvol(sndUltraPistol,3, .7)
sound_play_pitch(sndRustyRevolver,random_range(1.2,1.4))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,4), c_lime)
repeat(2) with mod_script_call("mod", "defpack tools", "create_gamma_bullet",x,y){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-8,8) * other.accuracy,random_range(14,18))
	image_angle = direction
}