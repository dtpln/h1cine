/*
 *      H1Cine
 *      Player-related functions
 */


#include scripts\utils;

// Ammo Regen
playerRegenAmmo()
{
    if(!level.PLAYER_AMMO) return;

    self thread regenAmmo();
    self thread regenEquip();
}

regenAmmo()
{
    self endon("disconnect");
    for (;;)
    {
        self notifyOnPlayerCommand( "reload", "+reload" );
        self waittill( "reload" );
        wait 2;

        self giveMaxAmmo( self getCurrentWeapon() );
    }
}

regenEquip()
{
    self endon("disconnect");
    for (;;)
    {
        self notifyOnPlayerCommand("frag", "+frag");
		self waittill("frag");
        waittillframeend;

        name = self getCurrentOffhand();
        self setWeaponAmmoClip( name, 1 );
        self GiveMaxAmmo( name );
    }
}

// Movement Tweaks
movementTweaks()
{
    if(!level.PLAYER_MOVEMENT) return;

    setDvar("jump_slowdownEnable", "0");
    self maps\mp\_utility::givePerk("specialty_falldamage");
    self maps\mp\_utility::givePerk("specialty_longersprint");
}