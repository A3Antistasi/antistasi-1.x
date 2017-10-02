if !(hasInterface) exitWith {};

/*
 	Description:
		- Check player's score against promotion requirements, and notify all clients in case of promotion.
		- Update rank progress display.
		- Synchronise rank across all clients.
		- Checks are done every 60s.

	Parameters:
		Player

 	Returns:
		Nothing

 	Example:
		0 = [player] spawn rankCheck;
*/

params ["_player"];
private ["_score", "_rankData", "_multiplier", "_nextRank", "_currentRank", "_promoted", "_text"];

while {true} do {
	_score = _player getVariable ["score",0];
	_rankData = [_player] call AS_fnc_getRank;
	_multiplier = _rankData select 0;
	_nextRank = _rankData select 1;
	_currentRank = _player getVariable ["rango","PRIVATE"];
	_promoted = false;

	if (_currentRank == "COLONEL") exitWith {};

	if (_score >= 50*_multiplier) then {
		_promoted = true;
		[_player,_nextRank] remoteExec ["ranksMP"];
		_player setVariable ["rango",_nextRank,true];
		_text = format ["%3%1: %2.\n",name _player,_nextRank];
		[-1*(50*_multiplier),_player] call playerScoreAdd;
		_multiplier = _multiplier + 1;
	};

	if (_promoted) then {
		_text = format ["%1\n\nCONGATULATIONS!",_text];
		[petros,"hint",_text] remoteExec ["commsMP"];
	};
	[_player,_currentRank] remoteExec ["ranksMP"];
	0 = ["Rank"] call AS_fnc_updateProgressBar;

	sleep 60;
};