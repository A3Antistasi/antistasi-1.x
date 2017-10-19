if (isNil {server getVariable "activeItem"}) exitWith {};

_object = server getVariable "activeItem";

if (server getVariable "BCdisabled") exitWith {
	{if (isPlayer _x) then {[petros,"hint","The device can only be activated once."] remoteExec ["commsMP",_x]}} forEach ([20,0,_object,"BLUFORSpawn"] call distanceUnits);
};

if !(server getVariable "BCactive") then {
	{if (isPlayer _x) then {[petros,"hint","Device activated."] remoteExec ["commsMP",_x]}} forEach ([20,0,_object,"BLUFORSpawn"] call distanceUnits);
	server setVariable ["BCactive", true, true];
	sleep 2700;
	server setVariable ["BCactive", false, true];
	{if (isPlayer _x) then {[petros,"hint","Device deactivated."] remoteExec ["commsMP",_x]}} forEach ([20,0,_object,"BLUFORSpawn"] call distanceUnits);
}
else {
	server setVariable ["BCactive", false, true];
	server setVariable ["BCdisabled", true, true];
	{if (isPlayer _x) then {[petros,"hint","Device turned off."] remoteExec ["commsMP",_x]}} forEach ([20,0,_object,"BLUFORSpawn"] call distanceUnits);
	[[propTruck,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
};