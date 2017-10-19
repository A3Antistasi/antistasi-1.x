private ["_veh","_grupo1","_grupo2","_posicion","_posorigen","_heli","_landpos","_wp","_d","_wp1","_wp2","_wp3"];

_veh = _this select 0;
_grupo1 = _this select 1;
_grupo2 = _this select 2;
_posicion = _this select 3;
_posorigen = _this select 4;
_heli = _this select 5;

_landpos = [];
{_x disableAI "TARGET"; _x disableAI "AUTOTARGET"} foreach units _heli;

while {true} do
	{
 	_landpos = [_posicion, 30, random 360] call BIS_Fnc_relPos;
 	if (!surfaceIsWater _landpos) exitWith {};
	};
_landpos set [2,0];
{_x setBehaviour "CARELESS";} forEach units _heli;
_wp = _heli addWaypoint [_landpos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "CARELESS";
//_wp setWaypointSpeed "LIMITED";



waitUntil {sleep 1; (not alive _veh) or (_veh distance _landpos < 550)};

_veh flyInHeight 15;

[_veh] call puertasLand;

//_veh animateDoor ['door_R', 1];

waitUntil {sleep 1; (not alive _veh) or ((speed _veh < 1) and (speed _veh > -1))};
/*
if (alive _veh) then
	{
	for "_i" from 0 to 8 do
		{
		_pos = position _veh getPos [10,_i*40];
		_humo = "SmokeShellPurple" createVehicle [_pos select 0, _pos select 1,getPos _veh select 2];
		};
	};
*/
[_veh] call smokeCoverAuto;

{
[_veh,_x] spawn
	{
	private ["_veh","_unit","_d"];
	_veh = _this select 0;
	_unit = _this select 1;
	waitUntil {((speed _veh < 1) and (speed _veh > -1))};
	_d = -1;
	unassignVehicle _unit;
	moveOut _unit;
	_unit switchmove "gunner_standup01";
	_unit attachTo [_veh, [0,-5,_d]];
	while {((getposATL _unit select 2) > 1) and (alive _veh) and (alive _unit) and (speed _veh < 10) and (speed _veh > -10)} do
		{
		_unit attachTo [_veh, [0,-5,_d]];
		_d = _d - 0.35;
		sleep 0.005;
		};
	detach _unit;
	_unit switchmove "";
	sleep 0.5;
	};
sleep 5 + random 2;
} forEach units _grupo1;

{
[_veh,_x] spawn
	{
	private ["_veh","_unit","_d"];
	_veh = _this select 0;
	_unit = _this select 1;
	waitUntil {((speed _veh < 1) and (speed _veh > -1))};
	_d = -1;
	unassignVehicle _unit;
	moveOut _unit;
	_unit switchmove "gunner_standup01";
	_unit attachTo [_veh, [0,-5,_d]];
	while {((getpos _unit select 2) > 1) and (alive _veh)} do
		{
		_unit attachTo [_veh, [0,-5,_d]];
		_d = _d - 0.35;
		sleep 0.005;
		if ((speed _veh > 10) or (speed _veh < 10) or (!alive _unit)) then
			{
			detach _unit;
			_unit switchmove "";
			};
		};
	detach _unit;
	_unit switchmove "";
	sleep 0.5;
	};
sleep 5 + random 2;
} forEach units _grupo2;

waitUntil {sleep 1; (not alive _veh) or ((count assignedCargo _veh == 0) and (count attachedObjects _veh == 0))};

[_veh] call puertasLand;

sleep 5;
_veh flyInHeight 150;
//_veh animateDoor ['door_R', 0];
_wp1 = _grupo1 addWaypoint [_posicion, 0];
_wp1 setWaypointType "SAD";
_wp2 = _grupo2 addWaypoint [_posicion, 0];
_wp2 setWaypointType "SAD";
_wp3 = _heli addWaypoint [_posorigen, 1];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "NORMAL";
_wp3 setWaypointBehaviour "AWARE";
// _wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
_wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew _heli + [_heli]"];
{_x setBehaviour "AWARE";} forEach units _heli;