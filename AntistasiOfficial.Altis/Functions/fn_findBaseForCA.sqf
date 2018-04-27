params ["_marker", ["_force", false]];
private ["_position","_basesAAF","_bases","_base","_posBase","_busy","_radio"];

if (typeName _marker == "STRING") then {_position = getMarkerPos _marker} else {_position = _marker};

_basesAAF = bases - mrkFIA;
_bases = [];
_base = "";
{
	_base = _x;
	_posBase = getMarkerPos _base;
	_busy = [true, false] select (dateToNumber date >= server getVariable _base);
	_radio = [[_base] call AS_fnc_radioCheck, true] select (_force);

	if ((!_busy) and !(spawner getVariable _base)) then {
		if (((_position distance _posBase < 5000) and (_radio)) or (_position distance _posBase < 2000)) then {
			if (worldName == "Tanoa") then {
				if ([_posBase, _position] call AS_fnc_IslandCheck) then {_bases pushBack _base};
			} else {
				_bases pushBack _base;
			};
		};
	};
} forEach _basesAAF;

if (count _bases > 0) then {[_bases,_position] call BIS_fnc_nearestPosition} else {""}