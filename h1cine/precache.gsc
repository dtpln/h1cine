/*
 *      H1Cine
 *      Precache
 *      
 *      >>>  IMPORTANT :
 *      - EVERY animation needs to be precached
 *      - Multiplayer playermodels don't need to be precached, but Singleplayer ones do
 *
 *      >>>  WHERE TO FIND :
 *      List of MP models : /listassetpool 7
 *      List of MP anims : /listassetpool 5
 *
 *      >>>  HOW TO USE :
 *      Put your precache between the "{ }" brackets below custom_precache()
 *      precacheModel( "name_of_model" );
 *      precacheMPAnim( "name_of_anim" );
 */

custom_precache()
{

}









// Anything below this point is a no-touch zone, unless you know what you're removing
common_precache()
{
    precacheModel( "defaultactor" );
    PrecacheModel( "wpn_h1_lau_rpg7_proj" );
    precacheModel( "projectile_semtex_grenade_bombsquad" );
    precacheModel( "tag_origin" );
    precacheModel( "com_plasticcase_enemy" );
	precacheModel( "head_spetsnaz_urban_smg_mp" );
	precacheModel( "body_sas_ct_sniper_mp_camo" );
	precacheModel( "viewhands_h1_sas_ct_mp_camo" );
    precacheMPAnim( "pb_stand_remotecontroller" );
    precacheMPAnim( "pb_stand_death_chest_blowback" );
	precacheMPanim( "pb_sprint_assault" );
}

fx_precache()
{
    // later
}