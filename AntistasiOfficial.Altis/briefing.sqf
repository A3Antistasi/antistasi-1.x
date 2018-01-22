waitUntil {!isNull player};

//Briefing - records order is reversed in game

player createDiaryRecord ["Diary",["8 Credits and Thanks","
Author: Barbolani<br/>
Coding since 1.2: Chris supervised by RickyTan & Kendo<br/>
Coding since 1.7.6: Jeroen & Sparker<br/>
Coding since 1.7.16: IrLED<br/>
Tweaking, fixing and supervising github commits since 1.7.12: Stef<br/><br/>

Scripts:<br/>
UPSMon by Monsada, Kronzy and Cool=Azroul13 <br/>
Jeroen Arsenal System by Jeroen Not.<br/>
Jeroen Garage System by Jeroen Not.<br/>
Persistent Save by zooloo75.<br/>
Tags by Marker and Melbo.<br/>
Advanced Towing by duda<br/>
iniDIBI2 by code34<br/>
Vcom AI by Genesis92x<br/><br/>

Briefing by Stef, Dethleffs, Fireman, everyone of the Official Community who add suggestions and corrections
IrLED: headlessclient balanced unit assignment, Vcom AI integration.<br/>
nuker: For testing and ideas.<br/>
Ghost: For MP DS testing and teaching me how to run a DS.<br/>
Nirvana and CWW clan for testing.<br/>
LanCommi on dedi server testing.<br/>
neuron: lots of testing and help in steam page.<br/>
Gillaustio and Farooq for inspirational works on revive system.<br/>
Valtas: support, testing bug reports and building the first serious open Dedi for Antistasi.<br/>
Goon and jw custom: part of the code for the NAPALM script.<br/>
Larrow: very valuable scripting help in BIS forums.<br/>
Billw: lots of help on testing and bug detection.<br/>
tommytom73: HC testing.<br/>
Manko: earplug snippet.<br/>
harmdhast: help on some scripting.<br/>
DeathTouchWilly: first Official Antistasi Manual.<br/>
daveallen10: ACE Integration scripts.<br/>
RickyTan: tons of help and testing in the Official Servers, Head of Antistasi Official Community since March 2016 ‘till June 2017 and making the community more financially aware.<br/>
Toshi: Antistasi porting on other islands.<br/>
Kendo and Tuck for templates.<br/>
And all those players who spend their time on making comments, suggestions and reports on Steam and Antistasi Official Community."]];

player createDiaryRecord ["Diary",["6 Compatible mods","
Antistasi can be enjoyed running a vanilla ArmA 3 version, or with compatible mods, as long as they don’t affect the AI.<br/>
Some mods are fully integrated in Antistasi; when loaded, these mods will change the warring factions as a whole, complete with different vehicles, gear and mechanics.<br/>
At the moment, these are: RHS: (AFRF,  USAF, GREF), TFAR and ACE3.<br/><br/>

ACE settings are given by default however they can be changed permanently in dedicated server by adding class to profile.arma3profile, TFAR frequency syncronization can be set before starting the mission in configure addons  check github for further informations.<br/><br/>

Items from these integrated mods are also included in Supply Drops and Ammoboxes.<br/>
Other mods, adding new weapons or other gear for instance, will only be available in game by buying them at the Sketchy Irishman.<br/><br/>

The Sketchy Irishman, also known as Devin, can be found by asking Petros for the Sketchy Irishman mission. At his shop, you can randomly purchase all items from installed mods. Do you want to play with that rusty WWII era mp40 or predator style minigun? You’ve got a chance to pick it up at the Sketchy Irishman’s shop! (No refunds.)<br/><br/>

The official Antistasi community server runs a small list of high-end mods. Visit a3antistasi.com or the community Teamspeak server to get the link to the steam collection and download them easily.<br/><br/>

IMPORTANT: Persistent Saving with a mod will make the save incompatible if you wish to revert back to playing without the installed mod. This won’t apply to client-side mods.<br/><br/>

Avoid mods that control or affect AI as these might break Antistasi AI mechanics.<br/>
You can check a3.antistasi.com for further information.
"]];

player createDiaryRecord ["Diary",["5 Antistasi Options","
By interacting with the physical Map asset at HQ you can set:<br/><br/>

Civilian spawn rate: we suggest a value of 2% (default);  they count as AI and as such, reduce performance. Keep in mind that below 1% no civilian vehicles will spawn, so no free transports.<br/><br/>

Spawn distance: 1 km is optimal, higher values might let you long range snipe, but game performance might suffer. <br/><br/>

Garbage clean: corpses and items on the ground consume memory, clearing these might freeze the game for a short while but FPS should improve. (Some garbage already has an auto-delete timer of 1 hour.)<br/><br/>

FPS limiter: below the threshold civilians will minimally spawn. <br/><br/>
"]];

player createDiaryRecord ["Diary",["4 Game difficulty","
Antistasi sets a unique ‘Skill’ and ‘Precision’ for AI, which increases based on Army XP Level and enemy resource management.<br/>
These are influenced by the ArmA 3 game difficulty settings, which you can adjust (in singleplayer) from the options menu and on a server on #missions boot. <br/><br/>

‘Skill’ primarily modulates AI movement (i.e. flanking and seeking cover).<br/>
‘Precision’ is the main parameter you want to adjust if you want to increase or decrease game difficulty. <br/><br/>

Important to note is that Arma 3 AI-skill level is also dependent on the game engine: if the PC / Server is overloaded many actions in queue will be cancelled and AI will perform badly.<br/><br/>
"]];


player createDiaryRecord ["Diary",["3 Spawn system & Performance","
Petros, Players, Controlled AI (i.e. freed refugees, recruited soldiers, squads and NATO/VMF ground units) trigger the spawn of enemies and civilians in a radius of 1km - the caching radius. NATO air vehicle won’t spawn in enemies to save performance. (There is a plan to add a chance of destroying the aircraft when flying through enemy territory.) <br/><br/>

Most enemies outside the caching radius will despawn and if you/your AI move in close again, they will respawn in a different position and at full strength.<br/>
Enemy MRAPs, patrol helicopters, refugees/POWs before liberation, convoys, AAF attack forces will be active regardless of the spawn range. <br/>
AAF attack forces only cache-in the friendly garrison of the objective and FIA roadblocks on the way. <br/><br/>

Arma 3 is badly optimized and can have game-breaking issues with more than 150 AI on the field. <br/>
Because of this, try to converge people to the same AO (Area of Operations) and avoid caching in too many enemies at once, as this will result in a poor game experience with low FPS or AI not reacting as they should.<br/>
Also, try to place HQ and Camps outside the spawning radius of towns and emplacements so they won't be cached-in permanently.<br/><br/>

Note that servers can add a Headless Client which will dramatically increase the handling of AI. There are 3 HC slots available.
"]];
player createDiaryRecord ["Diary",["2 Save Load Restart","
Vanilla saving option is disabled because it breaks the mission. In order to save progress, the Commander has to Persistent Save by interacting with the in-game Map at HQ and, upon restart, Antistasi asks if you want to load Previous Session. <br/>
If you’re a normal player your equipment, money and rank will be saved automatically upon disconnect.<br/><br/>

Saved data is stored in documents/Arma 3/user.vars.Arma3Profile and is saved separately for each island and respective blufor and greenfor version. <br/><br/>

What is saved:<br/>
- HQ location with static guns and vehicle within 50m without their inventory.<br/>
- deployed static guns in garrisoned territories.<br/>
- roablocks, garrisons, money, HR, garage, support.<br/>
- Arsenal items and Garage vehicles.<br/>

What isn’t saved: AI positions, items inside vehicle crates, recruited AI (part of their cost is refunded).<br/><br/>

To have multiple saves and keep your gear when disconnecting within 100m from HQ, run the mod inidbi2 by code34.
"]];

player createDiaryRecord ["Diary",["1 Welcome","
This campaign is a long lasting scenario which simulates guerrilla combat in an asymmetric warfare situation. It might take weeks to complete, however the fun comes from playing it step by step.<br/><br/>

There are several ways of playing Antistasi to complete the main objective.<br/>
The goal is to gain the support of more than 50% of the civilian population on the island. <br/>
The campaign is lost if CSAT destroys 8 towns by bombardment. <br/><br/>

Multiplayer notes:<br/>
- Parameters are accessible after selecting the mission in the role selection screen top right before the mission is started.<br/>
- The previous save is automatically loaded unless admin/host change Parameters enabling the fresh start<br/>

Special keys: <br/>
US keyboard = press  ‘Y’, ‘shift+Y’, ‘Delete’, and ‘U’ to access vital functions, be sure to unbind those keys from your custom controls otherwise they won’t work.<br/><br/>

German keyboard = press Z, shift+Z … instead.<br/><br/>

For more info and tips check categories on the left side.<br/>
"]];

//Begin Tutorial
_index =player createDiarySubject ["bt","Begin Tutorial"];

player createDiaryRecord ["bt",["HQ","
Place the HQ safely away from main roads, but possibly close to a small one.<br/>
DON'T set HQ inside of a building to avoid major collision bugs. <br/><br/>

Consider that mission vehicles spawn around the Campfire, purchased vehicles spawn around the Flag, reinforcements spawn at the closest road as do vehicles of players/AI when Fast Travelling. <br/><br/>

As said in ‘Spawn System’, Petros will keep an area of 1km cached in, so avoid placing the HQ where he will cache-in civilians or town patrols. (Even in friendly territory to save game performance.)  Enemies might just stumble into Petros and kill him while you’re operating far away.<br/><br/>

Once you safely placed your new HQ, interact with Petros, the Flag, Arsenal, Campfire and the Heal and Repair box to discover their unique functions.<br/><br/>

- Map: edit Antistasi Options and Persistent Save your progress, inspect detailed town, garrison and frontline info.<br/><br/>

- Flagpole: recruit AI, manage HQ.<br/><br/>

- Campfire: fast forward time by 8 hours and burn your feet. (Current missions will fail, and you can’t skip time when AAF attack is going on.)<br/><br/>

- Arsenal Crate: store loot and edit your loadout.<br/><br/>

- Heal and Repair box: heal, repair yourself and rearm AI. Reset undercover status and change vehicle plates, automatically resupply nearby HC units and static guns. Buy vehicles and static  weapons.<br/><br/>

 - Petros: ask for missions.<br/><br/>

HQ location is revealed to CSAT only if you scary a traitor and he manage to flee to an enemy base. Also, mortar fire is an easy way to get triangulated, expect aggressive enemies in both cases.


"]];

player createDiaryRecord ["bt",["Top Info Bar","

The Info Bar displays campaign info, resources and undercover status.<br/><br/>

-Commander: the current Commander. ‘None’ is displayed when membership is enabled and there isn’t any member online who is eligible to command. In this case, the following features will be frozen: economy per tick, main enemy response such as QRFs and Attacks and random mission spawns. <br/>
Press resign on Y (US-keyboard layout) menu when commander ‘none’ will check for a new commander.<br/><br/>

-Rank: affects the courage of AI in your squad and how precisely they will execute orders. Progress rank by killing enemies and, more effectively, by completing missions. In multiplayer you can also donate your money to FIA to gain ranks.<br/>
Player Rank is saved automatically in multiplayer upon disconnect.
<br/><br/>

- HR: Human Resources are used to recruit AI, add garrison troops to conquered emplacements. In singleplayer only, 10% of HR and 5% of money is subtracted every time you die. <br/>
Gain HR by escorting refugees or POWs to HQ, or controlling towns and cities.<br/>
Game ticks every 10 minutes add HR depending on the amount of civilians supporting FIA.<br/><br/>

- Money: in singleplayer, only 'FIA money' is available. Useful for buying vehicles, recruit AI, add garrisons and increase Army Xp Level. <br/>
In multiplayer the player’s and FIA accounts are separated; if you die you lose a percentage of your personal account.<br/>
Game ticks every 10 minutes add money to the FIA account depending on controlled territories.<br/>
Player Money is saved automatically in multiplayer upon disconnect.
<br/><br/>

- NATO support: Commander can call-in the friendly faction to assist in overwhelming fights (the friendly-faction is different depending on mod/vanilla blufor/greenfor). Check Commander Options diary entry and Antistasi Features - Support entry. <br/><br/>

- CSAT support: enemy-faction (again, different depending on mod/vanilla blufor/greenfor) will help the enemy as long the value increase and they’ll start bombarding towns. <br/>
After 8 destroyed towns the campaign is lost. CSAT support grows if you conquer enemy bases and airports, also if you destroy AA emplacements on named Hilltops. <br/><br/>

- Army Xp: indicator of Army Xp Level, check the relative diary section for a detailed explanation, the arrows let you know when you’re close to the next tier and, if they’re red, it means you haven’t matched the requirement for the next tier upgrade.<br/><br/>

- Overt / Incognito: indicator of your undercover status, when it displays Incognito, enemies will think you’re a civilian and ignore you. <br/>
Get undercover status by selecting it in the Y menu or by entering a civilian car. This is only possible if you match all the conditions. <br/>
Check relative diary section for a more detailed explanation.
"]];

player createDiaryRecord ["bt",["Y menu","
Hitting ‘Y’ will open the PDA, with 3 buttons on the far right which respectively correspond from top to bottom to: Player <br/>
Commander  <br/>
Admin.<br/><br/>

Move the cursor over the options to get a description.
"]];

player createDiaryRecord ["bt",["What to do","
The Arsenal is empty, with money barely enough to fund your first missions...<br/>
First goal is to gain money and scavenge gear. Ask Petros for missions and decide for yourself to go for them or not.<br/>
Missions aren’t the real goal of the game, just options that you might sometimes have to ignore. Look at the map or scout ahead, because some missions might just be impossible for your current capabilities. Binoculars and the Undercover system will be your friends. <br/><br/>

Missions are triggered within 4 km of your HQ. Don’t try them alone, gather friends or recruit AI at the flag, the latter aren’t as good as the enemy soldiers, but they can be useful for diversions and covering fire. Some objectives might be very remote, or are too risky to reach from HQ directly. If so, the Commander can set up a Camp where you can Fast Travel (teleport) to, speeding up your movement or giving you a safer approach.<br/><br/>

Scavenge gear, load it in a vehicle, go back to HQ, interact with the Arsenal, choose Transfer Vehicle Cargo to Ammobox to load all the gear into the Arsenal Crate. Check relative section Arsenal, Inventory and Unlocking below for more info.<br/><br/>

Enemies react to your moves by sending reinforcements or patrols departing physically from a base, so, reaction time is different depending on range from the base, what mode of transport the enemy uses and if they can reach you at all. <br/>
Try to eliminate the enemy quickly if you want to have a chance of looting and running away safely. <br/><br/>

Playing alone might be difficult unless you properly scout and know the territory. Try to recruit AI (1 or 2 can do the job, they aren’t trained enough to kill enemies, however they’re a great diversion or can provide covering fire if smartly placed). AI will try to revive you if you are downed and they aren’t engaged by enemies. <br/><br/>

However, Antistasi really shines if you play with friends, so join Antistasi Official Servers and make some new ones!
"]];
player createDiaryRecord ["bt",["Jeroen Arsenal System","
The inventory system in Antistasi is unique: Loading Previous Session will empty all the inventories from vehicles. Only the contents of the Virtual Arsenal and the inventory of the Arsenal Crate are saved. <br/><br/>

You can use them as follows:<br/>
- Arsenal Crate inventory = temporary storage for items. Gear transferred by the ‘Transfer Vehicle Cargo to Ammobox’ function will end up here. <br/>
- Virtual Arsenal = main gear storage. Move items from the Arsenal Crate into the Arsenal by pressing ‘To Crate’ in the Virtual Arsenal environment.<br/><br/>
By opening the Arsenal you will see JAS’s modified Arsenal interface. On the left hand side the item categories are displayed. Red categories indicate items not yet equipped.<br/><br/>

The number between brackets in front of each item is the actual number of copies in the Arsenal.<br/>
The same goes for the magazines (which are counted separately in single bullets), grenades and other consumables, displayed in the right hand side window.<br/><br/>

Unlike previous Antistasi versions, there is no way to unlock an item permanently and in unlimited amount. Everything is limited to what you actually scavenge and bring back to HQ.<br/><br/>

Accessing the Arsenal from the driver seat of a vehicle lets you add items into the vehicle itself.<br/><br/>

The custom buttons at the bottom are:<br/>
- Default gear: adds stuff that you’ll always need according to the modset.<br/><br/>
- To Crate: Moves all the items in the Arsenal Crate to the JAS inventory.<br/><br/>

AI Gear (WiP): recruited AI spawn with gear available in the Arsenal depending on their class. This won’t reduce the actual amount of stored items.
"]];

player createDiaryRecord ["bt",["Town allegiance","
The civilian population on the island has to be convinced that your cause is the right one. This is the goal of Antistasi. As you build up support in a town, the enemy tries to do the same.<br/><br/>

Each town has a number of inhabitants, that can either support you, the enemy or be neutral.
<br/>
You can check the current Town Support value on the Map at HQ, and when in a town, it is displayed in the bottom right corner.
<br/><br/>

Increase Town Support by killing enemy soldiers, bringing supplies, by leaflet drops, capturing the nearby power plant or establishing a propaganda station. <br/>
A successful mission nets the favor of a relative number of people which means not every mission gains the same % amount across different towns.<br/>

Town Support will drop if civilians get killed, the enemy bring supplies or if the town is without electricity.<br/><br/>

Towns will only be powered if they support the faction which controls the nearby power plant.<br/>


If the town supports the rebels, the enemy will cut their power and you will lose Town Support over time, same goes for towns that support the enemy and power plants you control.<br/>.<br/>

Towns supporting the enemy will have enemy patrols around, and towns supporting your faction will have a small friendly patrol around.
"]];

player createDiaryRecord ["bt",["Holding territories","
Everytime you conquer objectives or kill some special targets, the enemy will dispatch a QRF (Quick Reaction Force) from a base or airport. So, the first step to secure an area is to wait and defend it from that first attack.
Overtime, the enemy will check the garrisons of your emplacements and may decide to launch an Att
ack or simply send a patrol to take it back in case it’s abandoned.<br/><br/>

That said, you need HR to garrison the position and increase the ArmyXPLevel to make your garrison good enough to resist an Attack. Attacks are missions where massive amount of forces are sent to recapture an objective. Note that NATO is very handy in this case.<br/><br/>

* Most efficient garrison is a combination of static gun (placed/assembled) physically in the location by player manned by Militiamen who will do it automatically after beeing recruited.<br/><br/>

The Commander can set up a roadblock from the Y menu. Roadblocks are very effective in taking out one or two enemy vehicles thanks to their AT capabilities and .50 cal machine guns.<br/><br/>

"]];

player createDiaryRecord ["bt",["Missions","
Missions can be requested at Petros, as side missions at the Corrupted Politician/Officer, or they can appear spontaneously. <br/>
Most of them are scheduled by time and can be can tracked by checking the tasks on your map. There might be many active missions at same time; it’s your choice which one you want to complete.<br/><br/>

There are around 18 missions in Antistasi, but some missions might not be available in your HQ area (4 km radius), depending on surrounding towns, cities and base types.
<br/><br/>

The missions will vary in difficulty depending on nearby enemy positions (roadblocks, mortar positions and AA hilltops), the gear you equip, the manpower you bring and the amount of time you spend.<br/>
All these factors should be considered when choosing one mission over the other, and completion times can differ greatly depending on planning.
<br/><br/>

Ignoring missions is also a valid option, though ignoring missions may have repercussions, such as:<br/>
Kill the Traitor: lose a percentage of money and HR and attacks on your territories will be more frequent. <br/>
Supply Convoy: towns that are successfully supplied by the enemy convoy will gain support in their favor.<br/><br/>

Petros gives you 1 mission per type with a cooldown of 30 minutes real time, so skipping time won’t let you have another mission faster. On the other hand, mission time is based on in-game time, so if you skip time when missions are active, they will be considered failed.<br/><br/>

Note that requesting Propaganda on a town which has less than 12% FIA support will spawn a Leaflet Drop mission instead. The real propaganda spawns a custom propaganda truck.

"]];
//Antistasi Features
_index =player createDiarySubject ["af","Antistasi features"];

player createDiaryRecord ["af",["Class System","
Most of the playable classes have special abilities, and/or weapon proficiencies.<br/>
A class which doesn’t have a proficiency for a specific type can still use the weapon but with handling difficulties, everyone can use AT weapons without any malus.<br/>

Class affects: <br/>
- Officer: sneaky steps and harder to be spotted, less carrying capacity.<br/>
- Team Leader: standard<br/>
- Soldier: sneaky steps, less carrying capacity.<br/>
- Medic: can use medkit, can give blood (ACE basic), can use Surgical Kit (ACE advanced).<br/>
- Engineer: can use toolkit, with ACE can repair (everyone can change wheels if they have a toolkit).<br/>
- Autorifleman: loud steps, more carrying capacity, has proficiency for machineguns.<br/>
- Marksman: harder to be spotted, less carrying capacity, has proficiency for sniper rifles.<br/>
- Ammo Bearer: loud steps, more easily spotted, way more carrying capacity.<br/>
- AT rifleman: more easily spotted, more carry capacity.<br/><br/>

Choosing your class is important just as balancing the roles among your group is.<br/><br/>

In Singleplayer you can interact with the Arsenal Crate and Change Role anytime you want. Note that it won’t Persistent Save, so upon restart you will have to Change Role again.<br/><br/>

In Multiplayer you select your class upon login and you can change it by logging out and in again.

"]];

player createDiaryRecord ["af",["AI Management / Enhancements","
Commander and server members can recruit AI at the Flag or garrison conquered objectives. In the beginning of the campaign garrison troops wear civilian clothes and will be equipped with random weapons available in the Arsenal, according to their class.
<br/>
However, in the current version they don’t subtract the weapon from the Arsenal nor do they require a threshold amount to unlock them (Antistasi 1.7.5 and before). <br/><br/>

Advancing Army XP level is the way to make them better both in fighting skill and clothing choices.<br/><br/>

Commanding AI is a Vanilla feature. Hold fire, form line or file and regroup are very important. When driving a truck in undercover mode with AI as passengers. If not told to hold fire they might blow up your sneaky actions.<br/><br/>

Without a radio equipped you can’t control them if you go 500m away, in that case, they disappear temporarily from the bottom bar and start moving towards your position. <br/><br/>

The Y menu give options to tell selected friendly AI to:<br/><br/>

- Auto Heal: set this for each recruited AI to let them heal teammates and themselves automatically. <br/><br/>

- Auto Ream: send AI to scavenge ammo and weapons from enemy bodies or resupply at crates according to their class.<br/><br/>

- Remote control: if not undercover and no enemies nearby, lets you control the AI to fix some pathfinding issues or simply manage their inventory. You will lose control after 60 seconds or if the AI takes damage. You can access the arsenal and equip them how you wish to.<br/><br/>

- Dismiss: send the unit back to HQ. Upon arrival their cost in money and HR is refunded.
"]];
player createDiaryRecord ["af",["Army Xp and Level","
Army Experience affects the skill of FIA recruited troops, reinforcements and garrisons. Gain Experience by fighting, completing missions and capturing objectives.<br/>

<br/><br/>

Army Level:
0) XP cap at 4, Recruits wear civilian clothing, Garage slots = 10 FIA and 3 Personal, can store basic vehicles and MRAPs only, HR cap at 50, Camps 2, normal Roadblocks 2, normal Watchposts 2.<br/><br/>

1) XP cap at 8, 25% Recruits wear guerrilla uniforms, Garage slots = 15 FIA and 5 Personal, can store APC, HR cap at 75, Camps 3, normal Roadblocks 4 , normal Watchposts 3, one-off NATO boost +10.<br/><br/>

2) XP cap at 12, 50% Recruits wear guerrilla uniforms, Garage slots = 20 FIA and 10 Personal, can store also Helicopters, HR cap at 100, Camps 4, enhanced Roadblocks 6 , enhanced Watchposts 4, one-off NATO boost +20<br/><br/>

3) XP cap at 20h for both FIA and personal, all vehicles can be stored, HR cap at 150, Camps 5, enhanced Roadblocks 10, enhanced Watchposts 6, one-off NATO boost +30.<br/><br/>
"]];

player createDiaryRecord ["af",["Jeroen Arsenal Garage","
Accessing the Garage opens a custom interface which lets you select the vehicle on the left side, and interact with the vehicle on the right.<br/><br/>

The camera can be tricky, so place the box in open field without obstacles around, the vehicle preview will spawn opposite your position at same distance you are from the crate. Keep some distance from the box to spawn the vehicle a little further. <br/><br/>

Vehicles can be repaired piece by piece, glass included, through JAG and also reskinned. <br/><br/>

Stored vehicles are visible for everyone in the Garage. Green vehicles are yours, white ones are retrievable by everyone and red vehicles are locked. Only the owner of a vehicle can unlock a vehicle.<br/><br/>

Note: Static Weapons can be garaged like other vehicles and, found under their respective tab, can be attached to off-roads, trucks or other vehicles with a weapon hardpoint.
"]];

player createDiaryRecord ["af",["Jeroen and Sparker Logistic","
Crates, ammoboxes and several others can be interacted and Load to vehicle, an animation will move the object into the vehicle locking up some seats if necessary. <br/><br/>

Bring supplies, steal enemy ammobox, move Arsenal and Garage when relocating HQ thanks to this function without using any additional mod.

WiP

"]];


player createDiaryRecord ["af",["Fast Travel","
Fast Travel lets you skip journeys which might be considered a waste of time, it is a teleport with variable travel time (black screen) scaled to destination distance. <br/>
On foot, you are teleported directly to the map marker location, along with any AI in your group.<br>
If you are the driver of a vehicle, the whole crew will travel with you. Vehicles will end up on the road closest to the map marker location. <br/><br/>

Conditions:<br/>
- Allowed destinations are the HQ or Camps.<br/>
- No enemies must be present within 350m around both the place of departure and destination.<br/><br/>

Warning:<br/>
- Each Fast Travel to a Camp has a chance of being intercepted; enemies will send a helicopter and an infantry squad will fast-rope down and attack the Camp. Travel to HQ is always safe.<br/>
- Avoid Fast Travelling vehicles while towing other vehicles, the latter have a high chance of exploding, or disappearing.<br/>
- Avoid Fast Travelling with air vehicles or boats, again, a high chance of exploding.
- In multiplayer you won’t notice other players are Fast Travelling (if you’re all in a car, only the driver will have the black Fast Travelling screen).
- Be sure you’re not doing it at same time AND to the same location when driving vehicles, as they -you guessed it- might explode.<br/><br/>

Fastravel High Command groups: as commander select a group in high command, open y menu, hit fast travel. This will instantly teleport the friendlies to the location if conditions are matched.


"]];
player createDiaryRecord ["af",["NATO & CSAT Support","
Friendly Faction support is gained by helping civilians, capturing bases and eliminating enemy support units.<br/>
It is decreased when civilians are hurt (killed, or angry for loss of power) or prisoners are killed.<br/>
The Commander can use Friendly Faction support for support actions (check relative section).<br/><br/>

Enemy support is accrued by conquering Bases, Airports and Hilltops.<br/>
It can be reduced by asking friendly support faction to raid their military emplacements away from Altis.<br/>
If Enemy support gets too high, the Enemy Faction starts bombarding towns. If they destroy 8 towns the campaign is lost.
"]];

player createDiaryRecord ["af",["Frontline system","
Depending on controlled objectives, towns excluded, the enemy will build roadblocks and reinforce more outposts.
WiP
"]];



player createDiaryRecord ["af",["Server Membership","
In multiplayer, the Server Admin can give membership to players by using the Y menu and looking directly at the player. To keep the membership you can add a member list on the dedicated server, it has to be in \Arma3\A3Antistasi\memberlist.txt<br/><br/>

Server membership is the best way to prevent random people from interfering with the Antistasi campaign in an open server, but lets people still enjoy Antistasi, with some options frozen;<br/><br/>

if no members are online, the commander slot will be empty, so no economy per tick, no main enemy response and no random mission spawns.<br/><br/>

Member privileges:<br/>
- Eligible to be Commander. <br/>
- Recruit AI.<br/>
"]];

player createDiaryRecord ["af",["Undercover","
When Undercover is enabled you will see the word ‘Incognito’ in green on the Info Bar and enemies will ignore you.<br/><br/>

Conditions to satisfy to become undercover:<br/>
- not being reported in the last 30 minutes. If reported, hitting the Heal, Repair and Rearm option at HQ will allow becoming undercover again immediately. Respawning also re-enables it.<br/>
- no enemies present within a 350 m radius.<br>
- wearing civilian clothes and no military gear equipped. A hint screen on the top right will list what items are preventing you from going undercover.<br/><br/>

If you meet the above conditions you can get Undercover by:
- enabling Undercover from Y menu.
- getting into an unreported civilian vehicle. In this case, you can even have military gear equipped.<br/><br/>

You will always lose undercover when you are:<br/>
- within ~150m from, Outpost, Base or Airport.<br/>
- within ~50m from a patrol with a dog.<br/>
- spotted treating yourself or someone else<br/>
- spotted placing explosives.<br/>
- spotted repairing vehicles.<br/><br/>

In a vehicle, undercover is lost if you are:<br/>
- spotted driving ~25m off road.<br/>
- driving over an enemy soldier.<br/>
- if you disembarking without matching the equipment conditions.<br/>
- if someone who isn’t undercover enters your vehicle with enemies around.<br/>

On foot, undercover is lost when:<br/>
- equipping military gear or dropping your civilian clothes (you can’t be undercover when naked).<br/><br/>

Note: ‘being spotted’ doesn’t require line of sight, it’s a radius around enemy units.
"]];

//Commander Options
_index =player createDiarySubject ["cm","Commander Options"];
player createDiaryRecord ["cm",["Moving HQ","
HQ can be moved by the Commander who has to: <br/>
- Interact with the physical Flag, choose 'HQ options' and click 'Move HQ', <br/>
- Petros joins the Commander’s squad, so tell him to move to reach the new location, on foot or as a vehicle passenger. <br/>
- Arsenal and Vehicle Crates have to be loaded on a truck, drive up to them and then interact with the crates to ‘Load Cargo in Vehicle’.
- Once on the desired place, talk to Petros and ‘Build HQ’. <br/><br/>

The game allows you to move your HQ to wherever, even inside an enemy base with enemies in the surrounding, it’s up to you to make the smart decision on where move it, see the website for hints on good HQ locations.
"]];
player createDiaryRecord ["cm",["NATO Support","
The Commander can call in various forms of support from the Friendly Faction by choosing one of the options through Y menu (Commander tab). Unit or vehicle types and strength of the intervention will depend on your current support value. Each type cost support points and are explained below.<br><br>

Support must physically travel to their target and they can get engaged before they arrive, this is important to remember especially for air forces, considering that each named hilltop has a spec-ops AA emplacement which can easily destroy them.<br/><br/>

There is a timer of 30 minutes, after which you lose control of them and they will return to base.
<br/>
You can’t board friendly support vehicles nor garage them.<br/><br/>

- Air assault: not working. send a mix of transport and assault helicopters, No control on High Command.<br/><br/>

- Armored assault: select a controlled Base, Select waypoint, No control on High Command.<br/><br/>

- Artillery: select a controlled Base, select the unit from High Command bar and press Shift+Y.<br/><br/>

- Roadblock: select a controlled Base, Select a point on a road, Control on High Command to move them on location to build the effective Roadblock <br/><br/>

- UAV: depart from Carrier or closest controlled Airport, Control on High Command to move it where you desire.<br/><br/>

-Resupply: select the approximate location where supply box should be dropped, Control on High Command and move it to designated location, will be marked by blue smoke. Contents depend on FIA Army level<br/><br/>

- CAS: Close Air Support; 3 air assets depart from Carrier or closest controlled Airport, Control them on High Command move them where you want.<br/><br/>

- Bomb Run: select entry and exit point, a plane will depart from Carrier or closest controlled Airport, No control from High Command, requires practice to be effective.<br/><br/>

- QRF (xx points): Quick Reaction Forces; Small transport helicopters depart from Carrier or closest controlled Airport deploying troops at designated location.
"]];

player createDiaryRecord ["cm",["Reinforcements","
Commander can invest HR in FIA forces, controlled through High Command bar. These soldiers are affected by Army Xp Level. Once recruited they last until they die, get dismissed or the game is restarted (in which case they will get refunded depending on their health status).<br/><br/>

You can directly control the leader of each group by selecting the team in High Command mode and using the Direct AI Control function in Y menu.<br/><br/>

* If RHS mod is loaded, this truck is unavailable and nothing will spawn.
** Mortar teams have some (un)deploy time when given a movement order. Once deployed you’ll notice a different icon on the map and only then are they ready to fire.<br/>
Press Shift+Y after selecting the mortar team and click on the map to choose a location to order a mortar strike.<br/>
Mortars have limited range and ammunition. They can be resupplied at HQ by the Heal, Repair and Rearm function.
"]];

player createDiaryRecord ["cm",["Garrison","
The Commander can invest HR in FIA forces that garrison conquered emplacements or the HQ itself. These soldiers are affected by Army Xp Level and can’t be controlled directly. <br/><br/>

At your HQ, interact with the Flag, HQ management, Recruit Garrison. Select the emplacement you want to garrison and add units.<br/><br/>

Adding manned static weapons: assemble/bring a static gun within the controlled area, add to garrison a militiaman from HQ flag and he will man the gun. Garrison Info (viewed at HQ Map) will display the number of manned static weapons. Statics are powerful but require visual on enemy, try to make so they’ll see in advance maybe with an observation post on the adiacent hill.<br/><br/>

Garrisoned mortar teams will engage anything over a long range, so be careful about where you station them to minimize friendly fire, civilian casualties and collateral damage.
<br/><br/>

Note: Huge garrisons might lower game performance, please check relative section for more information.
"]];

player createDiaryRecord ["cm",["Emplacements","
In the Y menu, the Commander can manage:<br/><br/>

- Roadblocks: placed on roads, will defend the area with a .50 cal and rpgs: ideal to stop normal enemy patrols and even convoys, when they are upgraded to enhanced Roadblocks  (Army Level > 12).<br/><br/>

- Watchposts: placed in the field, 2 man sentry will observe the area reporting contacts through the High Command interface.<br/><br/>

- Camps: allow people to fast travel. There are crates with some free equipment and the ability to restore health and fuel, but vehicles can not be repaired here.<br/><br/>

- HQ fortifications: consider these cosmetics, as the HQ isn’t supposed to be a fortified position.<br/>
Lantern to illuminate the base a bit better than the Campfire.<br/>
Vehicle pad show a safe landing for helicopters .<br/>
Camo net occludes Petros and the camp from enemy aircraft, but might collapse or cause mission vehicles to explode upon spawn if placed too close to campfire, so be really careful.
"]];

player createDiaryRecord ["cm",["Maintenance","
Some sticky situations can be fixed by the commander or admin, access them from Y menu.<br/><br/>

- Reset Petros Position: to fix the ‘too far from HQ’ bug when trying to move assets around the HQ.<br/><br/>

- Reset Static positions: static weapons around HQ can be moved like other assets for a limited time, if the timer expires, use this command to make them movable again.<br/><br/>

- Reset HQ: reset HQ location around Petros’ position. Note: if Petros was moved inside a building by ACE cable tie, collision bugs will occur.
"]];
