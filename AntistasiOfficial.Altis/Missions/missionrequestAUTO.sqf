if (!isServer) exitWith {};

if (leader group Petros != Petros) exitWith {};

_tipos = ["CON","LOG","RES","CONVOY","PR","ASS"];
_tipo = "";

if (!isPlayer Slowhand) then {_tipos = _tipos - ["ASS"]};

{
if (_x in misiones) then {_tipos = _tipos - [_x]};
} forEach _tipos;
if (count _tipos == 0) exitWith {};

while {true} do {
	_tipo = _tipos call BIS_fnc_selectRandom;
	_tipos = _tipos - [_tipo];
	if (!(_tipo in misiones) || (count _tipos == 0)) exitWith {};
};
if (count _tipos == 0) exitWith {};

[_tipo,true,false] call missionRequest;