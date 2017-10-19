if (isDedicated) exitWith {};
if !(server getVariable ["flag_allowRoleSelection", false]) exitWith {hint "Currently disabled."};

#define roleList ["NCO","AT","MED","ENG","REC","AR","SOL"]
#define roleNames ["NCO","AT Specialist","Medic","Engineer","Recon","Autorifleman","Soldier"]
#define traitList ["camouflagecoef","audibleCoef","loadCoef","medic","engineer"]
#define roleLimits [4,4,4,4,4,4,16]

#define role_NCO [0.8,0.8,1.4,false,false]
#define role_AT [1.2,1,0.8,false,false]
#define role_MED [1,1,1,true,false]
#define role_ENG [1,1,1,false,true]
#define role_REC [0.8,1,1.2,false,false]
#define role_AR [1,1.2,0.8,false,false]
#define role_SOL [1,0.8,1.2,false,false]

#define roleTraits [role_NCO,role_AT,role_MED,role_ENG,role_REC,role_AR,role_SOL]

#define roleCooldown 5

params [["_newRole","SOL"]];
private ["_currentRole","_currentNumbers","_index","_coolDown"];

if !(player == (player getVariable ["owner",player])) exitWith {hint "Disabled while controlling AI."};

_coolDown = player getVariable ["attr_role_date", time];
if (_coolDown > time) exitWith {hint format ["You just changed your role. Pipe the fuck down. You may try again in %1 seconds.", round (_coolDown - time)]};

if !(_newRole in roleList) then {_newRole = "SOL"};

_currentRole = player getVariable ["attr_role","SOL"];
_currentNumbers = server getVariable ["data_roleNumbers",[0,0,0,0,0,0,0]];
_index = roleList find _newRole;

diag_log format ["Prior: %1; index: %2", _currentNumbers, _index];

if ((_currentNumbers select _index) >= (roleLimits select _index)) exitWith {hint "Role not available"};

player setVariable ["attr_role_date", time + roleCooldown, true];
player setVariable ["attr_role", _newRole, true];
for "_i" from 0 to (count traitList - 1) do {
	player setUnitTrait [traitList select _i, (roleTraits select _index) select _i];
	diag_log format ["%1 set to %2", traitList select _i, (roleTraits select _index) select _i];
};

_currentNumbers set [(roleList find _currentRole), ((_currentNumbers select (roleList find _currentRole)) - 1) max 0];
_currentNumbers set [_index, (_currentNumbers select _index) + 1];

server setVariable ["data_roleNumbers", _currentNumbers, true];

diag_log format ["After: %1", server getVariable ["data_roleNumbers",[0,0,0,0,0,0,0]]];
hint format ["New Role: %1", _newRole];