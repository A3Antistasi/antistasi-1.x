if (!isServer and hasInterface) exitWith {};

/*
 	Description:
		- Provide enemy artillery support at the chosen location for the given duration.
		- Artillery will spawn at the nearest valid artillery emplacement marker.

	Parameters:
		_targetMarker: marker of the zone to be covered by artillery
		_duration: duration of the artillery support in minutes

 	Returns:
		Nothing

 	Example:
		["Panochori", 10] remoteExec ["AS_fnc_enemyArtillerySupport", 2]
*/

params ["_targetMarker", "_duration"];
private ["_artyPos","_positionTarget","_sizeTarget","_groupGunners", "_groupArtillery", "_allGroups", "_vehicles", "_posArty", "_mapperData", "_mapperStr", "_composition", "_howitzer", "_truck", "_statics", "_spawnPoints", "_soldiers", "_unit", "_groupType", "_group", "_maxGarrison", "_mrk", "_endTime", "_endTimeNumber", "_sizeArty"];

if (server getVariable ["artillerySupport", false]) exitWith {diag_log "Artillery already active"};
server setVariable ["artillerySupport", true, true];

_positionTarget = getMarkerPos _targetMarker;
_artyAvailable = false;
_artyPositions =+ artyEmplacements;

_endTime = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _duration];
_endTimeNumber = dateToNumber _endTime;

while {count _artyPositions > 0} do {
	_artyPos = [artyEmplacements, _positionTarget] call BIS_fnc_nearestPosition;
	if ((([ciudades, _artyPos] call BIS_fnc_nearestPosition) in mrkAAF) AND !(_artyPos in AS_destroyedZones)) exitWith {_artyAvailable = true};
	_artyPositions = _artyPositions - [_artyPos];
};

if !(_artyAvailable) exitWith {diag_log "No artillery available"};

forcedSpawn pushBack _artyPos;

_groupGunners = createGroup side_red;
_statics = [];
_spawnPoints = [];
_soldiers = [];
_allGroups = [];
_vehicles = [];
_howitzer = objNull;

_posArty = getMarkerPos _artyPos;
_sizeTarget = [_targetMarker] call sizeMarker;
_sizeArty = [_artyPos] call sizeMarker;
_mapperData = missionNamespace getVariable [format ["AS_%1", _artyPos], ""];

if (typeName _mapperData == "STRING") exitWith {diag_log format ["createArtillery -- no composition found: %1", _artyPos]};

_mapperPos = _mapperData select 0;
_mapperStr = _mapperData select 1;
_composition = [_mapperPos, 0, _mapperStr] call BIS_fnc_ObjectsMapper;

{
	call {
		if (typeOf _x == opArtillery) exitWith {_howitzer = _x; [_x] spawn AS_fnc_protectVehicle};
		if (typeOf _x == vehAmmo) exitWith {_truck = _x; [_x] spawn AS_fnc_protectVehicle; _vehicles pushBack _truck; [_truck] call cajaAAF};
		if (_x isKindOf "StaticWeapon") exitWith {_statics pushBackUnique _x};
		if (typeOf _x == "CamoNet_OPFOR_open_F") exitWith {_spawnPoints pushBackUnique (position _x)};
		if (typeOf _x == "CamoNet_OPFOR_big_F") exitWith {[_x] spawn AS_fnc_protectCamoNet};
	};
} forEach _composition;

_composition = _composition - [_truck];

sleep 2;

if !(isNull _howitzer) then {
	_groupArtillery = createGroup side_red;
	_unit = _groupArtillery createUnit [opI_CREW, _posArty, [], 0, "NONE"];
	_unit assignAsGunner _howitzer;
	_unit moveInGunner _howitzer;
	_unit = _groupArtillery createUnit [opI_CREW, _posArty, [], 0, "NONE"];
	_unit assignAsCommander _howitzer;
	_unit moveInCommander _howitzer;
	_howitzer lock 2;
};

_allGroups pushBackUnique _groupArtillery;

{
	_unit = _groupGunners createUnit [opI_AR, _posArty, [], 0, "NONE"];
	_unit removeWeaponGlobal (primaryWeapon _unit);
	_unit moveInGunner _x;
} forEach _statics;

_allGroups pushBackUnique _groupGunners;

{
	_mrk = createMarkerLocal [format ["specops%1", random 100],_x];
	_mrk setMarkerShapeLocal "RECTANGLE";
	_mrk setMarkerSizeLocal [50,50];
	_mrk setMarkerTypeLocal "hd_warning";
	_mrk setMarkerColorLocal "ColorRed";
	_mrk setMarkerBrushLocal "DiagGrid";
	_groupType = [opGroup_Security, side_red] call AS_fnc_pickGroup;
	_group = [_x, side_red, _groupType] call BIS_Fnc_spawnGroup;
	sleep 1;
	[leader _group, _mrk, "SAFE","SPAWNED","NOFOLLOW","NOMOVE","NOVEH"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBackUnique _group;
} forEach _spawnPoints;

for "_i" from 1 to 2 do {
	_groupType = [opGroup_Recon_Team, side_red] call AS_fnc_pickGroup;
	_group = [_posArty, side_red, _groupType] call BIS_Fnc_spawnGroup;
	sleep 1;
	[leader _group, _artyPos, "STEALTH","SPAWNED","NOFOLLOW","NOVEH"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBackUnique _group;
};

{
	_group = _x;
	{
		[_x] spawn CSATinit; _soldiers pushBackUnique _x
	} forEach (units _group);
} forEach _allGroups;

[_howitzer] spawn CSATVEHinit;
{
	[_x] spawn genVEHinit;
} forEach _statics;

diag_log (_positionTarget inRangeOfArtillery [[_howitzer], ((getArtilleryAmmo [_howitzer]) select 0)]);

[_howitzer, _positionTarget, _sizeTarget] spawn {
	params ["_vehicle", "_posTarget", "_size"];
	private ["_ammo", "_vehicle", "_objective", "_rounds", "_objectives", "_nrOfUnits", "_groupSize", "_timer"];

	_ammo = opArtilleryAmmoHE;

	if (_posTarget inRangeOfArtillery [[_vehicle], ((getArtilleryAmmo [_vehicle]) select 0)]) then {
		while {(alive _vehicle) AND ({_x select 0 == _ammo} count magazinesAmmo _vehicle > 0) AND (server getVariable ["artillerySupport", false])} do {
			_objective = objNull;
			_rounds = 1;
			_objectives = vehicles select {(side driver _x == side_blue) AND (_x distance _posTarget <= _size * 2) AND ((side_red knowsAbout _x >= 1.4) OR (side_green knowsAbout _x >= 1.4)) AND (speed _x < 1)};
			if (count _objectives > 0) then {
				{
					if ((_x isKindOf "Tank") OR (_x isKindOf "Car")) exitWith {_objective = _x; _rounds = 4};
				} forEach _objectives;
				if (isNull _objective) then {_objective = selectRandom _objectives};
			} else {
				_objectives = allUnits select {(side _x == side_blue) AND (_x distance _posTarget <= _size * 2) AND ((side_red knowsAbout _x >= 1.4) OR (side_green knowsAbout _x >= 1.4))};
				if (count _objectives > 0) then {
					_nrOfUnits = 0;
					{
						if (_x == leader group _x) then {
							_groupSize = {(alive _x) AND (!captive _x)} count units group _x;
							if (_groupSize > _nrOfUnits) then {
								_objective = _x;
								if (_groupSize > 6) then {_rounds = 2};
							};
						};
					} forEach _objectives;
				};
			};

			if !(isNull _objective) then {
				diag_log format ["target: %1", _objective];
				_vehicle commandArtilleryFire [position _objective, _ammo, _rounds];
				_timer = _vehicle getArtilleryETA [position _objective, ((getArtilleryAmmo [_vehicle]) select 0)];
				sleep 9 + ((_rounds - 1) * 3);
			} else {
				sleep 29;
			};
			sleep 3;
		};
	};
};

sleep 30;

waitUntil {sleep 1; (dateToNumber date > _endTimeNumber) OR (count (allUnits select {((side _x == side_green) OR (side _x == side_red)) AND (_x distance _posArty <= _sizeArty)}) < 1) OR !(server getVariable ["artillerySupport", false])};

if !(alive _howitzer) then {AS_destroyedZones pushBackUnique _artyPos};

[_allGroups, _soldiers, _vehicles] spawn AS_fnc_despawnUnits;

waitUntil {sleep 3; !([distanciaSPWN,1,_posArty,"BLUFORSpawn"] call distanceUnits)};
{deleteVehicle _x} forEach _composition;

server setVariable ["artillerySupport", false, true];