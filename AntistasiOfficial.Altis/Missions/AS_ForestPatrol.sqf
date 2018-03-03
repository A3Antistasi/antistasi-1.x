if (!isServer and hasInterface) exitWith {};

private ["_Forest","_posHQ","_mrkOutpost","_distance"];

_tskTitle = "STR_TSK_TD_ASFOREST";
_tskDesc = "STR_TSK_TD_DESC_ASFOREST";

_posHQ = getMarkerPos guer_respawn;

_mrkOutpost = _this select 0;
_source = _this select 1;

_Outpost = getMarkerPos _mrkOutpost;
_ClearPosOutpost = _Outpost findEmptyPosition [0, 200, "I_Truck_02_covered_F"];

_distance = 2000;
while {true} do {
	sleep 0.1;
	_Forest = selectBestPlaces [_Outpost, _distance, "forest", 10, 1] select 0 select 0;
	_distance = (_distance + 500);
	if (_Forest distance _posHQ > 600) exitwith {};
};

_mrkfin = createMarkerLocal [format ["forestpatrol%1", random 100],_Forest];
_mrkfin setMarkerShapeLocal "CIRCLE";
_mrkfin setMarkerSizeLocal [150,150];
_mrkfin setMarkerTypeLocal "hd_warning";
_mrkfin setMarkerColorLocal "ColorRed";
_mrkfin setMarkerBrushLocal "DiagGrid";

_tiempolim = 120;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;


/*
if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val + 1, true];
};
*/

_nombredest = [_mrkOutpost] call AS_fnc_localizar;

_tsk = ["AS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_mrkOutpost],_Forest,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_tipoGrupo = [infSquad, side_green] call AS_fnc_pickGroup;
_group1 = [_ClearPosOutpost, side_green, _tipoGrupo] call BIS_Fnc_spawnGroup;
sleep 1;
[_group1, _mrkfin, "SPAWNED", "NOVEH2", "NOFOLLOW", "AWARE"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInit; _x allowFleeing 0} forEach units _group1;
sleep 2;
_group1 setFormation "STAG COLUMN";

_group2 = createGroup side_red;
_group2 setFormation "STAG COLUMN";
_target1 = _group2 createUnit [opI_RFL1, _ClearPosOutpost, [], 0, "NONE"];
_target2 = _group2 createUnit [opI_AR, _ClearPosOutpost, [], 0, "NONE"];
_target3 = _group2 createUnit [opI_OFF, _ClearPosOutpost, [], 0, "NONE"];
_target4 = _group2 createUnit [opI_LAT, _ClearPosOutpost, [], 0, "NONE"];
{[_x] spawn CSATinit; _x allowFleeing 0} forEach units _group2;
[_target1,_target2,_target3,_target4] join _group1;



waitUntil  {sleep 5; ((!alive _target1) && (!alive _target2) && (!alive _target3) && (!alive _target4)) or (dateToNumber date > _fechalimnum)};

if (dateToNumber date > _fechalimnum) then
	{
	_tsk = ["AS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_mrkOutpost],_Forest,"FAILED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[-600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	[-10,Slowhand] call playerScoreAdd;
	}
else
	{
	_tsk = ["AS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_mrkOutpost],_Forest,"SUCCEEDED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[0,500] remoteExec ["resourcesFIA",2];
	[600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_Forest,"BLUFORSpawn"] call distanceUnits);
	[10,Slowhand] call playerScoreAdd;
	[3,0] remoteExec ["prestige",2];
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
	};

[1200,_tsk] spawn borrarTask;
/*
if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val - 1, true];
};
*/
{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x
} forEach units _group1;
deleteGroup _group1;
deletemarker _mrkfin;
