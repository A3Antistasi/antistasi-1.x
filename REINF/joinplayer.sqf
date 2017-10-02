_objetivo = cursortarget;

if (!(_objetivo isKindOf "Man")) exitWith {hint "No unit selected"};
if (count units group player > 1) exitWith {hint "Your group must be empty in order to join another one"};
if (!isPlayer _objetivo) exitWith {hint "You must be targeting a player in order to join him"};
if ({!isPlayer _x} count units group _objetivo > 0) exitWith {hint "Target player has AI in it's group. Only pure player groups can be joined"};
if (count units group _objetivo > 9) exitWith {hint "Target group is full"};
if (_objetivo == Slowhand) exitWith {hint "You cannot join Slowhand group"};

removeAllActions player;
_viejogrupo = group player;
[player] join group _objetivo;
deleteGroup _viejogrupo;
player addAction ["Leave this Group", {[] execVM "REINF\leaveplayer.sqf";},nil,0,false,true];

