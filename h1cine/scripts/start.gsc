/*
 * 		H1Cine
 *		Entry point
 */

init()
{
    defaults::load_defaults();
    precache::common_precache();
    precache::custom_precache();
    precache::fx_precache();

    level.actors = [];
    level thread waitForHost();
}

waitForHost()
{
    level waittill( "connecting", player );

    player scripts\commands::registerCommands();

    player thread scripts\utils::skip_prematch();
    player thread scripts\utils::match_tweaks();
    player thread scripts\utils::lod_tweaks();
    player thread scripts\utils::hud_tweaks();
    player thread scripts\utils::score_tweaks();
    player thread scripts\utils::bots_tweaks();
    level thread scripts\actors::prepare_gopro();

    //player thread scripts\ui::await();
    player thread onPlayerSpawned();
}


onPlayerSpawned()
{
    self endon("disconnect");

    self scripts\player::regenAmmo();
    //self thread scripts\actors::names();
    self thread scripts\misc::class_swap();

    for(;;)
    {
        self waittill("spawned_player");

        // Only stuff that gets reset/removed because of death goes here
        self scripts\player::movementTweaks();
        self scripts\misc::reset_models();
        if(!self.isdone)
            self scripts\misc::welcome(); 
    }
}