[[petros,"hint", "STR_HINTS_GARB_CLR"],"commsMP"] call BIS_fnc_MP;

{deleteVehicle _x} forEach allDead;
{deleteVehicle _x} forEach (allMissionObjects "WeaponHolder");
{deleteVehicle _x} forEach (allMissionObjects "WeaponHolderSimulated");

[[petros,"hint","STR_HINTS_GARB_DEL"],"commsMP"] call BIS_fnc_MP;