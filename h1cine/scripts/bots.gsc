/*
 *      IW4cine
 *      Bots functions
 */


#include common_scripts\utility;
#include scripts\utils;
#include maps\mp\_utility;
#include maps\mp\gametypes\_class;


add( args )
{
    weapon = args[0];
    team = args[1];
    owner = self;

    level thread wait_for_new_bot( owner, weapon, team );

    level thread maps\mp\bots\_bots::spawn_bots(
        1,
        team,
        undefined,
        undefined,
        "spawned_" + team,
        "recruit"
    );

    create_kill_params();
}

wait_for_new_bot( owner, weapon, team )
{
    oldCount = level.players.size;

    for ( ;; )
    {
        wait 0.05;

        if ( level.players.size > oldCount )
            break;
    }

    wait 0.05;

    foreach ( player in level.players )
    {
        if ( player is_bot() &&
             !isdefined( player.pers["spawnmeAssigned"] ) )
        {
            player.pers["spawnmeAssigned"] = true;
            player thread persistence();
            player thread spawnme( owner, weapon, team );

            return;
        }
    }
}


persistence()
{
    self.pers["isBot"]     = true;
    self.pers["isStaring"] = false;
    self.pers["fakeModel"] = false;

    print( "persistence returned\n" );
}


spawnme( owner, weapon, team )
{
    self endon( "disconnect" );

    while ( !isdefined( self.pers["team"] ) )
        wait 0.5;

    weapon = legacy_classnames( weapon );

    if ( !isValidPrimary( getBaseWeaponName( weapon ) ) &&
         !isValidSecondary( getBaseWeaponName( weapon ) ) )
    {
        weapon = "h1_ak47_mp";
    }

    self.bot_owner = owner;
    self.bot_weapon = weapon;

    loadout = create_loadout( weapon );

    if ( isalive( self ) )
    {
        self bot_apply_spawn( loadout, owner );
    }
    else
    {
        self waittill( "spawned_player" );

        self bot_apply_spawn( loadout, owner );
    }
    self thread bot_handler();
}

bot_apply_spawn( loadout, owner )
{
    wait 0.05;

    self setOrigin( at_crosshair( owner ) );
    self setPlayerAngles( owner.angles + ( 0, 180, 0 ) );
    self save_spawn();

    self freezeControls( level.BOT_FREEZE );

    self thread create_spawn_thread( scripts\bots::give_loadout_on_spawn, loadout );

    self thread create_spawn_thread( scripts\bots::attach_weapons, loadout );

    self scripts\player::playerRegenAmmo();

    if ( level.BOT_SPAWNCLEAR )
    {
        self thread create_spawn_thread( scripts\misc::clear_bodies );
    }
}

bot_handler()
{
    self endon( "disconnect" );

    for ( ;; )
    {
        self waittill( "spawned_player" );

        wait 0.05;

        if ( isdefined( self.saved_origin ) )
        {
            self setOrigin( self.saved_origin );
            self setPlayerAngles( self.saved_angles );
        }

        self freezeControls( level.BOT_FREEZE );

        loadout = create_loadout( self.bot_weapon );

        self thread create_spawn_thread( scripts\bots::give_loadout_on_spawn, loadout );

        self thread create_spawn_thread( scripts\bots::attach_weapons, loadout );

        self scripts\player::playerRegenAmmo();

        if ( level.BOT_SPAWNCLEAR )
        {
            self thread create_spawn_thread(
                scripts\misc::clear_bodies
            );
        }
    }
}

// Move a bot
move( args )
{
    name = args[0];
    foreach( player in level.players )
    {
        if ( issubstr( player.name, args[0] ) ) 
        {
            player setOrigin( at_crosshair( self ) );
            player save_spawn();
            player freezeControls( level.BOT_FREEZE );
        }
    }
}

aim( args )
{
    name = args[0];
    foreach( player in level.players )
    {
        if ( issubstr( player.name, args[0] ) )
        {
            player thread doaim();
            wait 0.5;
            player notify( "stopaim" );
        }
    }
}

stare( args )
{
    name = args[0];
    foreach( player in level.players )
    {
        if ( issubstr( player.name, args[0] ) )
        {
            player.pers["isStaring"] ^= 1;
            if ( player.pers["isStaring"] ) player thread doaim();
            else player notify( "stopaim" );
        }
    }
}

model( args )
{
    name  = args[0];
    model = legacy_modelnames( args[1] );
    team  = args[2];

    print( "MODEL: " + model + "\n" );
    print( "TEAM: " + team + "\n" );

    foreach ( player in level.players )
    {
        if ( issubstr( player.name, name ) )
        {
            print( "FOUND PLAYER: " + player.name + "\n" );

            player.pers["fakeTeam"]  = team;
            player.pers["fakeModel"] = model;
            //player detachAll();
            skipframe();

            player[[game[team + "_model"][model]]]();

            print( "MODEL FUNCTION CALLED\n" );

            if ( isdefined( player.pers["viewmodel"] ) )
                player setViewmodel( player.pers["viewmodel"] );
        }
    }
}

doaim()
{
    self endon( "disconnect" );
    self endon( "stopaim" );

    for (;;)
    {
        wait .05;
        target = undefined;

        foreach( player in level.players )
        {
            if ( ( player == self ) || ( level.teamBased && self.pers["team"] == player.pers["team"] ) || ( !isAlive( player) ) )
                continue;

            if ( isDefined( target ) ) 
            {
                if ( closer ( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), target getTagOrigin( "j_head" ) ) )
                    target = player;
            }
            else target = player;
        }

        if ( isDefined( target ) )
            self setPlayerAngles( VectorToAngles( ( target getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
    }
}

killBot( args )
{
    name = args[0];
    mode = args[1];
    foreach( player in level.players )
    {
        if ( isSubStr( player.name, args[0] ) )
        {
            parameters  = strTok( level.killparams[mode], ":" );
            fx          = parameters[0];
            tag         = player getTagOrigin( parameters[1] );
            dir = vectornormalize( player.origin - self.origin );
            hitloc      = parameters[2];

            player thread [[level.callbackPlayerDamage]]( player, self, player.health, 4, "MOD_RIFLE_BULLET", self getCurrentWeapon(), tag, dir, hitloc, 0 );                                                                // ^^ - can be changed to player.name for true suicide -- (no "watching killcam" ) 
        }
    }
}

delay(args)
{
    setDvarIfUninitialized("scr_killcam_time",      level.BOT_SPAWN_DELAY/2);
    setDvarIfUninitialized("scr_killcam_posttime",  level.BOT_SPAWN_DELAY/2);
}

create_loadout( weapon, camo )
{
    
    loadout = spawnstruct();
    loadout.primary = weapon;
    loadout.camo = camo;
    return loadout;
}

attach_weapons( loadout )
{
    wait .1;

    if ( level.BOT_WEAPHOLD && self is_bot() )
    {
        self.replica = getWeaponModel( loadout.primary );

        self attach(
            self.replica,
            "tag_weapon_right",
            true
        );
    }
}

// Change bot weapon
weapon( args )
{
    name    = args[0];
    weapon  = args[1];
    camo    = args[2]; // Camo name, reference function camo_int.

    
    foreach( player in level.players )
    {
        if( issubstr( player.name, args[0] ) )
        {
            player create_loadout( weapon );
            player dropItem( self getCurrentWeapon() );
            player giveWeapon( weapon );
            player switchtoWeapon( weapon );
            player setSpawnWeapon( weapon );
            wait 1;

            player thread attach_weapons();
        }
    }
}

create_kill_params()
{
    level.killparams             = [];
    level.killparams["body"]     = "flesh_body:j_spine4:body";
    level.killparams["head"]     = "flesh_head:j_head:head";
    level.killparams["shotgun"]  = "flesh_body:j_knee_ri:body"; // REDO ME!!
    level.killparams["cash"]     = "money:j_spine4:body";
}

give_loadout_on_spawn( loadout )
{
    self takeAllWeapons();
    self giveWeapon( loadout.primary, is_akimbo( loadout.primary ) );
    self setSpawnWeapon( loadout.primary );
}