![The Minigolf Logo by Syff](.github/assets/logo_with_background.png)

# Deprecated Repository

This repository used to be useful when the minigolf gamemode was still private. That gamemode is now public and can be found [here](https://github.com/timothywalter/gmod-minigolf).

I will begin adding debugging functions to the minigolf gamemode and moving the mapping guide there soon. __After that I'll remove this repo.__


## Dev Kit Addon

This is not the whole Minigolf gamemode, but rather a minimal framework that mapper and other content developers can use to test their content. All custom code and content in this repository is licensed under the open-source MIT License (see [LICENSE](LICENSE) file for more information)


## Usage Instructions

### Using Git

1. Go to your `garrysmod/addons` directory
2. Run the command `git clone https://github.com/timothywalter/gmod-minigolf-contributing minigolf-devkit`

### Downloading as a zip

1. Download all the files in this repository (Click `code` -> `Download .ZIP` above or clone this repo) and extract the files from the zip
2. Create a `minigolf-devkit` directory in your `garrysmod/addons` directory. 
3. Copy all files from the zip into that new directory. Ensure that the `addon.txt` file and `lua` directory are directly located in `garrysmod/addons/minigolf-devkit`.
3. Restart Garry's Mod if it was opened (required)
4. Select a `golf_` map

### Starting
Start a Multiplayer server:
![Starting a multiplayer server](.github/assets/local_server.jpg)
You'll find debug information and the ability to play basic minigolf:
![The debug hud](.github/assets/debug_hud.jpg)

Read on to find out how to test other content


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

These are the easiest to make. Simply create a `.png` file and imagine the ball in the center of it, creating your art around the middle. An example can be found in the [addon materials directory](minigolf-devkit/materials/minigolf/devkit/)

To test your own creation simply name it `test_area_effect.png` and overwrite the file in [this directory](minigolf-devkit/materials/minigolf/devkit/).


## Contributing in different ways

Do you have some cool skill, thing or some other way you'd like to help us? Create an issue and let us know!

Thanks!