# Mapping for MiniGolf
The mapper has full control of the minigolf tracks using the scripted entities (SENTs) specified in the chapter below.

![Example of a sent_minigolf_start and trigger_oob brush](.github/assets/mapping/object_information_panel.jpg)


## Examples

* Cool experimental map by [Elkinda](https://steamcommunity.com/id/Elkinda/): [golf_test_course20.vmf](https://mega.nz/file/h1BlEAwK#E3YEXd41_tgTBmjmD1Uu2h4RXlUhMqnPIZT-b7WFNq4) (Compiled: [golf_test_course20.bsp](https://mega.nz/file/tsgVTSgI#4L-KcURZOAHDOf7wxRekFjOmdXcF8mzQfe0swqz6uuk))
* Start of a simpler map by Timothy: [golf_desert_alpha3.vmf](https://mega.nz/file/cwhxxBjb#HM4SEO7TDeVLljNFTb_ncHLvn2Vl2HsSzr_9o7nUq0M) (Compiled: [golf_desert_alpha3.bsp](https://mega.nz/file/UpwlxL7L#G6gzQKi501-584jLmWRxwJGYpZzOcGv_CSvswS0cl44))


## Scripted Entity Reference

* Start entity: `sent_minigolf_start`
  * Describes where players start to play on a minigolf track (by pressing `USE` on it). The hole and description are displayed on the players' GUI.
  * These following properties are valid for this entity:
    * `par`: how many strokes is average (required)
    * `hole`: the name (required)
    * `limit`: time limit in seconds (default: 60)
    * `description`: a description for the hole
    * `maxStrokes`: how many strokes are allowed before the game ends automatically (default: 12)
    * `maxPitch`: how many degrees pitch a player can make a lob shot at, don't specify or set as 0 to indicate no lob shots allowed (default: 0)
  * How to create this Point Entity in hammer:
    1. In hammer [spawn a new Point Entity](https://developer.valvesoftware.com/wiki/Entity_Creation) and select it
    2. [Open the object properties by pressing `Ctrl + Enter`](https://developer.valvesoftware.com/wiki/Hammer_Object_Properties_Dialog)
    3. In the `Class` dropdown select all text and remove it, typing `sent_minigolf_start` instead. The entity will always have the [`Obsolete` icon](https://developer.valvesoftware.com/wiki/Obsolete)
    4. Turn of `SmartEdit` by clicking the button
    5. Click `Add`
    6. Now type in the properties listed above under `Key`. 
    7. Give your desired value under `Value` then click OK to finalize your configuration.
    8. When the map is loaded by the gamemode these values are stored in memory.
* End entity: `sent_minigolf_goal`
  * Specifies the end/goal/hole. When the ball touches this the player will have reached the end in as many strokes as they have up to that point.
  * Because of this design, in theory it's possible (untested) to have a hole with a single start and multiple valid ends (that all point to the same start.)
  * These following properties are valid for this entity: 
    * `hole`: the name (must match a start hole’s name)
  * See `sent_minigolf_start` on how to create this entity in hammer. Except for the classname and keyvalues instructions are the same.
* Out of bounds brush: `trigger_oob`
  * When the ball touches this brush the ball is considered Out-Of-Bounds. The ball will be reset to the last valid position.
  * There are no properties for this entity.
  * How to create this Brush Entity in hammer:
    1. Create one or multiple brushes in Hammer, along the edge and over the top of the minigolf track. 
    2. Give these brushes the 'trigger' material on all faces. 
    3. Now press [`Ctrl + T` to tie it to an entity](https://developer.valvesoftware.com/wiki/Hammer_Tools_Menu#Tie_to_Entity_.3CCtrl.2BT.3E)
    4. Choose `trigger_oob` as the entity type by typing it into the class name.


## Tips & Problems

### Prevent your compile time from skyrocketing

Source Engine is great at optimizing games for computers with non-ideal hardware. Some of this optimizing is done before-hand, for example when compiling the map. **If you notice that compilation is taking longer than half a minute you should check the following.**

1. Compile your map (`File > Run Map`)
2. In Hammer, go to `Map > Load Portal File`
  ![Loading a portal file](.github/assets/mapping/load_portal_file.jpg)
3. A simple healthy map looks like this:
  ![Simple empty map](.github/assets/mapping/portals_simple.jpg)
4. Let's create a minigolf hole in it, compile and then reload our portal file:
  ![Complex portals due to minigolf hole](.github/assets/mapping/portals_complex.jpg)
5. To fix this we will tie the brushes that make up the minigolf track to a `func_detail` entity (select all those brushes and press `Ctrl + T`):
  ![Complex portals due to minigolf hole](.github/assets/mapping/tie_to_entity.jpg)
6. After we compile again and re-load our portal file we see that it has helped to reduce portals:
  ![Simple portals again](.github/assets/mapping/portals_fixed.jpg)

_[Click here to read more about how these portals optimize the game](https://developer.valvesoftware.com/wiki/Visibility_optimization), as well as to see why we don't need them around our minigolf tracks_