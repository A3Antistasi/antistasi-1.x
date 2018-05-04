#include "script_component.hpp"
if (!isServer) exitWith {};
if (flag_savingServer) exitWith {"Server data save is still in progress..." remoteExecCall ["hint",Slowhand]};
LOG("START fn_saveGame");
flag_savingServer = true;

//players;
{
	[_x,getPlayerUID _x,false] call AS_fnc_savePlayer;
} forEach (allPlayers - entities "HeadlessClient_F");

//game
["cuentaCA", cuentaCA] call fn_saveData;
["smallCAmrk", smallCAmrk] call fn_saveData;
["membersPool", membersPool] call fn_saveData;
["antenas", antenasmuertas] call fn_saveData;
["mrkAAF", mrkAAF - controles] call fn_saveData;
["mrkFIA", mrkFIA - puestosFIA - controles] call fn_saveData;
["supplySaveArray", supplySaveArray] call fn_saveData;
["posHQ", server getVariable ["posHQ", getMarkerPos guer_respawn]] call fn_saveData;
["prestigeNATO", server getVariable ["prestigeNATO",0]] call fn_saveData;
["prestigeCSAT", server getVariable ["prestigeCSAT",0]] call fn_saveData;
["APCAAFcurrent", APCAAFcurrent] call fn_saveData;
["tanksAAFcurrent",tanksAAFcurrent] call fn_saveData;
["planesAAFcurrent", planesAAFcurrent] call fn_saveData;
["helisAAFcurrent", helisAAFcurrent] call fn_saveData;
["time", date] call fn_saveData;
["resourcesAAF", server getVariable ["resourcesAAF",0]] call fn_saveData;
["skillFIA", server getVariable ["skillFIA",1]] call fn_saveData;
["skillAAF", skillAAF] call fn_saveData;
["destroyedCities", destroyedCities] call fn_saveData;
["destroyedBuildings", destroyedBuildings] call fn_saveData;
["distanciaSPWN", distanciaSPWN] call fn_saveData;
["civPerc", civPerc] call fn_saveData;
["minimoFPS", minimoFPS] call fn_saveData;
["unlockedWeapons", unlockedWeapons] call fn_saveData;
["unlockedItems", unlockedItems] call fn_saveData;
["unlockedMagazines", unlockedMagazines] call fn_saveData;
["unlockedBackpacks", unlockedBackpacks] call fn_saveData;
["AS_destroyedZones", AS_destroyedZones] call fn_saveData;
["jna_dataList", jna_dataList] call fn_saveData;
["jng_vehicleList", jng_vehicleList] call fn_saveData;
["flag_chopForest", flag_chopForest] call fn_saveData;
["BE_data", [] call fnc_BE_save] call fn_saveData;
["enableOldFT",server getVariable ["enableFTold",false]] call fn_saveData;
["enableMemAcc",server getVariable ["enableMemAcc",true]] call fn_saveData;
["campaign_playerList",server getVariable ["campaign_playerList",[]]] call fn_saveData;

//Sparker's War Statistics data
//["ws_grid", ws_grid] call fn_saveData;

private ["_hr","_funds","_vehicle","_weapons","_magazines","_items","_backpacks","_containers","_backpack","_vehiclesToSave","_vehicleType","_supportOPFOR","_supportBLUFOR", "_supplyLevels","_data","_garrison","_mines","_emplacements","_camps","_missionTypes","_objectsHQ","_addObjectsHQ"];

_hr = (server getVariable ["hr",0]) + ({(alive _x) AND (!isPlayer _x) AND (_x getVariable ["BLUFORSpawn",false]) AND (_x getVariable ["generated",false])} count allUnits);
_funds = server getVariable ["resourcesFIA",0];

["hr",_hr] call fn_saveData;
["vehInGarage",vehInGarage] call fn_saveData;

_weapons = weaponCargo caja;
_magazines = magazineCargo caja;
_items = itemCargo caja;
_backpacks = [];

{
	_unit = _x;
	if (_unit getVariable ["BLUFORSpawn",false]) then {
		if ((alive _unit) AND (!isPlayer _unit)) then {
			if ((isPlayer leader _unit) OR (group _unit in (hcAllGroups Slowhand)) AND !((group _unit) getVariable ["esNATO",false])) then {
				if (isPlayer (leader group _unit)) then {
					if (!isMultiplayer) then {
						_funds = _funds + (server getVariable [(typeOf _unit),0]); //Sparker: added brackets here, otherwise it gave error
					};

					{
						if (([_x] call BIS_fnc_baseWeapon) in lockedWeapons) then {
							_weapons pushBack ([_x] call BIS_fnc_baseWeapon);
						};
					} forEach weapons _unit;

					{
						if !(_x in unlockedMagazines) then {
							_magazines pushBack _x;
						};
					} forEach magazines _unit;

					_items = _items + (items _unit) + (primaryWeaponItems _unit) + (assignedItems _unit) + (secondaryWeaponItems _unit);
				};

				if (vehicle _unit != _unit) then {
					_vehicle = vehicle _unit;
					if !(_vehicle in staticsToSave) then {
						if ((_vehicle isKindOf "StaticWeapon") OR (driver _vehicle == _unit)) then {
							if ((group _unit in (hcAllGroups Slowhand)) OR (!isMultiplayer)) then {
								_funds = _funds + ([typeOf _vehicle] call vehiclePrice);
								if (count attachedObjects _vehicle != 0) then {
									{
										_funds = _funds + ([typeOf _x] call vehiclePrice);
									} forEach attachedObjects _vehicle;
								};
							};
						};
					};
				};
			};
		};
	};
} forEach allUnits;

["resourcesFIA",_funds] call fn_saveData;

if (count backpackCargo caja > 0) then {
	{
		_backpacks pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backPackCargo caja;
};

_containers = everyBackpack caja;
if (count _containers > 0) then {
	for "_i" from 0 to (count _containers - 1) do {
		_weapons = _weapons + weaponCargo (_containers select _i);
		_magazines = _magazines + magazineCargo (_containers select _i);
		_items = _items + itemCargo (_containers select _i);
	};
};

/*if (isMultiplayer) then {
	{
		{
			if ([_x] call BIS_fnc_baseWeapon in lockedWeapons) then {
				_weapons pushBack ([_x] call BIS_fnc_baseWeapon);
			};
		} forEach weapons _x;
		_magazines = _magazines + magazines _x + [currentMagazine _x];
		_items = _items + ((items _x) + (primaryWeaponItems _x)+ (assignedItems _x));
		_backpack = (backpack _x) call BIS_fnc_basicBackpack;
		if (!(_backpack in unlockedBackpacks) AND (_backpack != "")) then {
			_backpacks pushBack _backpack;
		};
	} forEach playableUnits;
} else {
	{
		if ([_x] call BIS_fnc_baseWeapon in lockedWeapons) then {
			_weapons pushBack ([_x] call BIS_fnc_baseWeapon);
		};
	} forEach weapons player;
	_magazines = _magazines + magazines player + [currentMagazine player];
	_items = _items + ((items player) + (primaryWeaponItems player)+ (assignedItems player));
	_backpack = (backpack player) call BIS_fnc_basicBackpack;
	if (!(_backpack in unlockedBackpacks) AND (_backpack != "")) then {
		_backpacks pushBack _backpack;
	};
};*/

_vehiclesToSave = [];
{
	_vehicle = _x;
	_vehicleType = typeOf _vehicle;
	call {
		if (_vehicle in staticsToSave) then {
			if (alive _vehicle) then {
				if !(surfaceIsWater position _vehicle) then {
					if (isTouchingGround _vehicle) then {
						if !(isNull _vehicle) then {
							_vehiclesToSave pushBackUnique [_vehicleType,getPosATLVisual _vehicle,getDir _vehicle];
						};
					};
				};
			};
		};

		if (_vehicle distance getMarkerPos "respawn_west" < 50) then {
			// fasten your seat belts
			if !(_vehicle isKindOf "StaticWeapon") then {
				if !(_vehicle isKindOf "ReammoBox") then {
					if !(_vehicle isKindOf "FlagCarrier") then {
						if !(_vehicle isKindOf "Building") then {
							if !(_vehicleType in (planesNATO+vehNATO)) then {
								if (_vehicleType != AS_misSupplyBox) then {
									if (_vehicleType != "I_supplyCrate_F") then {
											if (_vehicleType != "Land_Camping_Light_F") then {
												if (_vehicleType != "Land_WoodenCrate_01_F") then {
													if (count attachedObjects _vehicle == 0) then {
														if ((alive _vehicle) AND ({(alive _x) AND (!isPlayer _x)} count crew _vehicle == 0)) then {
															if !(_vehicleType == "WeaponHolderSimulated") then {
																_vehiclesToSave pushBackUnique [_vehicleType,getPosATLVisual _vehicle,getDir _vehicle];
																_weapons = _weapons + weaponCargo _vehicle;
																_magazines = _magazines + magazineCargo _vehicle;
																_items = _items + itemCargo _vehicle;
																if (count backpackCargo _vehicle > 0) then {
																	{
																		_backpacks pushBack (_x call BIS_fnc_basicBackpack);
																	} forEach backpackCargo _vehicle;
															};
														};
													};
												};
											};
										};
									};
								};
							};
						};
					};
				};
			};
		};
	};
} forEach vehicles - [caja,bandera,fuego,cajaveh,mapa];

["vehicles",_vehiclesToSave] call fn_saveData;
["weapons",_weapons] call fn_saveData;
["magazines",_magazines] call fn_saveData;
["items",_items] call fn_saveData;
["backpacks",_backpacks] call fn_saveData;

/*
Redid this part otherwise if petros dies then 'str _x' returns smth like 'B Petros:1' on Petros. Sparker.
_objectsHQ = [];
{
	private _pos = call compile format ["getPosATLVisual %1", _x];
	private _dir = call compile format ["getDir %1", _x];
	_objectsHQ pushBackUnique [str _x,getPosATLVisual _x, getDir _x];
} forEach [bandera,caja,cajaveh,fuego,mapa,petros];
*/

_objectsHQ = [];
{
	private _pos = call compile format ["getPosATLVisual %1", _x];
	private _dir = call compile format ["getDir %1", _x];
	_objectsHQ pushBackUnique [_x, _pos, _dir];
} forEach ["bandera","caja","cajaveh","fuego","mapa","petros"];

["objectsHQ",_objectsHQ] call fn_saveData;

_addObjectsHQ = [];
{
	_addObjectsHQ pushBackUnique [typeOf _x,getPosATLVisual _x, getDir _x];
} forEach (nearestObjects [getPos fuego, ["Land_Camping_Light_F","Land_BagFence_Round_F","CamoNet_BLUFOR_open_F"], 50]);

if (count (server getVariable ["obj_vehiclePad",[]]) > 0) then {
	_addObjectsHQ pushBackUnique [typeOf obj_vehiclePad,getPosATL obj_vehiclePad,server getVariable ["AS_vehicleOrientation",0]];
};

["addObjectsHQ",_addObjectsHQ] call fn_saveData;

_supportOPFOR = [];
_supportBLUFOR = [];
_supplyLevels= [];
{
	_data = server getVariable _x;
	_supportOPFOR = _supportOPFOR + [_data select 2];
	_supportBLUFOR = _supportBLUFOR + [_data select 3];
	_supplyLevels = _supplyLevels + [_data select 4];
} forEach ciudades;

["supportOPFOR",_supportOPFOR] call fn_saveData;
["supportBLUFOR",_supportBLUFOR] call fn_saveData;
["supplyLevels",_supplyLevels] call fn_saveData;

_garrison = [];
{
_garrison = _garrison + [garrison getVariable [_x,[]]];
} forEach (mrkFIA - puestosFIA - controles - ciudades);

["garrison",_garrison] call fn_saveData;

_mines = [];
{
	_mines = _mines + [typeOf _x,getPos _x,getDir _x,[false,true] select (_x mineDetectedBy side_blue)];
} forEach allMines;

["mines",_mines] call fn_saveData;

_emplacements = [];
{
	_emplacements = _emplacements + [getMarkerPos _x];
} forEach puestosFIA;

["emplacements",_emplacements] call fn_saveData;

_camps = [];
{
	_camps = _camps + [[getMarkerPos _x, markerText _x]];
} forEach campsFIA;

["campList",_camps] call fn_saveData;

_camps = [];
{
	_camps = _camps + [getMarkerPos _x];
} forEach campsFIA;

if (!isDedicated) then {
	_missionTypes = [];
	{
		if (_x in misiones) then {
			if (([_x] call BIS_fnc_taskState) == "CREATED") then {
				_missionTypes pushBack _x;
			};
		};
	} forEach ["AS","ASS","CON","DES","LOG","RES","CONVOY","DEF_HQ","AtaqueAAF"];

	["tasks",_missionTypes] call fn_saveData;
};

_data = [];
{
	_data pushBack [_x,server getVariable _x];
} forEach (aeropuertos + bases);

["idleBases",_data] call fn_saveData;

[] call fn_saveProfile;

flag_savingServer = false;

[petros,"save",""] remoteExec ["commsMP",Slowhand];
INFO("Maintenance: game successfully saved.");
LOG("END fn_saveGame");
