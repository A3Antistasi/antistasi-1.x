params ["_player","_rank"];

_player = _player getVariable ["owner",_player];
_player setRank _rank;