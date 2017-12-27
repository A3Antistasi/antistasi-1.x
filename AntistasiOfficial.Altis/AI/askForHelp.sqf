params ["_unit"];
private ["_distance","_medAvail","_medic","_units","_medHelping"];

_distance = 81;
_medAvail = false;
_medic = objNull;

_medItem = "FirstAidKit";
if (activeACEMedical) then {_medItem = "ACE_fieldDressing"};
//if (count _this == 1) then {_units = units group _unit} else {_units = units (_this select 1)};
_units = units group _unit;
{
    if (!isPlayer _x) then
	{
	if (typeOf _x == guer_sol_MED) then
		{
		if ((alive _x) and (_medItem in (items _x)) and !([_x] call AS_fnc_isUnconscious) and (vehicle _x == _x) and (_x distance _unit < 81)) then
			{
			_medAvail = true;
			_medHelping = _x getVariable "ASmedHelping";
			if ((isNil "_medHelping") and (!(_x getVariable "ASrearming"))) then
				{
				_medic = _x;
				_distance = _x distance _unit;
				};
			};
		};
	};
} forEach _units;

if ((!_medAvail) or ([_unit] call AS_fnc_isUnconscious)) then
	{
	{
	if (!isPlayer _x) then
		{
		if (typeOf _x != guer_sol_MED) then
			{
			if ((alive _x) and (_medItem in (items _x)) and !([_x] call AS_fnc_isUnconscious) and (vehicle _x == _x) and (_x distance _unit < _distance)) then
				{
				_medHelping = _x getVariable "ASmedHelping";
				if ((isNil "_medHelping") and (!(_x getVariable "ASrearming"))) then
					{
					_medic = _x;
					_distance = _x distance _unit;
					};
				};

			};
		};
	} forEach _units;
	};

if (!isNull _medic) then
	{
	[_unit,_medic] spawn medHeal;
	};

_medic