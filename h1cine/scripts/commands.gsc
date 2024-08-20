/*
 *      H1Cine
 *      Commands handler
 */

#include scripts\utils;

registerCommands()
{
    level endon( "disconnect" );

    // Misc
    self thread createCommand( "clone",         "Create a clone of yourself",           " ",                                        scripts\misc::clone );
    self thread createCommand( "givecamo",      "Give yourself a weapon",               " <weapon_mp> <camo_name>",                 scripts\misc::give     );
    self thread createCommand( "drop",          "Drop your current weapon",             " ",                                        scripts\misc::drop       );
    self thread createCommand( "about",         "About the mod",                        " ",                                        scripts\misc::about      );
    self thread createCommand( "clearbodies",   "Remove all player/bot corpses",        " ",                                        scripts\misc::clear_bodies );
    self thread createCommand( "viewhands",     "Change your viewmodel",                " <model_name>",                            scripts\misc::viewhands   );
    self thread createCommand( "eb_explosive",  "Explosion radius on bullet impact",    " <radius>",                                scripts\misc::expl_bullets );
    self thread createCommand( "eb_magic",      "Kill bots within defined FOV value",   " <degrees>",                               scripts\misc::magc_bullets );

    self thread createCommand( "mvm_spawn_model",   "Spawn model at your position",         " <model_name>",                            scripts\misc::spawn_model );
    self thread createCommand( "mvm_spawn_fx",      "Spawn FX at your xhair",               " <fx_name>",                               scripts\misc::spawn_fx );
    self thread createCommand( "mvm_vision",        "Change vision, reset on death",        " <vision>",                                scripts\misc::change_vision );
    self thread createCommand( "mvm_fog",           "Change ambient fog",                   " <start> <half> <r> <g> <b> <a> <time>",   scripts\misc::change_fog );

    // Bots
    self thread createCommand( "mvm_bot_spawn",     "Add a bot",                            " <weapon_mp> <axis/allies> <camo_name>",   scripts\bots::add );
    self thread createCommand( "mvm_bot_move",      "Move bot to xhair",                    " <bot_name>",                              scripts\bots::move );
    self thread createCommand( "mvm_bot_aim",       "Make bot look at closest enemy",       " <bot_name>",                              scripts\bots::aim );
    self thread createCommand( "mvm_bot_stare",     "Make bot stare at closest enemy",      " <bot_name>",                              scripts\bots::stare );
    self thread createCommand( "mvm_bot_model",     "Swap bot model",                       " <bot_name> <MODEL> <axis/allies>",        scripts\bots::model );
    self thread createCommand( "mvm_bot_kill",      "Kill bot",                             " <bot_name> <body/head/cash>",             scripts\bots::killBot );
    self thread createCommand( "mvm_bot_holdgun",   "Toggle bots holding guns when dying",  " ",                                        scripts\misc::toggle_holding );
    self thread createCommand( "mvm_bot_freeze",    "(Un)freeze bots",                      " ",                                        scripts\misc::toggle_freeze );

    // Actors
    //self thread createCommand( "actorback",     "Reset all actors to previous state",   " ",                                                        scripts\actors::back );
    //self thread createCommand( "mvm_actor_anim",    "Set actor's main animation",           " <actor_name> <anim_name>",                                scripts\actors::playanim );
    //self thread createCommand( "mvm_actor_copy",    "Spawn a copy of an existing actor",    " <actor_name>",                                            scripts\actors::copy );
    //self thread createCommand( "mvm_actor_death",   "Set actor's death animation",          " <actor_name> <anim_name>",                                scripts\actors::deathanim );
    //self thread createCommand( "mvm_actor_spawn",   "Add an actor",                         " <body_model> <head_model>",                               scripts\actors::add );
    //self thread createCommand( "mvm_actor_move",    "Move actor to xhair",                  " <actor_name>",                                            scripts\actors::move );
    //self thread createCommand( "mvm_actor_health",  "Set actor's health",                   " <actor_name>",                                            scripts\actors::hp );
    //self thread createCommand( "mvm_actor_model",   "Change actor's head and body",         " <actor_name> <body_model> <head_model>",                  scripts\actors::model );
    //self thread createCommand( "mvm_actor_weapon",  "Attach weapon or model to tag",        " <actor_name> <tag_name> <weapon_mp/model/delete> <camo>", scripts\actors::equip );
    //self thread createCommand( "mvm_actor_gopro",   "Fixed camera on actor tag",            " <actor_name> <tag_name> <x> <y> <z> <yaw> <pitch> <roll>",scripts\actors::gopro );
    //self thread createCommand( "mvm_actor_fx",      "Play FX on tag or action",             " <actor_name> <tag_name> <fx_name> <when>",                scripts\actors::efx );
    
    // Camera
    self thread createCommand( "cam_mode",      "Change cam mode",                      " <linear/bezier>",                                         scripts\cam::camsetmode,    1 );
    self thread createCommand( "cam_rot",       "Camera rotation",                      " <rotation in degrees>",                                   scripts\cam::camsetrot,     1 );
    self thread createCommand( "cam_save",      "Save camera node",                     " <node # starting from 1>",                                scripts\cam::camsavenode,   1 );
    self thread createCommand( "cam_start",     "Camera start",                         " <speed if bezier, time if linear>",                       scripts\cam::camstartpath,  1 );
    
    //  Debug
    self thread createCommand( "mvm_help",      "Get a full list of mod commands.",             " ",                scripts\utils::MsgHelp );
}

createCommand( command, desc, usage, callback )
{
    self endon( "disconnect" );

    setDvarifUninitialized( command, desc );

    for (;;)
    {
        {
            while( getDvar( command ) == desc )
            wait .01;
            {
                args = StrTok( getDvar( command ), " " );
                if( args.size >= 1 )    self [[callback]]( args );
                else                    self [[callback]]();
            }            
        }

        setDvar( command, desc );
        wait 0.01;
    }
}