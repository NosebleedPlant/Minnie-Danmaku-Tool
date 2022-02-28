#  Documentation
The scripts are available in the "Scripts" folder feel free to edit them to suit your needs, below I provide basic documentation. Note the GUI editor uses degrees but all the angles under the hood are in radians.

## Classes:

| Attribute     | Description |
| ---               | --- |
| Main              | Primary script that manages the interactions between user and system|
| Player            | Rudamentary player controler script|
| Default_Bullet    | Basic bullet script|
| Abstract_Emitter  | Abstract emitter class that contains major functionality for all emitters| 
| Editable_Emitter  | Implementation of Abstract_Emitter; setup to allow editing from GUI and saving created patterns. Meant to be used in creating enviorment|
| Prefab_Emitter    | Implemenataion of Abstract_Emitter; setup to load emitter data on start up and is meant to be used in your actual games|
| Tab               | GUI backbone script; is responsible for handling GUI updates in editor|

## Main:

The main control class that acts as the glue between the user interface and the emitter. The emitter being used has been exported to the inspector so you can swap in one that you have customized if you so desire

| Attribute     | Description |
| ---               | --- |
| Emitter                 | preloaded Emitter scene|
| Tab                     | preloade Tab scene|
| emitter_count           | count of emitters that have been spawned|
| emitter_editing         | refence to emitter currently being editted by user|
| tab_count               | count of tabs that have been spawned|
| tab_emitter_map         | dictionary that maps tabs to their emitters|
| emitter_tab_map         | dictionary that maps emitters to their tabs|
| repositioning_emitter   | flag that indicates user is repostioning an emitter|
| rotating_emitter        | flag that indicates user is rotating an emitter|
| player                  | reference to player scene|
| main_tree               | easy access to scene tree| 
| editor                  | reference to editor scene|
| screen_size             | stores the screen size|
| input_spawn             | string identification of key_binding used to spawn emitters|
| input_adjust            | string identification of key_binding used to reposition emitters|
| input_rotate            | string identification of key_binding used to rotate emitters|

### methods:

**_unhandled_input(event):**
```
params:input event that occured
return:none
Handles the user input to spawn an emitter. Checks to see when user stops adjusting emitter and disables repostion and rotation flags accordingly
```
**_process(delta):**
```
params:delta between frames
return:none
calls repositiong and rotation function according to set flags. Sends player position information to all bullets for collision detection.
```
**spawn_Emitter():**
```
params:none
return:emitter
instantiates an emitter at the location of mouse click.
```
**spawn_Editior():**
```
params:none
return:tab
instantiates an editor tab that will correspond to the emitter that was just spawned.
```
**reposition_Emitter():**
```
params:none
return:none
lerps the emitter position to mouse allowing for drag to reposition.
```
**rotate_Emitter():**
```
params:none
return:none
rotates the emitter to look at the mouse position
```
**adjustment_Input():**
```
params:emitter being adjusted, input event triggered
return:none
based on input event enables rotation and reposition flags, sets the reference for emitter being adjusted 
```
**update_Param():**
```
params:tab,value
return: none
this is a collective documentation for a set of functions that look like "update_Name(tab,value)","update_PositionX(tab,value)" etc.
Functions call the emitter corresponding setters with the value provided for emitters that the tab provided is responsible for.
```
**load_Selected():**
```
params:tab,path of emitter to be loaded
return:none
calls the load emitter function on the emitter that the provided tab is responsible for. It then proceeds to update the fields with the loaded values of the emitter.
```
**save_File():**
```
params:tab,path to save emitter in
return:none
saves the parameters of the emitter that this tab is responsible for by calling the save() function with the path provided
```
**delete_Emitter():**
```
params:tab
return:none
Godot's tab system is a bit wonkey so this function is somewhat of a comprimise. The fucntion deletes the emitter that the provided tab is responsible for but only hides the tab itsef. Why the tab is only hidden is a long story but it works and you are welcome to change it if needed.
```


## Player:

A basic player class to serve as a test dummy for aiming at. Its very rudamentary.

### methods:

**_process(delta):**
```
param:delta
return:none
Called every frame. Maps the player position to the mouse position
```


## Default_Bullet:

A basic bullet class. It has rudamentary point on circle collision detection. I deliberatly left this very bare bones so that you can edit it as u see fit if in order to optamize performance and balance you need. I would suggest inhereting and overriding if you want to expand on this class but it should be fine to make one from scratch as long as you include set_PlayerPosition() function in ur new class. Also note; collisions will not work outside addon enviorment since its best to tailor those to the performance needs of your game.

| Attribute     | Description |
| ---               | --- |
| bullet_speed      | speed at which the bullet moves|
| bullet_life_span  | total lifespan in seconds of the bullet|
| life_time         | current age of bullet|
| bullet_radius     | the size of the bullet hitbox|
| collided          | turns true when collision is detected|
| player_position   | vector used to store player position|

###  methods:

**_process(delta):**
```
param:delta between frames\n
return:none\n
Called every frame. Calls move,age and collision detection functions.
```

**_extra_behaviour(delta):**
```
param:delta between frames
return:none
virtual function for adding new behaviour to bullet when extending class
```

**move(delta):**
```
param:delta between frames
return:none
moves position of bullet
```
**age(delta):**
```
param:delta between frames
return:none
increases the age of the bullet, if the lifespan is reached it frees the bullet.
```
**collision_Detection(playerVec:Vector2)**
```
params:player position vector
return:none
simple point on circle collsion detection method.
```
**set_PlayerPosition(playerVec:Vector2)**
```
params:player position vector
return:none
updates the stored player location.
```

## Abstract_Emitter:

An abstract class for emitter that the editable emitter and prefab emitter inherit from. Godot does not let me enforce setters and getters via private virable but I would strongly encourage you to use them for all attributes in the class.

| Attribute     | Description |
| ---               | --- |
| Bullet                | used to load and store bullet scene for quick instancing|
| fire_rate             | fire rate of the emitter in seconds per bullet, ie: how many seconds between each shot fire. It makes it easier to write code and is easier to understand then bullets per second imo|
| clip_size             | number of bullets fired before a reload is required| 
| reload_time           | time in seconds that it takes to reload|
| angular_veloctiy      | speed at which the emitter rotates|
| angular_acceleration  | rate at which the angular velocity changes|
| max_angular_velocity  | maximum angular velocity achived by emitter, when achived the direction flips|
| volley_size           | number of bullets in a single volley|
| spread_angle          | angle of spread in a single volley|
| spread_width          | distance between each individual bullet in a volley|
| array_count           | number of bullet arrays|
| array_angle           | angle between each bullet array|
| aim_enabled           | when true, disables rotation and targets emitter at player|
| aim_pause             | wait in seconds before retargetting aim at player|
| aim_offset            | angle offset between when aiming at player|
| player                | stores player object for aiming |
| controler             | stores the controller class that this emitter is child to|
| aim_timer             | timer to keep track of pauses between aim|
| shot_timer            | timer to keep track of wait between shots|
| reload_timer          | timer to keep track of wait between reload|
| shot_count            | tracks number of shots fired,resets after reload|
| bullet_adress         | stores the adress of the bullet scene this  emitter is using|
| bullet_speed          | stores the speed of the bullet scene this  emitter is using|
| bullet_lifespan       | stores the lifespan of the bullet scene this  emitter is using|

### methods:

**_process(delta):**
```
param:delta between frames
return:none
calls movement and bound handling functions. Also calls the aim or rotate functions based on enabled flags. When not reloading or on shot cooldown it calls the shoot function and checks magizine via clip management fucntion.
```

**_move():**
```
virtual function for emitter movement
```

**_bound_Handler():**
```
virtual function of handling going out of bounds for emitter
```

**aim(delta,player_position):**
```
param:delta between frames, the position of the player. Requres there to be a "Player" node for it to work
return:none
rotates the emitter to look at player when the aim referesh is off cooldown
```

**rotate(delta):**
```
param:delta between frames
return:none
Updates the angular veloctiy with the accerate_Rotation() function. Rotates the emitter every frame based on the angular velocity.
```

**accelerate_Rotaion(delta):**
```
param:delta between frames
return:float
Increases the angular velocity based on the angular acceleration and returns the new angular velocity
```

**cooldown(delta):**
```
param:delta between frames
return:boolean
Checks to see if the cooldown between shots has been completed
```

**reload(delta):**
```
param:delta between frames
return:boolean
Checks to see if the reload wait between shots has been completed
```

**shoot():**
```
param:none
return:none
for each array the function instances a volley of bullets and adjusts their position and rotaion accordingly
```

**instance_Bullet(childBullets,angle):**
```
param:empty array to store a single volley of bullets,starting angle of array
return: childBullets array
instances a volley of bullets with the starting angle of the array and stores them childBullets array
```

**position_Bullet(childBullets,angle):**
```
param:empty array containing a single volley of bullets,starting angle of array
return:childBullets array
adjusts the starting position of a volley of bullets according the array angle and returns updated childBullets container array
```

**rotate_Bullet(childBullets,angle):**
```
param:empty array containing a single volley of bullets,starting angle of array
return: childBullets array
adjusts the starting angle of a volley of bullets according the array angle and returns updated childBullets container array
```

**clip_Managment():**
```
param:none
return:none
checks to see if clip has been emptied; forces reload when needed
```

**load_Emitter(filepath):**
```
param:path to file in string form
return:none
loads params from a saved emitter
```

## Editable Emitter:

Inherits from Abstract_Emitter
This class extends abstract emitters functionality by creating a custom initalization fucntion and also adding a save function to save emitters designed by users and and input event function to allow users to adjust the emitter using their mouse

| Attribute     | Description |
| ---               | --- |
| screen_size     | stores the screen size, used when checking if inside camera frame|

### methods:

**init(pos,name_str):**
```
param:position of the player as Vector2;name of emitter as string
return none
initalization function so that it is set to the correct position is assigned a correct name when the emitter is spawned
```

**save(file_path):**
```
param:path to file in string form
return:none
saves the attributes of the emitter to a file
```

**on_Input_Event(viewport, event, shape_idx):**
```
param:input event;other 2 unused
return:none
event triggered by signal when input occurs in area of emitter; used primaily to norify Main that this editor is being manipulated by user
```

**_bound_Handler()**
```
param:none
return:none
overriden function; clamps the emitter to the inside of the screen
```

## Prefab Emitter:

Inherits from Abstract_Emitter
The version to of the emitter that is meant to be used in your actual game. It loads the emitter data on ready

| Attribute     | Description |
| ---               | --- |
| emitter_data_file | data file that contains all the emitter params of a saved emitter|

### methods:

**_ready():**
```
param:none
return:none
loads the emitter data when entering scene, *except* position data
```

## Tab:
| Attribute     | Description |
| ---               | --- |
| controler         | easy access to Main for updating the Emitter when a field is updated|

### methods:

**init(idx,emitter_name,position,fire_rate,volley_size,array_count):**
```
param:index of the tab which also serves as the name, starting position, starting fire rate, starting volley size, starting array count 
return:none
Initalizes the editor tab with default values of teh emitter.
```

**on_set_Param(value):**
```
SIGNAL EVENT FUNCTIONS
param:none
return:none
this is a collective documentation for a set of functions that look like "on_set_name()","on_set_X()" etc.
Functions triggered when a field in the tab is updated. They call the correspoding update function in controler. There is one for each editable param Abstract_Emitter
```

**on_LoadEmitter():**
```
SIGNAL EVENT FUNCTION
param:none
return:none
pops up the Load Warning for the user so they are aware that unsaved changes will be lost
```

**on_acceptLoadWarning():**
```
SIGNAL EVENT FUNCTION
param:none
return:none
pops up the file loading dialoug if the user accepts the warning
```

**on_loadSelected(path):**
```
SIGNAL EVENT FUNCTION
param:path of emitter user wishes to load
return:none
calls the load_selected function with the path selected by the user on controler to load an existing emitter 
```

**on_LoadBullet():**
```
SIGNAL EVENT FUNCTION
param:none
return:none
pops up the file loading dialoug
```

**on_bulletSelected(path):**
```
SIGNAL EVENT FUNCTION
param:path of bullet user wishes to load
return:none
calls the update_Bullet function with the path selected by the user on controler to load an existing bullet
```

**on_SaveEmitter():**
```
SIGNAL EVENT FUNCTION
param:none
return:none
pops up the file saving dialoug
```

**on_savePathSelected(path):**
```
SIGNAL EVENT FUNCTION
param:path of bullet user wishes to load
return:none
calls the save_File function with the path selected by the user on controler to save the current emitter
```

**set_Param_field(value):**
```
FIELD UPDATE FUNCTIONS:
param:new value of field
return:none
this is a collective documentation for a set of functions that look like "set_Name_field()","set_Position_field()" etc.
Functions set the corresponding field to display the value provided. There is one for each editable param Abstract_Emitter. 
For parameters that deal with angles these functions convert the angle to degrees for easier use.
```
