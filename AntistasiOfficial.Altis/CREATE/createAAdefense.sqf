if (!isServer and hasInterface) exitWith {};

params ["_marker"];
private ["_posMarker","_size","_cmpInfo","_posCmp","_cmp","_objs","_allGroups","_allSoldiers","_allVehicles","_statics","_SPAA","_hasSPAA","_truck","_crate","_unit","_groupCrew","_groupGunners","_markerPatrol","_UAV","_groupUAV","_groupType","_groupPatrol","_garrisonSize","_mrk"];

_posMarker = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;

_allGroups = [];
_allSoldiers = [];
_allVehicles = [];


_spawnSPAA = false;
_isHilltop = false;
if(_marker in colinasAA) then {_isHilltop = true;};
if(_isHilltop AND spawner getVariable _marker != 0) then {_spawnSPAA = true;};

_groupType = [infAAdef, side_green] call AS_fnc_pickGroup;
_groupAA = [_posMarker, side_green, _groupType] call BIS_Fnc_spawnGroup;
{ //Stef, Dick Cheany said that they take time before using the rocket, they aim with rifle first, so maybe we remove weapons and leave them the launcher only.
	removeAllWeapons _x
	_x addMagazineGlobal AArocket; //STILL WiP.. not evens ure if this is the good way
	_x addweaponglobal AA;
	} foreach (units _groupAA);
sleep 0.1;
[_groupAA, _marker, "COMBAT","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupAA;
_allGroups pushBack _groupAA;

_SPAA = nil;
if(_spawnSPAA) then
{
	_spawnPos = (getMarkerPos _marker) findEmptyPosition [0,25,opSPAA];
	if !(count _spawnPos == 0) then {
		_SPAA = createVehicle [opSPAA, _spawnPos, [], 0, "CAN_COLLIDE"];   //there is a variable error here, syntax it's correct i tested it.
		_groupCrew = createGroup side_red;
		_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
		_unit moveInGunner _SPAA;
		_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
		_unit moveInCommander _SPAA;
		_SPAA lock 2;
		_allGroups pushBack _groupCrew;
		{[_x] spawn CSATinit; _allSoldiers pushBack _x} forEach units _groupCrew;
	} else {
		_groupCrew = [_posMarker, side_green, _groupType] call BIS_Fnc_spawnGroup;
		sleep 0.1;
		[_groupCrew, _marker, "COMBAT","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
		{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupCrew;
		_allGroups pushBack _groupCrew;
	};
};

_garrisonSize = count _allSoldiers;

while{spawner getVariable _marker != 4} do
{
	if(_isHilltop) then
	{
		if(_spawnSPAA) then
		{
			waitUntil{sleep 1; ((spawner getVariable _marker == 4) OR (spawner getVariable _marker == 0))};
			if(spawner getVariable _marker == 0) then
			{
				_spawnSPAA = false;
				if(isNil _SPAA) then
				{
					{_allSoldiers = _allSoldiers - [_x]; deleteVehicle _x;} forEach units _groupCrew;
					_groupCrew = nil;
					_allGroups = _allGroups - [_groupCrew];
					deleteVehicle _SPAA;
					_SPAA = nil;
				}
				else
				{
					{_allSoldiers = _allSoldiers - [_x]; deleteVehicle _x;} forEach units _groupCrew;
					_groupCrew = nil;
					_allGroups = _allGroups - [_groupCrew];
				};
			};
		}
		else
		{
			waitUntil{sleep 1; ((spawner getVariable _marker == 4) OR (spawner getVariable _marker != 0))};
			if(spawner getVariable _marker != 0) then
			{
				_spawnSPAA = true; /*Spawn tigris */
				_spawnPos = (getMarkerPos _marker) findEmptyPosition [0,75,opSPAA];
				sleep 0.5;
				systemchat format ["AA pos %1",_spawnPos];
				if (isnil _spawnPos) then {
					_SPAA = createVehicle [opSPAA, _spawnPos, [], 0, "CAN_COLLIDE"];
					_groupCrew = createGroup side_red;
					_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
					_unit moveInGunner _SPAA;
					_unit = ([_posMarker, 0, opI_CREW, _groupCrew] call bis_fnc_spawnvehicle) select 0;
					_unit moveInCommander _SPAA;
					_SPAA lock 2;
					_allGroups pushBack _groupCrew;
					{[_x] spawn CSATinit; _allSoldiers pushBack _x} forEach units _groupCrew;
				} else {
					_groupCrew = [_posMarker, side_green, _groupType] call BIS_Fnc_spawnGroup;
					sleep 0.1;
					[_groupCrew, _marker, "COMBAT","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
					{[_x] spawn genInitBASES; _allSoldiers pushBack _x} forEach units _groupCrew;
					_allGroups pushBack _groupCrew;
				};
			};
		}
	};
	sleep 1;
};

[_allGroups, _allSoldiers, _allVehicles] spawn AS_fnc_despawnUnits;