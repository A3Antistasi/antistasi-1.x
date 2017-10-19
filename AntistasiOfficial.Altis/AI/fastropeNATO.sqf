private ["_veh","_grupo","_posicion","_posorigen","_heli","_landpos","_wp","_d","_wp2","_wp3"];

_veh = _this select 0;
_grupo = _this select 1;
_posicion = _this select 2;
_posorigen = _this select 3;
_heli = _this select 4;

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

waitUntil {sleep 1; (not alive _veh) or ((speed _veh < 1) and (speed _veh > -1))};

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
	_unit attachTo [_veh, [2,1,_d]];
	while {((getpos _unit select 2) > 1) and (alive _veh) and (alive _unit) and (speed _veh < 10) and (speed _veh > -10)} do
		{
		_unit attachTo [_veh, [2,1,_d]];
		_d = _d - 0.35;
		sleep 0.005;
		};
	detach _unit;
	_unit switchmove "";
	sleep 0.5;
	};
sleep 5 + random 2;
} forEach units _grupo;

waitUntil {sleep 1; (not alive _veh) or ((count assignedCargo _veh == 0) and (count attachedObjects _veh == 0))};


sleep 5;
_veh flyInHeight 150;
[_veh] call puertasLand;
//_veh animateDoor ['door_R', 0];
//_veh animateDoor ['door_L', 0];
_wp2 = _grupo addWaypoint [_posicion, 0];
_wp2 setWaypointType "SAD";
_wp3 = _heli addWaypoint [_posorigen, 1];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "NORMAL";
_wp3 setWaypointBehaviour "AWARE";
_wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this"];
{_x setBehaviour "AWARE";} forEach units _heli;