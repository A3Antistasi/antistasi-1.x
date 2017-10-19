_unit = _this select 0;
_jugador = _this select 1;

[[_unit,"remove"],"AS_fnc_addActionMP"] call BIS_fnc_MP;

if (!alive _unit) exitWith {};

_jugador globalChat format [localize "STR_DIALOG_SURRENDER_REQ", worldName];

_chance = (server getVariable "prestigeNATO") - (server getVariable "prestigeCSAT");

_chance = _chance + 20;

if (_chance < 20) then {_chance = 20};

sleep 5;
_rnd = round random 100;
diag_log format ["value: %1; threshold: %2", _rnd, _chance];

if (_rnd < _chance) then
	{
	_unit enableSimulationGlobal true;
	_unit globalChat (localize "STR_DIALOG_SURRENDER_ACC");
	_unit enableAI "ANIM";
	_unit enableAI "MOVE";
	_unit stop false;
	_unit switchMove "";
	_unit doMove getMarkerPos guer_respawn;
	if (_unit getVariable ["OPFORSpawn",false]) then {_unit setVariable ["OPFORSpawn",nil,true]};
	sleep 100;
	if (alive _unit) then
		{
		[1,0] remoteExec ["prestige",2];
		[-1,1,position _unit] remoteExec ["AS_fnc_changeCitySupport",2];
		[1,0] remoteExec ["resourcesFIA",2];
		};
	}
else
	{
	_unit globalChat (localize "STR_DIALOG_SURRENDER_REF");
	};