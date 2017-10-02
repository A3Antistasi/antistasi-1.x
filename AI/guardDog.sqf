params ["_dog"];
private ["_group","_spottedUnit"];

_dog = _this select 0;
_group = group _dog;

_spottedUnit = objNull;

_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
_dog disableAI "FSM";
_dog setBehaviour "CARELESS";
_dog setRank "PRIVATE";

while {alive _dog} do {
	if ((_dog == leader _group) AND (!captive _dog)) then {_dog setCaptive true};
	if (isNull _spottedUnit) then {
		sleep 5;
		_dog moveTo getPosATL leader _group;

		{
			_spottedUnit = _x;
			if (captive _spottedUnit) then {
				[_spottedUnit,false] remoteExec ["setCaptive",_spottedUnit];
			};
		} forEach ([50,0,position _dog,"BLUFORSpawn"] call distanceUnits);

		if ((random 10 < 1) AND (isNull _spottedUnit)) then {
			playSound3D [missionPath + (ladridos call BIS_fnc_selectRandom),_dog, false, getPosASL _dog, 1, 1, 100];
		};
		if (_dog distance (leader _group) > 30) then {_dog setPos position (leader _group)};
	} else {
		_dog doWatch _spottedUnit;
		(leader _group) reveal [_spottedUnit,4];
		playSound3D [missionPath + (ladridos select (floor random 5)),_dog, false, getPosASL _dog, 1, 1, 100];
		_dog moveTo getPosATL _spottedUnit;
		if (_spottedUnit distance _dog > 100) then {_spottedUnit = objNull};
		sleep 3;
	};
};