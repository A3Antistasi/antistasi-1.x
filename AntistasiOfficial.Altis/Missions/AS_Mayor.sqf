// This is a copy of ASS_traidor.sqf repurposed for capturing a HVT.

if (!isServer and hasInterface) exitWith {};

private ["_houses","_mayor"];

_tskTitle = "STR_TSK_TD_ASSMAYOR";
_tskDesc = "STR_TSK_TD_DESC_ASSMAYOR";

_initialMarker = _this select 0;
_source = _this select 1;

_initialPosition = getMarkerPos _initialMarker;

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_tam = [_initialMarker] call sizeMarker;

_houses = nearestObjects [_initialPosition, ["Land_i_House_Big_02_V3_F","Land_i_House_Big_02_V2_F","Land_i_House_Big_01_V3_F","Land_i_House_Big_01_V1_F","Land_i_House_Big_01_V2_F","Land_Shop_Town_03_F","Land_House_Big_04_F","Land_House_Small_04_F","Land_House_Big_03_F","Land_Hotel_02_F","Land_Hotel_01_F"], _tam];
if (_houses isEqualTo []) then {_houses = nearestObjects [_initialPosition, ["house"], _tam];};
_housePositions = [];
_house = _houses select 0;
while {count _housePositions < 3} do{
    _house = _houses call BIS_Fnc_selectRandom;
    _housePositions = [_house] call BIS_fnc_buildingPositions;
    if (count _housePositions < 3) then {_houses = _houses - [_house]};
};

_max = (count _housePositions) - 1;
_rnd = floor random _max;
_traitorPosition = _housePositions select _rnd;
_posSol1 = _housePositions select (_rnd + 1);
_posSol2 = (_house buildingExit 0);

_nombredest = [_initialMarker] call AS_fnc_localizar;

_mayorGuards = createGroup side_red;
_mayorGroup = createGroup civilian;

_arraybases = bases - mrkFIA;
_base = [_arraybases, _initialPosition] call BIS_Fnc_nearestPosition;
_posBase = getMarkerPos _base;

_mayor = ([_traitorPosition, 0, "C_man_1", _mayorGroup] call bis_fnc_spawnvehicle) select 0;
 [_mayor, {_this setIdentity "Dusty"} ] remoteExec ["call"];
 sleep 0.1;
_mayor addGoggles "G_Tactical_Black";
_mayor addHeadgear "H_Hat_checker";
removeUniform _mayor;
_mayor addUniform "U_NikosAgedBody";
[_mayor] spawn {
	params ["_subject"];
	_subject allowDamage false;
	sleep 15;
	_subject allowDamage true;
};

[[_mayor,"Capture_HVT"],"AS_fnc_addActionMP"] call BIS_fnc_MP;

_sol1 = ([_posSol1, 0, opI_SL, _mayorGuards] call bis_fnc_spawnvehicle) select 0;
_sol2 = ([_posSol2, 0, sol_OFF, _mayorGuards] call bis_fnc_spawnvehicle) select 0;
_mayorGroup selectLeader _mayor;

_spawnData = [_initialPosition, [ciudades, _initialPosition] call BIS_fnc_nearestPosition] call AS_fnc_findRoadspot;
if (count _spawnData < 1) exitWith {diag_log format ["Error in traitor: no suitable roads found near %1",_initialMarker]};
_roadPos = _spawnData select 0;
_roadDir = _spawnData select 1;

if (_source == "civ") then {
	_val = server getVariable "civActive";
	server setVariable ["civActive", _val + 1, true];
};

_tsk = ["ASS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_initialMarker],_mayor,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

{[_x] spawn CSATinit; _x allowFleeing 0} forEach units _mayorGroup;

_posVeh = [_roadPos, 3, _roadDir + 90] call BIS_Fnc_relPos;

_vehtype = selectRandom CIV_vehicles;
_veh = _vehtype createVehicle _posVeh;
_veh allowDamage false;
_veh setDir _roadDir;
sleep 15;
_veh allowDamage true;
[_veh] spawn genVEHinit;
{_x disableAI "MOVE"; _x setUnitPos "UP"} forEach units _mayorGroup;

_mrk = createMarkerLocal [format ["%1patrolarea", floor random 100], getPos _house];
_mrk setMarkerShapeLocal "RECTANGLE";
_mrk setMarkerSizeLocal [50,50];
_mrk setMarkerTypeLocal "hd_warning";
_mrk setMarkerColorLocal "ColorRed";
_mrk setMarkerBrushLocal "DiagGrid";
_mrk setMarkerAlphaLocal 0;

_tipoGrupo = [infSquad, side_green] call AS_fnc_pickGroup;
_grupo = [_initialPosition, side_green, _tipogrupo] call BIS_Fnc_spawnGroup;
sleep 1;
if (random 10 < 2.5) then
	{
	_doggo = _grupo createUnit ["Fin_random_F",_initialPosition,[],0,"FORM"];
	[_doggo] spawn guardDog;
	};
[_grupo, _mrk, "SAFE","SPAWNED", "NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
{[_x] spawn genInitBASES} forEach units _grupo;

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _mayor) or ({_mayor knowsAbout _x > 1.4} count ([500,0,_mayor,"BLUFORSpawn"] call distanceUnits) > 0)};

if ({_mayor knowsAbout _x > 1.4} count ([500,0,_mayor,"BLUFORSpawn"] call distanceUnits) > 0) then
	{
	hint "The Mayor has been spooked, he will try to run for an enemy base for safety!";
	_tsk = ["ASS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_initialMarker],_mayor,"CREATED",5,true,true,"Kill"] call BIS_fnc_setTask;
	{_x enableAI "MOVE"} forEach units _mayorGroup;
	_mayor assignAsDriver _veh;
	[_mayor] orderGetin true;
	_wp0 = _mayorGroup addWaypoint [_posVeh, 0];
	_wp0 setWaypointType "GETIN";
	_wp1 = _mayorGroup addWaypoint [_posBase,1];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointBehaviour "CARELESS";
	_wp1 setWaypointSpeed "FULL";
	};

waitUntil  {sleep 1; (dateToNumber date > _fechalimnum) or (not alive _mayor) or (_mayor distance _posBase < 50) or (_mayor distance getMarkerPos guer_respawn < 50)};

if (not alive _mayor) then
	{
	_tsk = ["ASS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_initialMarker],_mayor,"FAILED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[0,0] remoteExec ["prestige",2];
	[10,-20,_initialPosition] remoteExec ["AS_fnc_changeCitySupport",2];
	{
	if (!isPlayer _x) then
		{
		_skill = skill _x;
		_skill = _skill + -0.1;
		_x setSkill _skill;
		}
	else
		{
		[-10,_x] call playerScoreAdd;
		};
	} forEach ([_tam,0,_initialPosition,"BLUFORSpawn"] call distanceUnits);
	[-5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
	};

if (_mayor distance getMarkerPos guer_respawn < 50) then
	{
	_tsk = ["ASS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_initialMarker],_mayor,"SUCCEEDED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[0,0] remoteExec ["prestige",2];
	[0,300] remoteExec ["resourcesFIA",2];
	[-10,20,_initialPosition] remoteExec ["AS_fnc_changeCitySupport",2];
	{
	if (!isPlayer _x) then
		{
		_skill = skill _x;
		_skill = _skill + 0.1;
		_x setSkill _skill;
		}
	else
		{
		[10,_x] call playerScoreAdd;
		};
	} forEach ([_tam,0,_initialPosition,"BLUFORSpawn"] call distanceUnits);
	[5,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module

	sleep 5;
	deleteVehicle _mayor;
	}

else
	{
	_tsk = ["ASS",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_initialMarker],_mayor,"FAILED",5,true,true,"Kill"] call BIS_fnc_setTask;
	[-2,Slowhand] call playerScoreAdd;
	[10,0,_initialPosition] remoteExec ["AS_fnc_changeCitySupport",2];
	};

[5400,_tsk] spawn borrarTask;

if (_source == "civ") then {
	_val = server getVariable "civActive";
	server setVariable ["civActive", _val - 1, true];
};

waitUntil {sleep 1; !([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits)};

{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x
} forEach units _mayorGroup;
deleteGroup _mayorGroup;

{
waitUntil {sleep 1; !([distanciaSPWN,1,_x,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _x
} forEach units _grupo;
deleteGroup _grupo;

waitUntil {sleep 1; !([distanciaSPWN,1,_veh,"BLUFORSpawn"] call distanceUnits)};
deleteVehicle _veh;
