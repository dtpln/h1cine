<div align="center"> 
    
[![H1Cine](https://raw.githubusercontent.com/dtpln/codcine/main/assets/img/h1cine_new.png 'H1Cine')](https://github.com/dtpln/codcine)
### 🎥 A features-rich cinematic mod for Call of Duty : Modern Warfare Remastered

<a href="https://github.com/dtpln/h1cine/releases"><img src="https://img.shields.io/github/v/release/dtpln/h1cine?label=Latest%20release&style=flat-square&color=eecb00"></a>　
<a href="https://discord.gg/wgRJDJJ"><img src="https://img.shields.io/discord/617736623412740146?label=Join%20the%20IW4Cine%20Discord!&style=flat-square&color=eecb00"></a>　
<a href="https://github.com/dtpln/iw3cine/releases/latest"><img src="https://img.shields.io/github/downloads/dtpln/iw3cine/total?color=eecb00&label=Downloads&style=flat-square"></a>
</div>
<br/><br/>

This is a port of [Sass' Cinematic Mod](https://github.com/sortileges/iw4cine) for **Call of Duty: Modern Warfare Remastered**, designed for video editors to create cinematics shots in-game.

This mod creates new dvars combined as player commands. They are all associated to script functions that are triggered when the dvar doesn't equal it's default value, meaning these functions will all independently stay idle until they get notified to go ahead.

This mod was also designed as a Multiplayer mod only. It will not work in Singleplayer or Zombies.

<br/><br/>
## Requirements

In order to use the latest version of this mod directly from the repo, you'll need a copy of **Call of Duty : Modern Warfare Remastered®** with the **[H1-Mod](https://github.com/auroramod/h1-mod)** client installed. This mod was built on the **[H1-Mod](https://github.com/auroramod/h1-mod)** client.

<br/><br/>
## Installation

Simply download the mod through [this link](https://github.com/dtpln/h1cine/releases/latest). Scroll down and click on "Source code (zip)" to download the archive.

<img src="https://i.imgur.com/rrEpRLB.png" alt="screenshot" height="265px" align="right"/>

Once the mod is downloaded, open the ZIP file and drag the "h1cine" folder into your `MWR/mods` folder. If the `mods` folder doesn't exist, create it. (*You can also rename the mod if you'd like.*)

<br/>

```
X:/
└── .../
    └── Call of Duty Modern Warfare Remastered/
        └── h1-mod/
        └── mods/
            └── h1cine/
```
Then, open your game, and click on the "**Mods**" tab; "**H1Cine**" should appear in the list. Click on it once and then start a devmap.


<br/><br/>
## How to use

The link below contains a HTML file that explains every command from the [latest release](https://github.com/sortileges/iw4cine/releases/latest) in details. The HTML file will open a new browser tab when you click on it. 
- **[sortileges.github.io/iw4cine/help](https://sortileges.github.io/iw4cine/help)**.

**It is not up-to-date with what's in the master branch,** although everything should still work as intended. Just don't be surprised if something is missing or not working as expected!

Once [Sass](https://github.com/sortileges) finishes the mod's rewrite, the HTML file will be updated accordingly.


<br/><br/>
## Features
**MISC FUNCTIONS**

    - [x]   clone             -- <set to 1>
    - [x]   drop              -- <set to 1>
    - [x]   about             -- <set to 1>
    - [x]   clearbodies       -- <set to 1>
    - [x]   viewhands         -- <model_name>
    - [x]   eb_explosive      -- <radius>
    - [x]   eb_magic          -- <degrees>
    - [x]   spawn_model       -- <model_name>
    - [x]   spawn_fx          -- <fx_name>
    - [x]   vision            -- <vision>
    - [x]   fog               -- <start> <half> <red> <green> <blue> <time>

**BOT FUNCTIONS**

    - [x]   spawn             -- <weapon_mp> <allies/axis>
    - [x]   weapon            -- <bot_name> <weapon_mp>
    - [x]   move              -- <bot_name>
    - [x]   aim               -- <bot_name>
    - [x]   stare             -- <bot_name>
    - [ ]   model             -- <bot_name> <model> <allies/axis>
    - [x]   kill              -- <bot_name> <body/head/shotgun>
    - [x]   holdgun           -- <set to 1>
    - [x]   freeze            -- <set to 1>

**ACTOR FUNCTIONS**

    - [ ]   actorback    
    - [ ]   actor_anim    
    - [ ]   actor_copy   
    - [ ]   actor_death 
    - [ ]   actor_spawn    
    - [ ]   actor_move    
    - [ ]   actor_health  
    - [ ]   actor_model   
    - [ ]   actor_weapon 
    - [ ]   actor_gopro 
    - [ ]   actor_fx

**CAMERA FUNCTIONS**

    - [x]   mode              -- <linear/bezier>
    - [x]   rot               -- <degrees>
    - [x]   save              -- <node # starting from 1>
    - [x]   start             -- <speed if bezier, time if linear>
   
</br><br/>
**PLANNED FEATURES**
    
    - [ ]    Better and cleaner system for everything.

<br/><br/>
## Credits
- **Sass** - Created the original IW4Cine mod. All the code was written by him, I just edited it to work on this game.
- **Antiga** - Helped rewrite the mod and fix things that I couldn't.
