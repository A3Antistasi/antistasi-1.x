if (player == leader group player) exitWith {hint "You cannot leave a group while you are the leader"};
if ({!isPlayer _x} count units group player > 0) exitWith {hint "You cannot leave your group while there's AI soldiers in it"};
removeAllActions player;
_grupo = createGroup side_blue;
[player] join _grupo;
hint "You left your group";
player addAction ["Join this Player Group", {[] execVM "REINF\joinplayer.sqf";},nil,0,false,true];