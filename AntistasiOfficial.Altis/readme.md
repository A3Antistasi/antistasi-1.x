***Air control project***

- Blufor aircraft trigger spawn of AA vehicles and few AA units at 4 km radius only.


This is from a chat with Barbolani

barbolani: if (_sideAlly) then {_allyUnits pushBack _x; if (vehicle _x isKIndOf "Air") then {_allyUnitsP pushBack _x}}

barbolani: btw all those isNil lines are useless, the guy that placed them does not know well steVariable command

barbolani: anyway from there you may add a condition which would be

barbolani: (({_x distance _markerPos < distanciaSPWN*3} count _allyUnitsP > 0) OR

barbolani: and on each of the zone types, add a check, if its _allyUnits or _allyUnitsP

barbolani: if its _allyUnits and normal distance, then spawn normally

barbolani: if its _allyUnitsP then tell the script to start iun an special way on which it will spawn the shika

barbolani: and enter in a loop of distance checks waiting for infantry or zone despawned

barbolani: if infantry enters, then spawn the rest

barbolani: so for example instead of this

barbolani: if (_marker in colinasAA) exitWith {[_marker] remoteExec ["createAAsite",HCGarrisons]};

barbolani: do this

barbolani: if (_marker in colinasAA) exitWith {if ({_x distance _markerPos < distanciaSPWN} count _allyUnits > 0) then {[_marker] remoteExec ["createAAsite",HCGarrisons]} else {[_marker,ShilkaOnly"] remoteExec ["createAAsite",HCGarrisons]}};

barbolani: and inside createAAsite

barbolani: _spawnedByAir = if (count _this > 1) then {true} else {false};

barbolani: and after spawning the shilkas

barbolani: if (_spawnedByAir) then {"BLUFORSpawn" distance checks form the marker center or despawn of the marker waitUntil loop}

barbolani: after the waitUntil if spawner getVariable _marcador returns false, it will spawn nothing

barbolani: if it returns true, then, there is some infantry around and MGs will spawn

barbolani: remember you would have to add a condition for despawn

barbolani: (({_x distance _markerPos < distanciaSPWN*3} count _allyUnitsP == 0) AND
- Add garage to Airport to let takeoff with jets and helis safely

- Add a one-time purchase expertise 


transport-heli(very cheap), attack-heli(expansive), jet(expansive). 
It will be stored in the savegame. (Dusty idea)

- Y menu option to make player eligible to control CAS 


if commander request CAS from USMC, the player can accept/refuse to direct control them

this function won't require the expertise because you're controlling a NATO character who, infact, knows how to 

- 
