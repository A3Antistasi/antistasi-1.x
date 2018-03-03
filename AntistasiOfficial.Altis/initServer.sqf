call AS_fnc_initWorkerServer;

if (!isMultiplayer) exitWith {};
if (!(isNil "serverInitDone")) exitWith {};
diag_log "Antistasi MP Server init";
call compile preprocessFileLineNumbers "initVar.sqf";
initVar = true; publicVariable "initVar";
diag_log format ["Antistasi MP. InitVar done. Version: %1",antistasiVersion];
call compile preprocessFileLineNumbers "initFuncs.sqf";
diag_log "Antistasi MP Server. Funcs init finished";
call compile preprocessFileLineNumbers "initZones.sqf";
diag_log "Antistasi MP Server. Zones init finished";
initZones = true; publicVariable "initZones";
 call compile preprocessFileLineNumbers "initPetros.sqf";
 diag_log "Antistasi MP Server. Petros init finished";

//Sparker's WarStatistics and roadblock spawning script. Remove these lines if you don't need it:
//(from here)//
call compile preprocessFileLineNumbers "WarStatistics\initVariables.sqf";
call compile preprocessFileLineNumbers "WarStatistics\initFunctions.sqf";
call compile preprocessFileLineNumbers "WarStatistics\initVariablesServer.sqf";
//call compile preprocessFileLineNumbers "WarStatistics\initRoadblocks2.sqf";
//ws_grid = call ws_fnc_newGridArray;
diag_log "Antistasi MP Server. WarStatistics init finished";
//(up to here)//

["Initialize"] call BIS_fnc_dynamicGroups; //Exec on Server

waitUntil {(count playableUnits) > 0};
waitUntil {({(isPlayer _x) AND (!isNull _x) AND (_x == _x)} count allUnits) == (count playableUnits)};
[] execVM "modBlacklist.sqf";

lockedWeapons = lockedWeapons - unlockedWeapons; //Stef 14/12 is this still required?

diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"locHint","STR_INFO_INITSERVER"],"commsMP"] call BIS_fnc_MP;

addMissionEventHandler ["HandleDisconnect",{_this call onPlayerDisconnect;false}];

Slowhand = objNull;
maxPlayers = playableSlotsNumber west;

if ((['AS_autosave', 0] call BIS_fnc_getParamValue) == 1) then {[] execVM "serverAutosave.sqf";};
publicVariable "Slowhand";
publicVariable "maxPlayers";
serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";
