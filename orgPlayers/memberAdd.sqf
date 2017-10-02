params [["_action","add"]];
private ["_target","_uid"];

if (!(serverCommandAvailable "#logout") AND !isServer) exitWith {hint localize "STR_HINTS_GEN_RESTRICTED_ADMIN"};
if (count miembros == 0) exitWith {hint localize "STR_HINTS_GEN_MEM_DIS"};

_target = cursortarget;

if (!isPlayer _target) exitWith {hint localize "STR_HINTS_GEN_MEM_TARGET"};
_uid = getPlayerUID _target;
if ((_action == "add") AND (_uid in miembros)) exitWith {hint localize "STR_HINTS_GEN_MEM_ADD_FAIL"};
if ((_action == "remove") AND !(_uid in miembros)) exitWith {hint localize "STR_HINTS_GEN_MEM_REM_FAIL"};

if (_action == "add") then {
	miembros pushBackUnique _uid;
	hint format [localize "STR_HINTS_GEN_MEM_ADD_SUC",name _target];
} else {
	miembros = miembros - [_uid];
	hint format [localize "STR_HINTS_GEN_MEM_REM_SUC",name _target];
};

publicVariable "miembros";

//Stef making a code to give yourself membership
//miembros pushBackUnique getPlayerUID player