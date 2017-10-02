params ["_vehicle"];
private ["_crates", "_corpses", "_itemCount", "_stationary"];

if !(isNil "AS_scavenging") exitWith {};
AS_scavenging = true;
publicVariable "AS_scavenging";

_crates = nearestObjects [_vehicle, ["ReammoBox_F", "WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 20];
_corpses = [];
{
	if ((_x distance _vehicle < 50) && !(alive _x)) then {
		_corpses pushback _x;
	};
} forEach (entities "Man");

if (count _corpses == 0) exitWith {hintSilent "No corpses within range."};

_stationary = true;
[[petros,"hint","Deploying garden hoses..."],"commsMP"] call BIS_fnc_MP;
while {_stationary} do {
	{
		if (speed _vehicle > 1) exitWith {_stationary = false};
		{_vehicle addWeaponCargoGlobal [[_x] call BIS_fnc_baseWeapon,1]} forEach (weapons _x);
		{_vehicle addMagazineCargoGlobal [_x,1]} forEach (magazines _x);
		{_vehicle addItemCargoGlobal [_x,1]} forEach (assignedItems _x + items _x + primaryWeaponItems _x);
		_vehicle addBackpackCargoGlobal [backpack _x,1];
		if !(hmd _x == "") then {_vehicle addItemCargoGlobal [hmd _x, 1]};

		removeAllWeapons _x;
		removeAllItems _x;
		removeAllAssignedItems _x;
		removeVest _x;
		removeBackpack _x;
		removeHeadgear _x;
		removeGoggles _x;
		sleep 5;
	} forEach _corpses;

	{
		if (speed _vehicle > 1) exitWith {_stationary = false};
		[_x,_vehicle] remoteExec ["AS_fnc_transferGear",2];
		sleep 5;
	} forEach _crates;

	_stationary = false;
};
[[petros,"hint","Everyone's been sucked off, good to go."],"commsMP"] call BIS_fnc_MP;

AS_scavenging = nil;
publicVariable "AS_scavenging";