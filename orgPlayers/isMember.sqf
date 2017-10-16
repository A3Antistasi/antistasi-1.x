params ["_unit"];
private ["_check","_player"];

_check = false;
_player = _unit getVariable ["owner",_unit];
if ((count membersPool == 0) OR ((getPlayerUID _player) in membersPool) OR (!isMultiplayer)) then {_check = true};

_check