private ["_player"];

_player = player getVariable ["owner",player];

if (_player getVariable ["elegible",true]) then {
	_player setVariable ["elegible",false,true];
	if (_player == Slowhand) then {
		hint localize "STR_HINTS_COMMANDER_RES";
		sleep 3;
		[] remoteExec ["assignStavros",2];
	} else {
		hint localize "STR_HINTS_COMMANDER_DEN";
	};
} else {
	hint localize "STR_HINTS_COMMANDER_ACC";
	_player setVariable ["elegible",true,true];
	if !(isplayer slowhand) then {[] remoteExec ["assignStavros",2];} //Stef 25/09 if commaander none it checks for commander again
};