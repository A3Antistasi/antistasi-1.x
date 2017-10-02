private ["_maxPoints","_text","_multi","_disconnected","_players","_members","_potentials","_commander","_data","_proceed","_selectable"];

_maxPoints = 0;
_multi = 1;
_disconnected = false;
_players = [];
_members = [];
_potentials = [];
_commander = objNull;

[] remoteExec ["fnc_BE_pushVariables", 2];

{
	_players pushBack (_x getVariable ["owner",_x]);
	if (_x != _x getVariable ["owner",_x]) then {waitUntil {_x == _x getVariable ["owner",_x]}};
	if ([_x] call isMember) then {
		_members pushBack _x;
		if (_x getVariable ["elegible",true]) then {
			_potentials pushBack _x;
			if (_x == Slowhand) then {
				_commander = _x;
				_data = [_commander] call AS_fnc_getRank;
				_maxPoints = _data select 0;
			};
		};
	};
} forEach playableUnits;

if (isNull _commander) then {
	_maxPoints = 0;
	_disconnected = true;
};

_proceed = false;

if ((isNull _commander) OR switchCom) then {
	if (count _members > 0) then {
		_proceed = true;
		if (count _potentials == 0) then {_potentials = _members};
	};
};

if (!_proceed) exitWith {};

_selectable = objNull;
{
	_data = [_x] call AS_fnc_getRank;
	_multi = _data select 0;
	if ((_multi > _maxPoints) AND (_x !=_commander)) then {
		_selectable = _x;
		_maxPoints = _multi;
	};
} forEach _potentials;

if (!isNull _selectable) then {
	if (_disconnected) then {_text = format [localize "STR_HINTS_COMMANDER_DIS", name _selectable]} else {_text = format [localize "STR_HINTS_COMMANDER_REP", name Slowhand, name _selectable]};
	[_selectable] call stavrosInit;
	sleep 5;
	[[petros,"hint",_text],"commsMP"] call BIS_fnc_MP;
};
