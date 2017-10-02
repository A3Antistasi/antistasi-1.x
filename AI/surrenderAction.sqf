private ["_unit","_coste","_armas","_municion","_caja","_items"];

_unit = _this select 0;

if (typeOf _unit == "Fin_random_F") exitWith {};

_unit setVariable ["surrendered",true];
if ((side _unit == side_green) or (side _unit == side_red)) then
	{
	[[_unit,"interrogar"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
	[[_unit,"capturar"],"AS_fnc_addActionMP"] call BIS_fnc_MP;
	[0,10] remoteExec ["resourcesFIA",2];
	[-2,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
	_coste = server getVariable (typeOf _unit);
	if (isNil "_coste") then {diag_log format ["Falta incluir a %1 en las tablas de coste",typeOf _unit]} else {[-_coste] remoteExec ["resourcesAAF",2]};
	}
else
	{
	[-2,2,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
	[1,0] remoteExec ["prestige",2];
	};
_armas = [];
_municion = [];
_items = [];
_unit allowDamage false;
[_unit] orderGetin false;
_unit stop true;
_unit disableAI "MOVE";
_unit disableAI "AUTOTARGET";
_unit disableAI "TARGET";
_unit disableAI "ANIM";
//_unit disableAI "FSM";
_unit setSkill 0;
_unit setUnitPos "UP";
_caja = "Box_IND_Wps_F" createVehicle position _unit;
clearMagazineCargoGlobal _caja;
clearWeaponCargoGlobal _caja;
clearItemCargoGlobal _caja;
clearBackpackCargoGlobal _caja;
_armas = weapons _unit;
{_caja addWeaponCargoGlobal [[_x] call BIS_fnc_baseWeapon,1]} forEach _armas;
_municion = magazines _unit;
{_caja addMagazineCargoGlobal [_x,1]} forEach _municion;
_items = assignedItems _unit + items _unit + primaryWeaponItems _unit;
{_caja addItemCargoGlobal [_x,1]} forEach _items;
removeAllWeapons _unit;
removeAllAssignedItems _unit;
_unit setCaptive true;
sleep 1;
if (alive _unit) then
	{
	_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
	};
_unit setSpeaker "NoVoice";
_unit addEventHandler ["HandleDamage",
	{
	_unit = _this select 0;
	_unit enableAI "ANIM";
	if (!simulationEnabled _unit) then {_unit enableSimulationGlobal true};
	}
	];
if (_unit getVariable ["OPFORSpawn",false]) then {_unit setVariable ["OPFORSpawn",nil,true]};
[_unit] spawn postmortem;
[_caja] spawn postmortem;
sleep 10;
_unit allowDamage true;
_unit enableSimulationGlobal false;