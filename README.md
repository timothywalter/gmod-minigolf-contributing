![The Minigolf Logo by Syff](.github/assets/logo_with_background.png)

# MiniGolf Contributions

If you wish to report a bug, get help with a problem or give a suggestion: head over to the Issues tab of this repo and make yourself heard.


## Dev Kit Addon

This is not the whole MiniGolf gamemode, but rather a minimal testing addon mappers (and in the future other content developers) can use to test their content. Unlike the MiniGolf gamemode (which for now is closed-source), all custom code and content in this repository is licensed under the open-source MIT License (see [LICENSE](LICENSE) file for more information)


## Usage Instructions

1. Download all the files in this repository (Click `code` -> `Download .ZIP` above or clone this repo)
2. Exctract the files from the zip
3. Copy the `minigolf-devkit` folder to your `garrysmod/addons` folder. Ensure that the `addon.txt` file and `lua` folder are directly located in `garrysmod/addons/minigolf-devkit`.
4. Restart Garry's Mod if it was opened (required)
5. Select a `golf_` map
6. Start a Multiplayer server:
  ![Starting a multiplayer server](.github/assets/local_server.jpg)
7. You'll find debug information and the ability to play basic minigolf:
  ![The debug hud](.github/assets/debug_hud.jpg)


# Contributing

Do you have a trail, ball texture, area effect or other content you would like to share and get into the gamemode? Create an issue using the right template. In the Issues tab of this repository click `New issue > Share Content`. _(Take note that we internally moderate content to maintain continuity and improve quality)_


## Mapping

Do you want to help us making maps for minigolf? [Check out the guide and examples here!](MAPPING_GUIDE.md)


## Ball Skins

Hahaha! Ok now to business: there's an example in the [addon materials directory](minigolf-devkit/materials/minigolf/devkit/). It's of a Dragon Ball Z ball which has a normal map. [A normal map describes depth](https://en.wikipedia.org/wiki/Normal_mapping) to the Source Engine. Here's a handy online tool to create normal maps @ [cpetry.github.io/](https://cpetry.github.io/NormalMap-Online/)

To test your own creation simply name it `test_ball_skin.vtf`, `test_ball_skin.vmt` and `test_ball_skin_normal.vtf` and overwrite the files in [this directory](minigolf-devkit/materials/minigolf/devkit/).


## Trails

Our trails are the same as the trails you're used to in Garry's Mod. We use [util.SpriteTrail](https://wiki.facepunch.com/gmod/util.SpriteTrail) to attach them to players and balls. Check the [addon materials directory](minigolf-devkit/materials/minigolf/devkit/) for an example taken out of [this repository (contains more examples)](http://www.frostmournemc.com/gmod/orangebox/garrysmod/materials/trails/).

To test your own creation simply name it `test_trail.vtf` and `test_trail.vmt` and overwrite the files in [this directory](minigolf-devkit/materials/minigolf/devkit/).


## Ball Area Effects

These are the easiest to make. Simply create a `.png` file with a 1:1 aspect ratio(256x256, 512x512, 1024*1024, etc). The ball will be in the center of it, so have your art be around that. An example can be found in the [addon materials directory](minigolf-devkit/materials/minigolf/devkit/)

To test your own creation simply name it `test_area_effect.png` and overwrite the file in [this directory](minigolf-devkit/materials/minigolf/devkit/).

