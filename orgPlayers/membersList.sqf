private ["_text","_counter","_player"];

if (count miembros == 0) exitWith {hint localize "STR_HINTS_GEN_MEM_DIS"};

_text = "Ingame Members\n\n";
_counter = 0;
{
	_player = _x getVariable ["owner",objNull];
	if (!isNull _player) then {
		_uid = getPlayerUID _player;
		if (_uid in miembros) then {_text = format ["%1%2\n",_text,name _player]} else {_counter = _counter + 1};
	};
} forEach playableUnits;

_text = format ["%1\nNo members:\n%2",_text,_counter];

hint format ["%1",_text];