#define init
global.sprRockletMinigun = sprite_add_weapon("sprites/sprRockletMinigun.png", 4, 3);

#define weapon_name
return "ROCKLET MINIGUN";

#define weapon_sprt
return global.sprRockletMinigun;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 2;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 12;

#define weapon_text
return "replace me please";

#define weapon_fire
if fork(){
    sound_play_pitch(sndToxicBoltGas,.85)
    sound_play_pitch(sndRocket,2)
    repeat(5) if instance_exists(self){
        weapon_post(4,-7,4)
        sound_play_pitch(sndSeekerShotgun,1.2)
        sound_play_pitch(sndPistol,2)
        repeat(3)with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),Dust){
            motion_set(other.gunangle+choose(0,60,-60,0,0)+random_range(-15,15),sqr(1.8+random(1)))
        }
        with mod_script_call("mod","defpack tools", "create_rocklet",x,y)
        {
            creator = other
            team = creator.team
            move_contact_solid(other.gunangle,10)
            direction_goal = other.gunangle
            motion_add(other.gunangle+random_range(-90,90)*creator.accuracy,2)
            image_angle = direction
        }
        wait(1)
    }
}
