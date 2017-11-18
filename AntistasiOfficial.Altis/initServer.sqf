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
ws_grid = call ws_fnc_newGridArray;
diag_log "Antistasi MP Server. WarStatistics init finished";
//(up to here)//

["Initialize"] call BIS_fnc_dynamicGroups; //Exec on Server

waitUntil {(count playableUnits) > 0};
waitUntil {({(isPlayer _x) AND (!isNull _x) AND (_x == _x)} count allUnits) == (count playableUnits)};
[] execVM "modBlacklist.sqf";

lockedWeapons = lockedWeapons - unlockedWeapons;

diag_log "Antistasi MP Server. Arsenal config finished";
[[petros,"hint",localize "STR_INFO_INITSERVER"],"commsMP"] call BIS_fnc_MP;

addMissionEventHandler ["HandleDisconnect",{_this call onPlayerDisconnect;false}];

Slowhand = objNull;
maxPlayers = playableSlotsNumber west;

if (serverName in servidoresOficiales) then {
    [] execVM "serverAutosave.sqf";
 } else {
    if (isNil "comandante") then {comandante = (playableUnits select 0)};
    if (isNull comandante) then {comandante = (playableUnits select 0)};

    {
        if (_x ==comandante) then {
            Slowhand = _x;
            publicVariable "Slowhand";
            _x setRank "CORPORAL";
            [_x,"CORPORAL"] remoteExec ["ranksMP"];
        };
    } forEach playableUnits;
    diag_log "Antistasi MP Server. Players are in";
    };
publicVariable "maxPlayers";

hcArray = [];

if (!isNil "HC1") then {hcArray pushBack HC1};
if (!isNil "HC2") then {hcArray pushBack HC2};
if (!isNil "HC3") then {hcArray pushBack HC3};

HCciviles = 2;
HCgarrisons = 2;
HCattack = 2;
if (count hcArray > 0) then {
    HCciviles = hcArray select 0;
    HCattack = hcArray select 0;
    diag_log "Antistasi MP Server. Headless Client 1 detected";
    if (count hcArray > 1) then {
        HCattack = hcArray select 1;
        diag_log "Antistasi MP Server. Headless Client 2 detected";
        if (count hcArray > 2) then {
            HCgarrisons = hcArray select 2;
            diag_log "Antistasi MP Server. Headless Client 3 detected";
        };
    };
};

publicVariable "HCciviles";
publicVariable "HCgarrisons";
publicVariable "HCattack";
publicVariable "hcArray";

dedicatedServer = false;
if (isDedicated) then {dedicatedServer = true};
publicVariable "dedicatedServer";

serverInitDone = true; publicVariable "serverInitDone";
diag_log "Antistasi MP Server. serverInitDone set to true.";