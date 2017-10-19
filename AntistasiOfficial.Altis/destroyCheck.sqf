params ["_marker","_workers"];

private ["_marker","_workers","_name"];

while {spawner getVariable _marker} do {
	if ({(alive _x) AND !(isNull _x)} count _workers == 0) exitWith {
		_name = [_marker] call AS_fnc_localizar;
		destroyedCities pushBack _marker;
		publicVariable "destroyedCities";
		[["TaskFailed", ["", format ["%1 Destroyed",_name]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
		if (_marker in power) then {[_marker] remoteExec ["AS_fnc_powerReorg",2]};
	};

	sleep 5;
};