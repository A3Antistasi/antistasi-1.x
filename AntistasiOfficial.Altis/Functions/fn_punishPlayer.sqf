params ["_unit", "_timeout"];

//check if punishment is enabled
private _choiceTK = "AS_param_TkPenalty" call BIS_fnc_getParamValue;
if (_choiceTK == 0) exitWith{};


if (isDedicated) exitWith {};
if !(isMultiplayer) exitWith {};
if !(player == _unit) exitWith {};

private _punish = _unit getVariable ["punish",0];
_punish = _punish + _timeout;

disableUserInput true;
player removeMagazines (primaryWeapon player);
removeAllItemsWithMagazines player;
player removeMagazines (secondaryWeapon player);
player removeWeaponGlobal (primaryWeapon player);
player removeWeaponGlobal (secondaryWeapon player);
player setPosASL [0,0,0];

hint "You have been punished for inappropriate behaviour.";
sleep 5;
hint format ["After %1 seconds, you'll be returned to base.", _punish];
sleep 5;
hint "If you are bored, go plant some trees.";
sleep 5;

private _timer = _punish;
while {_timer > 0} do {
	hint format ["Now watch the sights for the following %1 seconds.\n\nPlease be thankful this is a game, otherwise you'd be facing a firing squad by now.", _timer];
	sleep 1;
	_timer = _timer -1;
};
hint "Enough then.";
disableUserInput false;
player setpos getMarkerPos guer_respawn;
player setVariable ["punish",_punish,true];
