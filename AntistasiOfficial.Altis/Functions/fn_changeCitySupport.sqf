params ["_deltaOp", "_deltaBlu", "_location"];
private ["_city","_data","_numCiv","_numVeh","_prestigeOPFOR","_prestigeBLUFOR"];

waitUntil {!cityIsSupportChanging};
cityIsSupportChanging = true;

_city = [[ciudades, _location] call BIS_fnc_nearestPosition, _location] select (typeName _location == typeName "");

_data = server getVariable _city;
if !(_data isEqualType []) exitWith {diag_log format ["Error in changeCitySupport. Passed %1 as reference.", _location]};
_numCiv = _data select 0;
_numVeh = _data select 1;
_prestigeOPFOR = _data select 2;
_prestigeBLUFOR = _data select 3;

if (_prestigeOPFOR + _prestigeBLUFOR > 100) then {
	_prestigeOPFOR = round (_prestigeOPFOR / 2);
	_prestigeBLUFOR = round (_prestigeBLUFOR / 2);
};

if ((_deltaBlu > 0) && ((_prestigeBLUFOR > 90) || (_prestigeBLUFOR + _prestigeOPFOR > 90))) then {
	_deltaBlu = 0;
	_deltaOp = _deltaOp - 5;
} else {
	if ((_deltaOp > 0) && ((_prestigeOPFOR > 90) || (_prestigeBLUFOR + _prestigeOPFOR > 90))) then {
		_deltaOp = 0;
		_deltaBlu = _deltaBlu - 5;
	};
};

if (_prestigeOPFOR + _prestigeBLUFOR + _deltaOp > 100) then {
	_deltaOp = 100 - (_prestigeOPFOR + _prestigeBLUFOR);
};
_prestigeOPFOR = _prestigeOPFOR + _deltaOp;

if (_prestigeOPFOR + _prestigeBLUFOR + _deltaBlu > 100) then {
	_deltaBlu = 100 - (_prestigeOPFOR + _prestigeBLUFOR);
};
_prestigeBLUFOR = _prestigeBLUFOR + _deltaBlu;

_prestigeOPFOR = _prestigeOPFOR min 99;
_prestigeOPFOR = _prestigeOPFOR max 1;
_prestigeBLUFOR = _prestigeBLUFOR min 99;
_prestigeBLUFOR = _prestigeBLUFOR max 1;

if (_prestigeBLUFOR + _prestigeOPFOR < 5) then {_prestigeOPFOR = 1; _prestigeBLUFOR = 5};

_data = [_numCiv, _numVeh,_prestigeOPFOR,_prestigeBLUFOR];

server setVariable [_city,_data,true];
cityIsSupportChanging = false;