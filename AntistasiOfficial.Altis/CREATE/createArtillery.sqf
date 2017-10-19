if (!isServer and hasInterface) exitWith {};
params ["_marker"];
private ["_groupGunners", "_groupArtillery", "_allGroups", "_position", "_size", "_mapperData", "_mapperStr", "_composition", "_howitzer", "_truck", "_statics", "_spawnPoints", "_soldiers", "_unit", "_groupType", "_group", "_maxGarrison", "_mrk", "_mainNet"];

_groupGunners = createGroup side_red;
_groupArtillery = createGroup side_red;
_statics = [];
_spawnPoints = [];
_soldiers = [];
_allGroups = [];
_howitzer = objNull;

_position = getMarkerPos (_marker);
_size = [_marker] call sizeMarker;
_mapperData = missionNamespace getVariable [format ["AS_%1", _marker], ""];

if (typeName _mapperData == "STRING") exitWith {diag_log format ["createArtillery -- no composition found: %1", _marker]};

_mapperPos = _mapperData select 0;
_mapperStr = _mapperData select 1;
_composition = [_mapperPos, 0, _mapperStr] call BIS_fnc_ObjectsMapper;

{
	call {
		if (typeOf _x == opArtillery) exitWith {_howitzer = _x};
		if (typeOf _x == vehAmmo) exitWith {[_x] spawn genVEHinit; _truck = [_x]; [_x] spawn AS_fnc_protectVehicle};
		if (_x isKindOf "StaticWeapon") exitWith {_statics pushBack _x};
		if (typeOf _x == "CamoNet_OPFOR_open_F") exitWith {_spawnPoints pushBackUnique (position _x)};
		if (typeOf _x == "CamoNet_OPFOR_big_F") exitWith {[_x] spawn AS_fnc_protectCamoNet; _mainNet = _x; testNet = _x};
	};
} forEach _composition;

_composition = _composition - _truck;

diag_log _statics;

if !(isNull _howitzer) then {
	_unit = _groupArtillery createUnit [opI_CREW, _position, [], 0, "NONE"];
	_unit moveInGunner _howitzer;
	_unit = _groupArtillery createUnit [opI_CREW, _position, [], 0, "NONE"];
	_unit moveInCommander _howitzer;
	_howitzer lock 2;
};

_allGroups pushBackUnique _groupArtillery;

{
	_unit = _groupGunners createUnit [opI_AR, _position, [], 0, "NONE"];
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
	[leader _group, _mrk, "SAFE","SPAWNED","NOFOLLOW","NOMOVE"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBackUnique _group;
} forEach _spawnPoints;

for "_i" from 1 to 2 do {
	_groupType = [opGroup_Recon_Team, side_red] call AS_fnc_pickGroup;
	_group = [_position, side_red, _groupType] call BIS_Fnc_spawnGroup;
	sleep 1;
	[leader _group, _marker, "STEALTH","SPAWNED","NOFOLLOW","NOVEH2"] execVM "scripts\UPSMON.sqf";
	_allGroups pushBackUnique _group;
};

{
	_group = _x;
	{
		[_x] spawn CSATinit; _soldiers pushBackUnique _x
	} forEach (units _group);
} forEach _allGroups;

_maxGarrison = count _soldiers;