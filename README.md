# Minnie-Danmaku-Tool [ARCHIVED]
## **Note From Author:**
Hey, so this is a pretty horrible project in retrospect but it was good for helping explore godot when I had first started using this. Please dont repleacte this or use it, there are some good ideas but overall garbage implementation. Maybe someday ill work on a v2
-Yarrow
## **Description:**

A bullethell pattern making tool for the godot game engine. It is NOT intended to be a code free solution to making bullethells(tho u can get pretty far with it imo). Its intended to be a tool that beginners can easily extend and adjust to their needs with basic knowledge of programming and allow designers to rapidly prototype bullethell patterns that they can then drop into levels for testing. The tool does not aim to include the ability to design movement patterns for the emitters or design generators for now in the interset of keeping the scope manageable for a 1-person project.This tool is not a proper godot "tool" in that it modifies the editor but I belive this makes it a bit more approachable for bigginer devs to modify and adjust to their needs.
Heres some of the stuff you can do with it:

![1](https://user-images.githubusercontent.com/42461443/155956640-927a0321-10a9-4f57-93be-0cafa1cbcc44.gif) ![2](https://user-images.githubusercontent.com/42461443/155956450-946ca045-a073-4910-99dc-810663a78909.gif)

## **Documentation Here:** 
https://nosebleedplant.github.io/Minnie-Danmaku-Tool/

## **Getting Started:**

To get started clone the repo or download the addon folder from here: [MinnieDanmaku.zip](https://github.com/NosebleedPlant/Minnie-Danmaku-Tool/files/8152527/MinnieDanmaku.zip)


If you clone the repo and work inside it then your good to go! congrats! Spit bullets to your hearts content
However if you want to work in a different project then copy over the addons to the root of your project so that your file structre looks something like:

![image](https://user-images.githubusercontent.com/42461443/155949358-b39281c4-bd08-49a1-b3cd-1fc3a48b955f.png)

Next we need to adjust your project settings a bit so that you can run the gui for the tool. Navigate to Project>>Project Settings>>General>>Display>>Window. Here we have to change your resoltion to 1920x1080 and the Streatch Mode and Aspect to 2d and keep respectively

![image](https://user-images.githubusercontent.com/42461443/155954437-1f597c7f-24f4-4530-a3cd-820e570ecae6.png)

Next go to the InputMap tab of the Project settings where we will bind the controls for the editor gui. Set up a "mouse_left" "mouse_right" and "rotate" binding then assign them the left mouse button, right mouse button and control key respectively.

![image](https://user-images.githubusercontent.com/42461443/155950726-625fe0dd-f799-4252-be4d-bd0e7063b361.png)

Feel free to change the rebind these inputs to different keys. If you wish to change the actual binding names you can do that too just be sure to change the following code in addons/Scripts/Main.gd to mach 
```
#_INPUT BINDINGS:
var input_spawn = "mouse_left"
var input_adjust = "mouse_right"
var input_rotate = "rotate"
```

And now you should be good to go. I understand that this is a bit annoying and that there are probably better ways to go about this but the project was made while learning the intricacies of godot and so is a bit rough around the egdes but I hope you will none the less give it a shot.

## **Using The System:**

Using the system is a fair bit more straight forward. Navigate to the Main scene in the addon folder, open it and "Play Scene". The following keys can be utalized to spawn and manipulate emitters:

| Key | Description |
| --- | --- |
| Right Click | Spawn a new emitter and a coresponding tab |
| Left Click | adjust the positon of the emitter by dragging |
| Ctrl+Left Click | adjust the angle of the emitter |

![Godot_YXmbkdVLCv](https://user-images.githubusercontent.com/42461443/155952326-6a466ff2-bfd8-4a01-a522-4c6ac7a1403f.gif)

The parameters of the emitters can be adjusted by utalizing the following fields in the editor:

![image](https://user-images.githubusercontent.com/42461443/155952483-d8de0d0b-6dfa-4707-9da9-f7a03837f387.png)

You can save the emitters you make and load them via the gui as well.


## **Bringing Emitters into Your Game:**

This is pretty straight forward too, to do this simply copy the Prefab Emitter scene found in addons/Prefab Emitter/Prefab.tscn into the secene you with to place the emitter in.
Next in the inspector for the scene you placed fill the Script Variable named Emitter Data File with the path to the emitter you wish to use. Boom. Your done you have the emitter running in your game. 

![Godot_r8pfn8a9pw](https://user-images.githubusercontent.com/42461443/155955778-0dff4abb-978b-4c2e-a2bd-0dca52e72835.gif)

