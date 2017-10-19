if (!isServer and hasInterface) exitWith {};

_tskTitle = localize "Str_tsk_fndExp";
_tskDesc = localize "Str_tskDesc_fndExp";

_site = _this select 0;

private ["_mrk","_posCmp","_p1","_p2","_dirveh"];

_grupos = [];
_vehiculos = [];
_soldados = [];

_nombredest = [_site] call AS_fnc_localizar;
_posSite = getMarkerPos _site;

_roads = carreteras getVariable _site;
_break = false;
_maxRoads = count (_roads);

while {!(_break) && (count _roads > 0)} do {
	_roads = _roads call BIS_fnc_arrayShuffle;
	_p1 = "";
	_posCmp = "";
	_index = 1;

	for "_i" from 0 to (count _roads - 1) do {
		if (((_roads select _i) distance _posSite >150) && ((_roads select _i) distance _posSite <300)) exitWith {_p1 = (_roads select _i); _index = _i;};
	};

	if (typeName _p1 != "ARRAY") exitWith {diag_log "no road found"};
	_road = (_p1 nearRoads 5) select 0;
	if (!isNil "_road") then {
		_roadcon = roadsConnectedto (_road);
		if (count _roadcon > 0) then {
			_p2 = getPos (_roadcon select 0);
			_dirveh = [_p1,_p2] call BIS_fnc_DirTo;
			_posCmp = [_p1, 8, _dirveh + 90] call BIS_Fnc_relPos;
			if (count (nearestObjects [_posCmp, [], 6]) < 1) exitWith {
				_break = true;
			};
			_roads set [_index,-1];
			_roads = _roads - [-1];
		};
	};
};

if !(_break) exitWith {[[petros,"globalChat","Sorry, I wasn't paying attention. What was it you requested of me?"],"commsMP"] call BIS_fnc_MP;};

server setVariable ["expActive", true, true];

_tiempolim = 60;
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_fechalimnum = dateToNumber _fechalim;

_tsk = ["FND_E",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_site],_posCmp,"CREATED",5,true,true,"Find"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

_objs = [_posCmp, ([_posCmp,_p1] call BIS_fnc_DirTo), call (compile (preprocessFileLineNumbers "Compositions\cmpExp.sqf"))] call BIS_fnc_ObjectsMapper;
sleep 3;

// Devin, as known from JA2 -- bow down to the masters at Sir-Tech!
_groupDev = createGroup Civilian;
Devin = _groupDev createUnit [CIV_specialUnits select 0, [8173.79,25308.9,0.00156975], [], 0.9, "NONE"];
Devin allowDamage false;
sleep 2;
Devin setPos _posCmp;
Devin setDir ([_posCmp,_p1] call BIS_fnc_DirTo);
Devin removeWeaponGlobal (primaryWeapon Devin);
Devin setIdentity "Devin";
Devin disableAI "move";
Devin setunitpos "up";

{
	call {
		if (str typeof _x find "Land_PlasticCase_01_medium_F" > -1) exitWith {expCrate = _x; [expCrate] call emptyCrate;};
		if (str typeof _x find "Box_Syndicate_Wps_F" > -1) exitWith { [_x] call emptyCrate;};
		if (str typeof _x find "Box_IED_Exp_F" > -1) exitWith { [_x] call emptyCrate;};
	};
} forEach _objs;

// QRF, ground-based
_qrf = false;
if (random 8 < 1) then {
	_qrf = true;
	_basesAAF = bases - mrkFIA;
	_bases = [];
	_base = "";
	{
		_base = _x;
		_posbase = getMarkerPos _base;
		if ((_posCmp distance _posbase < 7500) and (_posCmp distance _posbase > 1500) and (not (spawner getVariable _base))) then {_bases = _bases + [_base]}
	} forEach _basesAAF;
	if (count _bases > 0) then {_base = [_bases,_posCmp] call BIS_fnc_nearestPosition;} else {_base = ""};

	_posbase = getMarkerPos _base;

	_tam = 100;

	while {true} do
		{
		_roads = _posbase nearRoads _tam;
		if (count _roads > 0) exitWith {};
		_tam = _tam + 50;
		};

	_road = _roads select 0;

	_vehicle= [position _road, 0,selectRandom vehTrucks, side_green] call bis_fnc_spawnvehicle;
	_veh = _vehicle select 0;
	[_veh] spawn genVEHinit;
	[_veh,"AAF Escort"] spawn inmuneConvoy;
	_vehCrew = _vehicle select 1;
	{[_x] spawn genInit} forEach _vehCrew;
	_grupoVeh = _vehicle select 2;
	_soldados = _soldados + _vehCrew;
	_grupos = _grupos + [_grupoVeh];
	_vehiculos = _vehiculos + [_veh];

	sleep 1;

	_tipoGrupo = [infSquad, side_green] call AS_fnc_pickGroup;
	_grupo = [_posbase, side_green, _tipogrupo] call BIS_Fnc_spawnGroup;

	{_x assignAsCargo _veh; _x moveInCargo _veh; _soldados = _soldados + [_x]; [_x] spawn genInit} forEach units _grupo;
	_grupos = _grupos + [_grupo];

	[_veh] spawn smokeCover;

	_Vwp0 = _grupoVeh addWaypoint [_posCmp, 0];
	_Vwp0 setWaypointType "TR UNLOAD";
	_Vwp0 setWaypointBehaviour "SAFE";
	_Gwp0 = _grupo addWaypoint [_posCmp, 0];
	_Gwp0 setWaypointType "GETOUT";
	_Vwp0 synchronizeWaypoint [_Gwp0];
};
// END QRF

waitUntil {sleep 1; (dateToNumber date > _fechalimnum) || !(alive Devin) || ({(side _x isEqualTo side_blue) && (_x distance Devin < 200)} count allPlayers > 0)};

{if (isPlayer _x) then {[petros,"hint","Don't ask Devin about the Holy Handgrenade of Antioch. Just don't."] remoteExec ["commsMP",_x]}} forEach ([200,0,Devin,"BLUFORSpawn"] call distanceUnits);

// QRF, air-based
//if (!(_qrf) && (random 8 < 1)) then {
if !(_qrf) then {
	["spawnCSAT", _posCmp, _site, 15, "transport", "small"] remoteExec ["enemyQRF",HCattack];
};
// END QRF
waitUntil {sleep 1; (dateToNumber date > _fechalimnum) || !(alive Devin) || ({((side _x isEqualTo side_blue) || (side _x isEqualTo civilian)) && (_x distance Devin < 10)} count allPlayers > 0)};

if ({((side _x isEqualTo side_blue) || (side _x isEqualTo civilian)) && (_x distance Devin < 10)} count allPlayers > 0) then {
	_tsk = ["FND_E",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_site],_posCmp,"SUCCEEDED",5,true,true,"Find"] call BIS_fnc_setTask;
	[[Devin,"buy_exp"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
	_mrkDev = createMarker ["Devin", _posCmp];
	_mrkDev setMarkerShape "ICON";
	_mrkDev setMarkerType "flag_Croatia";
	_mrk = createMarker ["DevPat", _posCmp];
	_mrk setMarkerSize [100,100];
    _mrk setMarkerShape "RECTANGLE";
    _mrk setMarkerBrush "SOLID";
    _mrk setMarkerColor "ColorUNKNOWN";
    _mrk setMarkerText "Devin";
    _mrk setMarkerAlpha 0;
    Devin allowDamage true;
	line1 = ["Devin", "Top of the day to ya. Haven't made yer acquaintance."];
    [[line1],"DIRECT",0.15] execVM "createConv.sqf";
}
else {
	_tsk = ["FND_E",[side_blue,civilian],[format [_tskDesc,_nombredest,numberToDate [2035,_fechalimnum] select 3,numberToDate [2035,_fechalimnum] select 4],_tskTitle,_site],_posCmp,"FAILED",5,true,true,"Find"] call BIS_fnc_setTask;
};

waitUntil {sleep 10; (dateToNumber date > _fechalimnum) || !(alive Devin)};

if (alive Devin) then {
	Devin enableAI "ANIM";
	Devin enableAI "MOVE";
	Devin stop false;
	Devin doMove getMarkerPos "resource_7";
}
else {
	[[Devin,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
};

server setVariable ["expActive", false, true];

[1200,_tsk] spawn borrarTask;
sleep 30;
deleteMarker "Devin";
deleteMarker "DevPat";
waitUntil {sleep 1; {_x distance Devin < distanciaSPWN/2} count (allPlayers - hcArray) == 0};
{deleteVehicle _x} forEach _vehiculos;
{deleteVehicle _x} forEach _soldados;
{deleteGroup _x} forEach _grupos;
deleteVehicle Devin;
deleteGroup _groupDev;
[_posCmp, "exp"] remoteExec ["despawnCamp"];
{
	if (str typeof _x find "Land_Campfire_" > -1) then {_x inflame false};
} forEach _objs;
sleep 2;
{deleteVehicle _x} forEach _objs;