#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_unit","_isJIP"];
private ["_colorWest", "_colorEast","_introShot","_title","_nearestMarker"];

waitUntil {!isNull player};
call AS_fnc_initWorker;

[] execVM "briefing.sqf";
if (isMultiplayer) then {
	if (!isServer) then {
		call compile preprocessFileLineNumbers "initVar.sqf";
		if (!hasInterface) then {
			call compile preprocessFileLineNumbers "roadsDB.sqf";
		};
		call compile preprocessFileLineNumbers "initFuncs.sqf";
	};
};

_colorWest = west call BIS_fnc_sideColor;
_colorEast = east call BIS_fnc_sideColor;
{
	_x set [3, 0.33]
} forEach [_colorWest, _colorEast];

_introShot = [
    position petros, // Target position
    "Altis Island", // SITREP text
    50, //  altitude
    50, //  radius
    90, //  degrees viewing angle
    0, // clockwise movement
    [
    	["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colorWest, markerPos "insertMrk", 1, 1, 0, "Insertion Point", 0],
        ["\a3\ui_f\data\map\markers\nato\o_inf.paa", _colorEast, markerPos "towerBaseMrk", 1, 1, 0, "Radio Towers", 0]
    ]
] spawn BIS_fnc_establishingShot;

if (isMultiplayer) then {
	waitUntil {!isNil "initVar"};
	diag_log format ["Antistasi MP Client. initVar is public. Version %1",antistasiVersion];
};

_title = ["A3 - Antistasi","by Barbolani",antistasiVersion] spawn BIS_fnc_infoText;

//Multiplayer start
if (isMultiplayer) then {
	player setVariable ["elegible",true,true]; //Why? so whoever start will be eligible to be commander?
	musicON = false;
	waitUntil {scriptdone _introshot};
	disableUserInput true;
	cutText ["Waiting for Players and Server Init","BLACK",0];
	diag_log "Antistasi MP Client. Waiting for serverInitDone";
	waitUntil {(!isNil "serverInitDone")};
	cutText ["Starting Mission","BLACK IN",0];
	diag_log "Antistasi MP Client. serverInitDone is public";
	diag_log format ["Antistasi MP Client: JIP?: %1",_isJip];
} else {
//Singleplayer start
	Slowhand = player;
	(group player) setGroupId ["Slowhand","GroupColor4"];
	player setIdentity "protagonista";
	player setUnitRank "COLONEL";
	player hcSetGroup [group player];
	waitUntil {(scriptdone _introshot) and (!isNil "serverInitDone")};
	addMissionEventHandler ["Loaded", {[] execVM "statistics.sqf";[] execVM "reinitY.sqf";}];
};

disableUserInput false;
//Give default civilian gear
player setUnitLoadout (getUnitLoadout (configFile >> "CfgVehicles" >> "C_man_polo_1_F"));
player forceAddUniform (selectRandom civUniforms);
removeGoggles player;
player addWeapon "ItemRadio";
player addWeapon "Binocular";

// In order: controller, TK counter, funds, spawn-trigger, rank, score, known by hostile AI
player setVariable ["owner",player,true];
player setVariable ["punish",0,true];
player setVariable ["dinero",100,true];
player setVariable ["BLUFORSpawn",true,true];
player setVariable ["ASrank",rank player,true];
player setVariable ["score", [0,25] select (player == Slowhand),true];
player setvariable ["compromised",0];

rezagados = creategroup side_blue;
(group player) enableAttack false;

if (!activeACE) then {
	[player] execVM "Revive\initRevive.sqf";
	tags = [] execVM "tags.sqf";
	if (cadetMode AND isMultiplayer) then {
		[] execVM "playerMarkers.sqf";
	};
} else {
	if (activeACEhearing) then {
		player addItem "ACE_EarPlugs";
	};

	if (!activeACEMedical) then {
		[player] execVM "Revive\initRevive.sqf";
	} else {
		[player, false] call AS_fnc_setUnconscious;
	};

	[] execVM "playerMarkers.sqf";
};

gameMenu = (findDisplay 46) displayAddEventHandler ["KeyDown",AS_fnc_keyDownMain];

call AS_fnc_initPlayerEH;

if (isMultiplayer) then {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;//Exec on client
	//["InitializeGroup", [player,WEST,true]] call BIS_fnc_dynamicGroups;
	personalGarage = []; //To-remove
	if (!isNil "placementDone") then {
		_isJip = true;
	};
};

if (_isJip) then { waitUntil {scriptdone _introshot};
		[] execVM "modBlacklist.sqf";
		player setUnitRank "PRIVATE";
		[true] execVM "reinitY.sqf";

		//Make members all players when admin starts (do we really want it?)
		if !([player] call isMember) then {
			if (serverCommandAvailable "#logout") then {
				membersPool pushBack (getPlayerUID player);
				publicVariable "membersPool";
				hint localize "STR_HINTS_INIT_ADMIN_MEMBER"
			} else {
				hint format [localize "STR_HINTS_INIT_GUEST_WELCOME", name player];
			};
		} else {
			hint format [localize "STR_HINTS_INIT_MEMBER_RETURN", name player];

			//Old slot reservation rule, unnecessary for now, make a better one for later
			/* if (serverName in servidoresOficiales) then {
				if ((count playableUnits == maxPlayers) AND (({[_x] call isMember} count playableUnits) < count membersPool)) then {
					{
						if !([_x] call isMember) exitWith {
							["serverFull",false,1,false,false] remoteExec ["BIS_fnc_endMission",_x];
						};
					} forEach playableUnits;
				};
			}; */

			if ({[_x] call isMember} count playableUnits == 1) then {
				[player] call stavrosInit;
				[] remoteExec ["assignStavros",2];
			};
		};

		// Add actions to flags
		{
			if (_x isKindOf "FlagCarrier") then {
				_nearestMarker = [markers,getPos _x] call BIS_fnc_nearestPosition;

				if (!(_nearestMarker in colinas) AND !(_nearestMarker in controles)) then {
					if (_nearestMarker in mrkAAF) then {
						_x addAction [localize "STR_ACT_TAKEFLAG", {[[_this select 0, _this select 1],"mrkWIN"] call BIS_fnc_MP;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
					} else {
						_x addAction [localize "STR_ACT_RECRUITUNIT", {nul=[] execVM "Dialogs\unit_recruit.sqf";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
						_x addAction [localize "STR_ACT_BUYVEHICLE", {createDialog "vehicle_option";},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
						_x addAction [localize "STR_ACT_PERSGARAGE", {[true] spawn garage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
					};
				};
			};
		} forEach vehicles - [bandera,fuego,caja,cajaVeh];

		// Add actions to POWs
		{
			if (typeOf _x == guer_POW) then {
				if (!isPlayer (leader group _x)) then {
					_x addAction [localize "STR_ACT_ORDERREFUGEE", "AI\liberaterefugee.sqf",nil,0,false,true];
				};
			};
		} forEach allUnits;

		// If HQ is set up properly, add mission request action to Petros, otherwise add build HQ action
		if (petros == leader group petros) then {
			removeAllActions petros;
			petros addAction [localize "STR_ACT_MISSIONREQUEST", {nul=CreateDialog "mission_menu";},nil,0,false,true];
		} else {
			removeAllActions petros;
			petros addAction [localize "STR_ACT_BUILDHQ", {[] spawn buildHQ},nil,0,false,true];
		};

		if ((player == Slowhand) AND (isNil "placementDone") AND (isMultiplayer) AND (freshstart)) then {
			[] execVM "UI\startMenu.sqf";
		};
		diag_log "Antistasi MP Client. JIP client finished";
} else {
	if (isNil "placementDone") then {
		waitUntil {!isNil "Slowhand"};
			if (player == Slowhand) then {
			   	 if (isMultiplayer) then {
			    	HC_comandante synchronizeObjectsAdd [player];
					player synchronizeObjectsAdd [HC_comandante];
					if(freshstart) then {[] spawn placementSelection;} else {[] remoteExec ["AS_fnc_loadGame",2];};
					diag_log "Antistasi MP Client. Client finished";
				} else {
			    	membersPool = [];
			    	[] execVM "Dialogs\firstLoad.sqf";
			    };
			};
	};
};

waitUntil {scriptDone _title};

//Waiting for all game data loaded
waitUntil {sleep 1; !isNil "placementDone";};
INFO("Game is ready to initialize player");
//Teleport to the guer_respawn marker
player setPos ((getMarkerPos guer_respawn) getPos [8,random 360]);
player setdir (player getdir petros);
INFO("Player is moved to the camp");
//Called from unscheduled environment to load data at once
[player] remoteExecCall ["AS_fnc_loadPlayer",2];
INFO("Player info loaded");

statistics = [] execVM "statistics.sqf";

// Add respawn in SP if ACE is active
if !(isMultiplayer) then {
	if (activeACEMedical) then {
		[player, false] call AS_fnc_setUnconscious;
		player setVariable ["ASrespawning",false];
		player addEventHandler ["HandleDamage", {
			if (player getVariable ["ACE_isUnconscious", false]) then {
				0 = [player] spawn ACErespawn;
			};
		}
		];
	};
};


[player] execVM "OrgPlayers\unitTraits.sqf";
[player] spawn rankCheck;
[player] spawn localSupport;

//Sparker's WarStatistics and roadblock spawning script. Remove these lines if you don't need it:
//(from here)//
if(isMultiplayer) then
{
    call compile preprocessFileLineNumbers "WarStatistics\initVariables.sqf";
    call compile preprocessFileLineNumbers "WarStatistics\initFunctions.sqf";
    //call compile preprocessFileLineNumbers "WarStatistics\initRoadblocks2.sqf";
};
//(up to here)//
