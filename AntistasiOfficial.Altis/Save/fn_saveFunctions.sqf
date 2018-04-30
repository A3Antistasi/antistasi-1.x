/*
	Data format: worldName_Side_Locality_Variable
	Example: Tanoa_G_S_jna_dataList -- Tanoa, Green, Server, content of JNA
	Example: Altis_B_P_GUID_gear_uniform -- Altis, Blue, Player, PlayerUID, player's uniform

	//by jeroen 12-8-2017
	//added optinal saving type with iniDBi2
*/
#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"
if(!isserver)exitWith{};

usingIniDb = !isnil "OO_INIDBI";

if(usingIniDb)then{
	INFO("fn_saveFunctions.sqf: iniDBi2 detected!");

	//Initialize INIDBI unctions
	fn_saveDataINIDBI = compile preprocessfilelinenumbers "Save\fn_saveDataINIDBI.sqf";
	fn_loadDataINIDBI = compile preprocessfilelinenumbers "Save\fn_loadDataINIDBI.sqf";

	playerDB = ["new", format["players_%1_%2_", worldName, static_playerSide]] call OO_INIDBI;
	saveDB = {objNull};//needs to return objNull so we can check for it later
	databaseName = format ["save_%1_%2_", worldName, static_playerSide];
	databaseNameNr = 0;
	_found = false;
	while{true}do{
		private _name = (databaseName + str databaseNameNr);
		loadDB = saveDB;//database to load from is always one older then where we store new stuff in to
		saveDB = ["new", _name] call OO_INIDBI;
		if!("exists" call saveDB)exitWith{};

		databaseNameNr = databaseNameNr + 1;
	};
	INFO_1("fn_saveFunctions.sqf: current save database number: %1", databaseNameNr);
	//Set these separators
	["setSeparator", (toString [221,222])] call playerDB; //Don't try to join the game with these characters in your name, allright?
	["setSeparator", (toString [221,222])] call loadDB;
	["setSeparator", (toString [221,222])] call saveDB;
};

// player
fn_savePlayerData = {
	params [
		["_varName","",[""]],
		"_varValue",
		["_uid","",[""]]
	];
    TRACE_3("START fn_savePlayerData", _varName, _varValue, _uid);

	if ((isNil "_varValue") OR (_varName == "") OR (_uid == ""))exitWith {
		ERROR_3("Error in fn_savePlayerData -- name: %1; value: %2; _player: %3", _varName,_varValue,_uid);
	};

	if (_varValue isEqualTo "") exitWith {};

	if(usingIniDb)then{
		[playerDB, _uid, _varname, _varValue] call fn_saveDataINIDBI;
		LOG("saved to INIDB");
	}else{
		profileNameSpace setVariable [format ["%1_%2_P_%3_%4",worldName,static_playerSide,_uid,_varName],_varValue];
		LOG("saved to profileNameSpace");
	};
    TRACE_3("END fn_savePlayerData", _varName, _varValue, _uid);
};

fn_loadPlayerData = {
	params [ ["_varName","",[""]],  ["_player",objNull,[objNull]] ];
    TRACE_2("START fn_loadPlayerData", _varName, _player);

	if ((_varName == "") OR (isnull _player))exitWith {
		ERROR_2("fn_loadPlayerData -- name: %1; _player: %2", _varName, _player);
	};

	private _uid = getPlayerUID _player;
	private _varValue = if(usingIniDb)then{
        TRACE_3("fn_loadPlayerData: loading player data with inidbi2", _varName, _player, _uid);
		[playerDB, _uid, _varname, objNull] call fn_loadDataINIDBI;
	}else{
        TRACE_3("fn_loadPlayerData: loading player data with profileNameSpace", _varName, _player, _uid);
		profileNameSpace getVariable [(format ["%1_%2_P_%3_%4",worldName,static_playerSide,_uid,_varName]),objNull];
	};
    TRACE_3("fn_loadPlayerData: value loaded", _varName, _varValue, _uid);
	//Replaced the isNull check with isNil check because the isNull check gives errors. Sparker.
	if(_varValue isEqualTo objNull)exitwith{ERROR_2("fn_loadPlayerData: could not load variable %1 for player %2", _varName,_uid);};
	[_varName,_varValue,_player] call fn_setPlayerData;
    TRACE_2("END fn_loadPlayerData", _varName, _player);
};

fn_setPlayerData = {
	params ["_varName","_varValue","_player"];
    TRACE_3("START fn_setPlayerData", _varName,_varValue,_player);
	call {
		if(_varName == 'loadout') exitWith {
		    if(_varValue isEqualType []) then {
                [  _varValue,
                    {
                        removeBackpackGlobal player;
                        removeVest player;
                        removeUniform player;
                        removeGoggles player;
                        player setUnitLoadout _this;
                        systemChat "Loadout restored";
                    }
                ] remoteExec ["call", _player];
            };
		};
		if(_varName isEqualTo 'funds') exitWith {_player setVariable ["dinero",_varValue,true];};
		if(_varName isEqualTo 'score') exitWith {_player setVariable ["score",_varValue,true];};
		if(_varName isEqualTo 'rank') exitWith {
			_player setUnitRank _varValue;
			_player setVariable ["ASrank",_varValue,true];
			[_player, _varValue] remoteExec ["ranksMP"]
		};
	};
    TRACE_3("END fn_setPlayerData", _varName,_varValue,_player);
};

// server
fn_saveData = {
	params [["_varName","",[""]],"_varValue"];
	if (_varName == "") exitWith {ERROR_2("Error in fn_saveData, no name --  name: %1; value: %2", _varname,_varValue)};
	if (isNil "_varValue") exitWith {ERROR_2("Error in fn_saveData, no value --  name: %1; value: %2", _varname,_varValue)};
	if(usingIniDb)then{
		if ((['AS_saveprofilesave', 0] call BIS_fnc_getParamValue) == 1) then {
			profileNameSpace setVariable [format ["%1_%2_S_%3",worldName,static_playerSide,_varname],_varValue];
		} else {
			//["write", ["Game", _varName, _varValue]] call saveDB;
			[saveDB, "Game", _varname, _varValue] call fn_saveDataINIDBI;
		}
	}else{
		profileNameSpace setVariable [format ["%1_%2_S_%3",worldName,static_playerSide,_varname],_varValue];
	};
};

fn_loadData = {
	params [["_varname","",[""]]];
	if (_varName == "") exitWith {ERROR_1("Error in fn_loadData, no name -- name: %1", _varname)};

	_varValue =
	if(usingIniDb)then{
		if ((['AS_loadprofilesave', 0] call BIS_fnc_getParamValue) == 1) then {
			profileNameSpace getVariable [(format ["%1_%2_S_%3",worldName,static_playerSide,_varname]),objNull];
		} else {
			//[saveDB, _varname,loadDB] call AS_FNC_loadDataINIDBI; //Not going to pre-compile it!
			[loadDB, "Game", _varname, objNull] call fn_loadDataINIDBI;
		}
	}else{
		profileNameSpace getVariable [(format ["%1_%2_S_%3",worldName,static_playerSide,_varname]),objNull];
	};

	if(_varValue isEqualTo objNull) exitwith
	{
		ERROR_1("fn_loadData: Error: variable %1 could not be loaded!", _varname);
	};
	LOG_2("fn_loadData: Success: variable %1: %2", _varname, _varValue);
	[_varName,_varValue] call fn_setData;
};

fn_saveProfile = {
	LOG("fn_saveProfile");
	if(usingIniDb)then{
		while{true}do{
			databaseNameNr = databaseNameNr + 1;//increase savename number by 1
			private _name = (databaseName + str databaseNameNr);
			loadDB = saveDB;
			saveDB = ["new", _name] call OO_INIDBI;
			//Set this annoying separator
			["setSeparator", (toString [221,222])] call saveDB;
			if!("exists" call saveDB)exitWith{};//make sure it doest exist yet, so we dont overwrite it
		};
	}else{
		saveProfileNamespace
	};
};

//ADD VARIABLES TO THIS ARRAY THAT NEED SPECIAL SCRIPTING TO LOAD
specialVarLoads =
["campaign_playerList","cuentaCA","membersPool","antenas","posHQ","prestigeNATO","prestigeCSAT","APCAAFcurrent","tanksAAFcurrent","planesAAFcurrent","helisAAFcurrent","time","resourcesAAF","skillFIA","skillAAF","destroyedBuildings","flag_chopForest","BE_data","enableOldFT","enableMemAcc","hr","resourcesFIA","vehicles","weapons","magazines","items","backpacks","objectsHQ","addObjectsHQ","supportOPFOR","supportBLUFOR", "supplyLevels","garrison","mines","emplacements","campList","tasks","idleBases","unlockedWeapons","unlockedItems","unlockedMagazines","unlockedBackpacks"];

/*
	Variables that are loaded, but do not require special procedures
	["smallCAmrk","mrkAAF","mrkFIA","destroyedCities","distanciaSPWN","civPerc","minimoFPS","AS_destroyedZones","vehInGarage"]
*/

//THIS FUNCTIONS HANDLES HOW STATS ARE LOADED
fn_setData = {
	params ["_varName","_varValue"];

	if (_varName in specialVarLoads) then {
		call {
		    if(_varName == 'membersPool' AND (['AS_param_onlyPermanentMembers',1] call BIS_fnc_getParamValue) == 0) exitWith {
		        {membersPool pushBackUnique _x;} forEach _varValue;
		    };
			if(_varName == 'campaign_playerList') exitWith {server setVariable ["campaign_playerList",_varValue,true]};
			if(_varName == 'cuentaCA') exitWith {cuentaCA = _varValue max 2700};
			if(_varName == 'flag_chopForest') then {
				flag_chopForest = _varValue;
				if (flag_chopForest) then {[] spawn AS_fnc_clearForest};
			};
			if(_varName == 'BE_data') exitWith {[_varValue] call fnc_BE_load};
			if(_varName == 'unlockedWeapons') exitWith {
				unlockedWeapons = _varValue;
				lockedWeapons = lockedWeapons - unlockedWeapons;
				if (activeJNA) exitWith {};
				// XLA fixed arsenal
				if (activeXLA) then {
					[caja,unlockedWeapons,true] call XLA_fnc_addVirtualWeaponCargo;
				} else {
					[caja,unlockedWeapons,true] call BIS_fnc_addVirtualWeaponCargo;
				};
			};
			if(_varName == 'unlockedBackpacks') exitWith {
				unlockedBackpacks = _varValue;
				genBackpacks = genBackpacks - unlockedBackpacks;
				if (activeJNA) exitWith {};
				// XLA fixed arsenal
				if (activeXLA) then {
					[caja,unlockedBackpacks,true] call XLA_fnc_addVirtualBackpackCargo;
				} else {
					[caja,unlockedBackpacks,true] call BIS_fnc_addVirtualBackpackCargo;
				};
			};
			if(_varName == 'unlockedItems') exitWith {
				unlockedItems = _varValue;
				if (activeJNA) exitWith {};
				// XLA fixed arsenal
				if (activeXLA) then {
					[caja,unlockedItems,true] call XLA_fnc_addVirtualItemCargo;
				} else {
					[caja,unlockedItems,true] call BIS_fnc_addVirtualItemCargo;
				};
				{
				if (_x in unlockedItems) then {unlockedOptics pushBack _x};
				} forEach genOptics;
			};
			if(_varName == 'unlockedMagazines') exitWith {
				unlockedMagazines = _varValue;
				if (activeJNA) exitWith {};
				// XLA fixed arsenal
				if (activeXLA) then {
					[caja,unlockedMagazines,true] call XLA_fnc_addVirtualMagazineCargo;
				} else {
					[caja,unlockedMagazines,true] call BIS_fnc_addVirtualMagazineCargo;
				};
			};
			if(_varName == 'prestigeNATO') exitWith {server setVariable ["prestigeNATO",_varValue,true]};
			if(_varName == 'prestigeCSAT') exitWith {server setVariable ["prestigeCSAT",_varValue,true]};
			if(_varName == 'hr') exitWith {server setVariable ["HR",_varValue,true]};
			if(_varName == 'planesAAFcurrent') exitWith {
				planesAAFcurrent = _varValue max 0;
				if ((planesAAFcurrent > 0) and (count indAirForce < 2)) then {indAirForce = indAirForce + planes; publicVariable "indAirForce"}
			};
			if(_varName == 'helisAAFcurrent') exitWith {
				helisAAFcurrent = _varValue max 0;
				if (helisAAFcurrent > 0) then {
					indAirForce = indAirForce - heli_armed;
					indAirForce = indAirForce + heli_armed;
					publicVariable "indAirForce";
				};
			};
			if(_varName == 'APCAAFcurrent') exitWith {
				APCAAFcurrent = _varValue max 0;
				if (APCAAFcurrent > 0) then {
					enemyMotorpool = enemyMotorpool -  vehAPC - vehIFV;
					enemyMotorpool = enemyMotorpool +  vehAPC + vehIFV;
					publicVariable "enemyMotorpool";
				};
			};
			if(_varName == 'tanksAAFcurrent') exitWith {
				tanksAAFcurrent = _varValue max 0;
				if (tanksAAFcurrent > 0) then {
					enemyMotorpool = enemyMotorpool - vehTank;
					enemyMotorpool = enemyMotorpool +  vehTank;
					publicVariable "enemyMotorpool"
				};
			};
			if(_varName == 'time') exitWith {setDate _varValue;};
			if(_varName == 'resourcesAAF') exitWith {server setVariable ["resourcesAAF",_varValue,true]};
			if(_varName == 'resourcesFIA') exitWith {server setVariable ["resourcesFIA",_varValue,true]};
			if(_varName == 'destroyedBuildings') exitWith {
				for "_i" from 0 to (count _varValue) - 1 do {
					_posBuild = _varValue select _i;
					if (typeName _posBuild == "ARRAY") then {
						_buildings = [];
						_dist = 5;
						while {count _buildings == 0} do {
							_buildings = nearestObjects [_posBuild, listMilBld, _dist];
							_dist = _dist + 5;
						};
						if (count _buildings > 0) then {
							_milBuild = _buildings select 0;
							_milBuild setDamage 1;
						};
						destroyedBuildings = destroyedBuildings + [_posBuild];
					};
				};
			};
			if(_varName == 'skillFIA') exitWith {
				server setVariable ["skillFIA",_varValue,true];
				{
					_coste = server getVariable _x;
					for "_i" from 1 to _varValue do {
						_coste = round (_coste + (_coste * (_i/280)));
					};
					server setVariable [_x,_coste,true];
				} forEach guer_soldierArray;
			};
			if(_varName == 'skillAAF') exitWith {
				skillAAF = _varValue;
				{
					_coste = server getVariable _x;
					for "_i" from 1 to skillAAF do {
						_coste = round (_coste + (_coste * (_i/280)));
					};
					server setVariable [_x,_coste,true];
				} forEach units_enemySoldiers;
			};
			if(_varName == 'mines') exitWith {
				/*for "_i" from 0 to (count _varValue) - 1 do {
					_unknownMine = false;
					_tipoMina = _varValue select _i select 0;
					switch _tipoMina do {
						case apMine_type: {_tipoMina = apMine_placed};
						case atMine_type: {_tipoMina = atMine_placed};
						case "APERSBoundingMine_Range_Ammo": {_tipoMina = "APERSBoundingMine"};
						case "SLAMDirectionalMine_Wire_Ammo": {_tipoMina = "SLAMDirectionalMine"};
						case "APERSTripMine_Wire_Ammo": {_tipoMina = "APERSTripMine"};
						case "ClaymoreDirectionalMine_Remote_Ammo": {_tipoMina = "Claymore_F"};
						default {
							_unknownMine = true;
						};
					};
					if !(_unknownMine) then {
						_posMina = _varValue select _i select 1;
						_dirMina = _varValue select _i select 2;
						_mina = createMine [_tipoMina, _posMina, [], _dirMina];
						_detectada = _varValue select _i select 3;
						if (_detectada) then {side_blue revealMine _mina};
					};
				};*/
			};
			if(_varName == 'garrison') exitWith {
				_markers = mrkFIA - puestosFIA - controles - ciudades;
				_garrison = _varValue;
				for "_i" from 0 to (count _markers - 1) do
					{
					garrison setVariable [_markers select _i,_garrison select _i,true];
					};
				};
			if(_varName == 'emplacements') exitWith {
				{
					_mrk = createMarker [format ["FIApost%1", random 1000], _x];
					_mrk setMarkerShape "ICON";
					_mrk setMarkerType "loc_bunker";
					_mrk setMarkerColor "ColorYellow";
					if (isOnRoad _x) then {
						_mrk setMarkerText localize "STR_GL_FIARB";
						FIA_RB_list pushBackUnique _mrk;
					} else {
						_mrk setMarkerText localize "STR_GL_FIAWP";
						FIA_WP_list pushBackUnique _mrk;
					};
					spawner setVariable [_mrk,false,true];
					puestosFIA pushBack _mrk;
				} forEach _varValue;
			};
			if (_varName == 'campList') exitWith {
				if (count _varValue != 0) then {
					{
						_mrk = createMarker [format ["FIACamp%1", random 1000], (_x select 0)];
						_mrk setMarkerShape "ICON";
						_mrk setMarkerType "loc_bunker";
						_mrk setMarkerColor "ColorOrange";
						_txt = _x select 1;
						_mrk setMarkerText _txt;
						usedCN pushBackUnique _txt;
						spawner setVariable [_mrk,false,true];
						campList pushBack [_mrk, _txt];
						campsFIA pushBack _mrk;
					} forEach _varValue;
				};
			};
			if(_varName == 'enableOldFT') exitWith {server setVariable ["enableFTold",_varValue,true]};
			if(_varName == 'enableMemAcc') exitWith {server setVariable ["enableMemAcc",_varValue,true]};
			if(_varName == 'antenas') exitWith {
				antenasmuertas = _varValue;
				for "_i" from 0 to (count _varValue - 1) do {
				    _posAnt = _varValue select _i;
				    _mrk = [mrkAntenas, _posAnt] call BIS_fnc_nearestPosition;
				    _antena = [antenas,_mrk] call BIS_fnc_nearestPosition;
				    antenas = antenas - [_antena];
				    _antena removeAllEventHandlers "Killed";
				    sleep 1;
				    _antena setDamage 1;
				    deleteMarker _mrk;
				};
				antenasmuertas = _varValue;
			};
			if(_varName == 'weapons') exitWith {
				clearWeaponCargoGlobal caja;
				{caja addWeaponCargoGlobal [_x,1]} forEach _varValue;
			};
			if(_varName == 'magazines') exitWith {
				clearMagazineCargoGlobal caja;
				{caja addMagazineCargoGlobal [_x,1]} forEach _varValue;
			};
			if(_varName == 'items') exitWith {
				clearItemCargoGlobal caja;
				{caja addItemCargoGlobal [_x,1]} forEach _varValue;
			};
			if(_varName == 'backpacks') exitWith {
				clearBackpackCargoGlobal caja;
				{caja addBackpackCargoGlobal [_x,1]} forEach _varValue;
			};
			//Redundant, same code done for all options, propably add some bool to avoid double execution??
			//Most likely getting even worse with supply levels ...
			//I would recommend to redo this part, if I got some time, I will do this - wurzel
			
			if(_varname == 'supportOPFOR') exitWith {
				for "_i" from 0 to (count ciudades) - 1 do {
					_ciudad = ciudades select _i;
					_datos = server getVariable _ciudad;
					_numCiv = _datos select 0;
					_numVeh = _datos select 1;
					_prestigeOPFOR = _varValue select _i;
					_prestigeBLUFOR = _datos select 3;
					_supplyLevels = ["LOW", "LOW", "LOW"];
					_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR, _supplyLevels];
					server setVariable [_ciudad,_datos,true];
				};
			};
			if(_varname == 'supportBLUFOR') exitWith {
				for "_i" from 0 to (count ciudades) - 1 do {
					_ciudad = ciudades select _i;
					_datos = server getVariable _ciudad;
					_numCiv = _datos select 0;
					_numVeh = _datos select 1;
					_prestigeOPFOR = _datos select 2;
					_prestigeBLUFOR = _varValue select _i;
					_supplyLevels = _datos select 4;
					_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR, _supplyLevels];
					server setVariable [_ciudad,_datos,true];
				};
			};
			
			if(_varName == 'supplyLevels') exitWith
			{
				for "_i" from 0 to (count ciudades) - 1 do {
					_ciudad = ciudades select _i;
					_datos = server getVariable _ciudad;
					_numCiv = _datos select 0;
					_numVeh = _datos select 1;
					_prestigeOPFOR = _datos select 2;
					_prestigeBLUFOR = _datos select 3;
					_supplyLevels = _varValue select _i;
					_datos = [_numCiv,_numVeh,_prestigeOPFOR,_prestigeBLUFOR, _supplyLevels];
					server setVariable [_ciudad,_datos,true];
				};
			};
			
			if(_varname == 'idleBases') exitWith {
				{
					server setVariable [(_x select 0),(_x select 1),true];
				} forEach _varValue;
			};

			// HQ
			if(_varName == 'posHQ') exitWith {
				{
					if (getMarkerPos _x distance _varValue < 1000) then {
						mrkAAF = mrkAAF - [_x];
						mrkFIA = mrkFIA + [_x];
					};
				} forEach controles;

				"FIA_HQ" setMarkerPos _varValue;
				posHQ = _varValue;
				guer_respawn setMarkerPos _varValue;
				guer_respawn setMarkerAlpha 1;
				server setVariable ["posHQ", _varValue, true];
			};
			if(_varName == 'objectsHQ') exitWith {
				{
					_type = _x select 0;
					switch (_type) do {
						case "bandera": {
							bandera setDir (_x select 2);
							bandera setPosATL (_x select 1);
						};
						case "caja": {
							caja setDir (_x select 2);
							caja setPosATL (_x select 1);
						};
						case "cajaveh": {
							cajaveh setDir (_x select 2);
							cajaveh setPosATL (_x select 1);
						};
						case "fuego": {
							fuego setDir (_x select 2);
							fuego setPosATL (_x select 1);
							fuego inflame true
						};
						case "mapa": {
							mapa setDir (_x select 2);
							mapa setPosATL (_x select 1);
						};
						case "petros": {
							petros setDir (_x select 2);
							petros setPosATL (_x select 1);
						};
					};
				} forEach _varValue;
			};
			if(_varName == 'addObjectsHQ') exitWith {
				if (count _varValue == 0) exitWith {};
				{
					_obj = (_x select 0) createVehicle [0,0,0];
					_obj setDir (_x select 2);
					_obj setPosATL (_x select 1);

					if ((_x select 0) == "Land_JumpTarget_F") then {
						obj_vehiclePad = _obj;
						[obj_vehiclePad,"removeObj"] remoteExec ["AS_fnc_addActionMP"];
						server setVariable ["obj_vehiclePad",getPosATL obj_vehiclePad,true];
					} else {
						[_obj,"moveObject"] remoteExec ["AS_fnc_addActionMP"];
						[_obj,"removeObj"] remoteExec ["AS_fnc_addActionMP"];
					};
				} forEach _varValue;
			};
			//

			if(_varname == 'vehicles') exitWith {
				for "_i" from 0 to (count _varValue) - 1 do {
					_tipoVeh = _varValue select _i select 0;
					_posVeh = _varValue select _i select 1;
					_dirVeh = _varValue select _i select 2;

					_veh = _tipoVeh createVehicle [0,0,0];
					_veh setDir _dirVeh;
					_veh setPosATL _posVeh;
					_veh setCenterOfMass [(getCenterOfMass _veh) vectorAdd [0, 0, -1], 0];

					if (_tipoVeh in (statics_allMGs + statics_allATs + statics_allAAs + statics_allMortars)) then {
						staticsToSave pushBack _veh;
					};
					_veh setVariable ["HQ_vehicle", 1]; //Means that this vehicle has been added during HQ loading.
					[_veh] spawn VEHinit;
				};
			};
			if(_varname == 'tasks') exitWith {
				{
					if (_x == "AtaqueAAF") then {
						[] spawn AS_fnc_spawnAttack;
					} else {
						if (_x == "DEF_HQ") then {
							[] spawn ataqueHQ;
						} else {
							[_x,true] call missionRequest;
						};
					};
				} forEach _varValue;
			};
			if(_varname == 'jna_dataList') exitWith {
				//dead code
				jna_dataList = _varValue;
			};
			if(_varname == 'jng_vehicleList') exitWith {
				//dead code
				jng_vehicleList = _varValue;
			};
		};
	} else {
		//call compile format ["%1 = %2",_varName,_varValue]; //Format has 8kBytes limit, be careful with that!
		call compile (_varName + " = _varValue");
	};
};

//==================================================================================================================================================================================================


saveFuncsLoaded = true;
publicVariable "saveFuncsLoaded";