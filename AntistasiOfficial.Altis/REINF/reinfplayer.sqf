if (not([player] call isMember)) exitWith {hint "Only Server Members can recruit AI units"};
private ["_chequeo","_hr","_tipounidad","_coste","_resourcesFIA","_unit"];

if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};

if (recruitCooldown > time) exitWith {hint format ["You need to wait %1 seconds to be able to recruit units again",round (recruitCooldown - time)]};

if (player != player getVariable ["owner",player]) exitWith {hint "You cannot buy units while you are controlling AI"};

_chequeo = false;
{
	if (((side _x == side_red) or (side _x == side_green)) and (_x distance player < safeDistance_recruit) and (not(captive _x))) then {_chequeo = true};
} forEach allUnits;

if (_chequeo) exitWith {Hint "You cannot Recruit Units with enemies nearby"};

if (player != leader group player) exitWith {hint "You cannot recruit units as you are not your group leader"};

_tipounidad = _this select 0;
_available = true;

call {
	if ((_tipounidad == guer_sol_AR) && (server getVariable "genLMGlocked")) exitWith {_available = true;};  //Stef 31-08 set all true untill we find a way
	if ((_tipounidad == guer_sol_GL) && (server getVariable "genGLlocked")) exitWith {_available = true;};
	if ((_tipounidad == guer_sol_MRK) && (server getVariable "genSNPRlocked")) exitWith {_available = true;};
	if ((_tipounidad == guer_sol_LAT) && (server getVariable "genATlocked")) exitWith {_available = true;};
	if ((_tipounidad == "Soldier_AA") && (server getVariable "genAAlocked")) exitWith {_available = true;};
};

if !(_available) exitWith {hint "Required weapon not unlocked yet."};

_hr = server getVariable "hr";

if (_hr < 1) exitWith {hint "You do not have enough HR for this request"};

_coste = server getVariable [_tipounidad,150];
if (_tipounidad == "Soldier_AA") then {_coste = server getVariable [guer_sol_AA,150]};
if (!isMultiPlayer) then {_resourcesFIA = server getVariable "resourcesFIA"} else {_resourcesFIA = player getVariable "dinero";};

if (_coste > _resourcesFIA) exitWith {hint format ["You do not have enough money for this kind of unit (%1 € needed)",_coste]};


if ((count units group player) + (count units rezagados) > 9) exitWith {hint "Your squad is full or you have too many scattered units with no radio contact"};

if !(_tipounidad == "Soldier_AA") then {
	_unit = group player createUnit [_tipounidad, position player, [], 0, "NONE"];
}
else {
	_unit = group player createUnit [guer_sol_AA, position player, [], 0, "NONE"];
};

if (!isMultiPlayer) then
	{
	[-1, - _coste] remoteExec ["resourcesFIA",2];
	}
else
	{
	[-1, 0] remoteExec ["resourcesFIA",2];
	[- _coste] call resourcesPlayer;
	hint "Soldier Recruited.\n\nRemember: if you use the group menu to switch groups you will lose control of your recruited AI";
	};

[_unit] spawn AS_fnc_initialiseFIAUnit;
_unit setvariable ["generated",true,true];

if (_tipounidad == "Soldier_AA") then {
	_aal = genAALaunchers select 0;
	[_unit,true,true,true,true] call randomRifle;
	removeBackpackGlobal _unit;
	_unit addBackpackGlobal "B_AssaultPack_blk";
	[_unit, _aal, 2, AAmissile] call BIS_fnc_addWeapon;
	_unit addMagazines [AAmissile, 1];
};

_unit disableAI "AUTOCOMBAT";
sleep 1;
petros directSay "SentGenReinforcementsArrived";