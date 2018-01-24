private ["_toDelete"];

[[petros,"hint","localize "STR_HINTS_GARBAGE_CLEAR"],"commsMP"] call BIS_fnc_MP;

_toDelete = nearestObjects [markerPos "base_4", ["WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 16000];
{[_x] remoteExec ["deleteVehicle", _x];}forEach _toDelete;
{[_x] remoteExec ["deleteVehicle", _x];} forEach allDead;
[[petros,"hint","Garbage deleted"],"commsMP"] call BIS_fnc_MP;