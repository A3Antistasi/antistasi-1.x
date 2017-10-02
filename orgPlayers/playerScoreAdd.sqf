params ["_points","_player",["_isSilent",false]];
private ["_currentPoints","_currentMoney","_text"];

if (!isPlayer _player) exitWith {};

_player = _player getVariable ["owner",_player];
if (isMultiplayer) exitWith {
	_currentPoints = _player getVariable ["score",0];
	_currentMoney = _player getVariable ["dinero",0];
	if (_points > 0) then {
		_currentMoney = _currentMoney + (_points * 10);
		_player setVariable ["dinero",_currentMoney,true];
		_text = format ["<br/><br/><br/><br/><br/><br/>Money +%1 €",_points*10];
		if !(_isSilent) then {
			[petros,"income",_text] remoteExec ["commsMP",_player];
		};
	};
	_points = _points + _currentPoints;
	_player setVariable ["score",_points,true];
};

if (_points > 0) then {
	[0,(_points * 5)] remoteExec ["resourcesFIA",2];
};