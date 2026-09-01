/*
 * 		H1Cine
 *		Entry point
 */


#include scripts\utils;


init()
{
    defaults::load_defaults();
    precache::common_precache();
    precache::custom_precache();
    precache::fx_precache();

    level.cam = [];
    level.cam["type"] = "bezier";
    level.disablespawncamera = 1;

    level.actors = [];
    level thread waitForHost();
}

waitForHost()
{
    level waittill( "connecting", player );

    player scripts\commands::registerCommands();

    scripts\utils::skip_prematch();
    scripts\utils::match_tweaks();
    scripts\utils::lod_tweaks();
    scripts\utils::hud_tweaks();
    scripts\utils::score_tweaks();
    scripts\utils::bots_tweaks();
    scripts\misc::toggle_freeze();
    level thread scripts\actors::prepare_gopro();

    player thread scripts\misc::welcome();
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
        if(!self.isdone) {
            level thread scripts\utils::match_tweaks(); }
    }
}