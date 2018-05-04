params [["_oneIteration", false]];
[getMarkerPos guer_respawn,[],[],false] params ["_positionHQ","_options","_zones"];
if (!isServer) exitWith{};

scriptName "resourcecheck";

if (isMultiplayer) then {waitUntil {!isNil "switchCom"}};

private ["_incomeFIA","_incomeEnemy","_hrFIA","_popFIA","_popEnemy","_bonusFIA","_bonusEnemy", "_cityInRange" ,"_city","_cityIncomeFIA","_cityIncomeEnemy","_cityIncomeHR","_data","_civilians","_supportFIA","_supportEnemy", "_supplyLevels","_power","_coef","_mrkD","_base","_factory","_resource","_text","_updated","_resourcesAAF","_vehicle","_script","_types"];

//Sparker's War Statistics variables
private _ws_territory = call ws_fnc_newGridArray;	//Array for the sum of AAF(positive) and FIA(negative) territories
private _ws_frontlineSmooth = call ws_fnc_newGridArray;	//Array for the zero-crossing filter
private _ws_frontline = call ws_fnc_newGridArray;	//Array for the zero-crossing filter
private _ws_frontlineDir = call ws_fnc_newGridArray;	//Array for the edge direction filter
private _ws_radius = 500;						//Value needed to calculate fields around markers. At distance equal to _ws_radius the field value will drop to 0.5.
////////////////////////////////////

while {true} do {

	//Roadblock placement based on the frontline, made by Sparker
	//Just remove this if you need. Also check it in init and serverInit.
	diag_log "resourcecheck.sqf: calculating grids...";
	[_ws_territory, 0] call ws_fnc_setValueAll; //reset the grid
	[((mrkAAF-ciudades)-colinas)-controles, _ws_radius, 1, _ws_territory] call ws_fnc_markersToGridArray;		//Convert AAF territory into a 2D array
	[(((mrkFIA-["FIA_HQ"])-ciudades)-controles)-colinas, _ws_radius, -1.2,_ws_territory] call ws_fnc_markersToGridArray;	//Convert FIA territory into a 2D array
	[_ws_territory, 0, _ws_frontline] call ws_fnc_filterZeroCrossing;											//Detect zero crossing
	[_ws_frontline, 0.5, _ws_frontline] call ws_fnc_filterThreshold;											//Make the zero crossing more sharp
	[_ws_frontline, _ws_frontlineSmooth] call ws_fnc_filterSmooth;												//Blur the frontline
	[_ws_territory, _ws_frontlineDir] call ws_fnc_filterEdgeDir;												//Calculate the direction of the frontline. The direction points to AAF territory

	[ws_territory, _ws_territory] call ws_fnc_copyGrid;
	[ws_frontlineSmooth, _ws_frontlineSmooth] call ws_fnc_copyGrid;
	publicVariable "ws_frontlineSmooth";
	[ws_frontline, _ws_frontline] call ws_fnc_copyGrid;
	[ws_frontlineDir, _ws_frontlineDir] call ws_fnc_copyGrid;
	diag_log "resourcecheck.sqf: finished calculating grids. Putting roadblocks.";
	private _newRoadblocks = [ws_frontline, ws_frontlineSmooth, ws_frontlineDir, controles, 1000, false] call ws_fnc_putRoadblockmarkersAtFrontline;
	diag_log format ["resourcecheck.sqf: Added %1 roadblocks.", _newRoadblocks];
	//////////////////////////////////////////////////////////////////////////////


	if(!_oneIteration) then //Don't sleep if we execute it only one time
	{
		diag_log "resourcecheck.sqf: waiting for 600 seconds.";
		sleep 600;
	};
	diag_log "resourcecheck.sqf: calculating resources.";
	if (isMultiplayer) then {waitUntil {sleep 10; isPlayer Slowhand}};
	_incomeEnemy = 0;
	_incomeFIA = 25;//0
	_hrFIA = 0;//0
	_popFIA = 0;
	_popEnemy = 0;
	_bonusEnemy = 1;
	_bonusFIA = 1;
	_cityInRange = [];

	{
		_city = _x;
		_cityIncomeEnemy = 0;
		_cityIncomeFIA = 0;
		_cityIncomeHR = 0;
		_data = server getVariable [_city,[0,0,1,1,[]]];
		_civilians = _data select 0;
		_supportEnemy = _data select 2;
		_supportFIA = _data select 3;
		_supplyLevels = _data select 4;
		_power = [_city] call AS_fnc_powerCheck;
		_coef = [0.5,1] select _power;
		_popFIA = _popFIA + (_civilians * (_supportFIA / 100));
		_popEnemy = _popEnemy + (_civilians * (_supportEnemy / 100));

		if (_city in destroyedCities) then {
			_cityIncomeEnemy = 0;
			_cityIncomeFIA = 0;
			_cityIncomeHR = 0;
		} else {
			_cityIncomeEnemy = ((_civilians * _coef*(_supportEnemy / 100)) /3);
			_cityIncomeFIA = ((_civilians * _coef*(_supportFIA / 100))/3);
			_cityIncomeHR = (_civilians * (_supportFIA / 20000));

			if (_city in mrkFIA) then {
				_cityIncomeEnemy = (_cityIncomeEnemy/2);
				if (_power) then {
					if (_supportFIA + _supportEnemy + 1 <= 100) then {[0,1,_city] spawn AS_fnc_changeCitySupport};
				} else {
					if (_supportFIA > 6) then {
						[0,-1,_city] spawn AS_fnc_changeCitySupport;
					} else {
						[1,0,_city] spawn AS_fnc_changeCitySupport;
					};
				};
			} else {
				_cityIncomeFIA = (_cityIncomeFIA/2);
				_cityIncomeHR = (_cityIncomeHR/2);
				if (_power) then {
					if (_supportEnemy + _supportFIA + 1 <= 100) then {[1,0,_city] call AS_fnc_changeCitySupport};
				} else {
					if (_supportEnemy > 6) then {
						[-1,0,_city] spawn AS_fnc_changeCitySupport;
					} else {
						[0,1,_city] spawn AS_fnc_changeCitySupport;
					};
				};
			};
			if(getmarkerPos _city distance _positionHQ < 4000) then
			{
				_cityInRange pushbackunique _city;
			}
		};

		_incomeEnemy = _incomeEnemy + _cityIncomeEnemy;
		_incomeFIA = _incomeFIA + _cityIncomeFIA;
		_hrFIA = _hrFIA + _cityIncomeHR;

		if ((_supportEnemy < _supportFIA) AND (_city in mrkAAF)) then {
			[_city,{["TaskSucceeded", ["", format [localize "STR_NTS_JOINFIA",[_this, false] call AS_fnc_location]]] call BIS_fnc_showNotification}] remoteExec ["call", 0];
			mrkAAF = mrkAAF - [_city];
			mrkFIA = mrkFIA + [_city];
			if (activeBE) then {["con_cit"] remoteExec ["fnc_BE_XP", 2]};
			publicVariable "mrkAAF";
			publicVariable "mrkFIA";
			[0,0] remoteExec ["prestige",2];
			_mrkD = format ["Dum%1",_city];
			_mrkD setMarkerColor guer_marker_colour;
			if (_power) then {_power = false} else {_power = true};
			[_city,_power] spawn AS_fnc_adjustLamps;
			sleep 5;
			{[_city,_x] spawn AS_fnc_deleteRoadblock} forEach controles;
			if !("CONVOY" in misiones) then {
				_base = [_city] call AS_fnc_findBaseForConvoy;
				if ((_base != "") AND (random 3 < 1)) then {
					[_city,_base,"city"] remoteExec ["CONVOY", call AS_fnc_getNextWorker];
				};
			};
		};

		if ((_supportEnemy > _supportFIA) AND (_city in mrkFIA)) then {
			[_city,{["TaskFailed", ["", format [localize "STR_NTS_JOINAAF",[_this, false] call AS_fnc_location]]] call BIS_fnc_showNotification}] remoteExec ["call", 0];
			mrkAAF = mrkAAF + [_city];
			mrkFIA = mrkFIA - [_city];
			publicVariable "mrkAAF";
			publicVariable "mrkFIA";
			[0,0] remoteExec ["prestige",2];
			_mrkD = format ["Dum%1",_city];
			_mrkD setMarkerColor IND_marker_colour;
			sleep 5;
			if (_power) then {_power = false} else {_power = true};
			[_city,_power] spawn AS_fnc_adjustLamps;
		};
	} forEach ciudades;

	if (countSupplyCrates < 6) then
	{
		_cityDecreased = false;
		for "_i" from 0 to 4 do
		{
			_currentCity = selectRandom _cityInRange;
			_types = [_currentCity, "GOOD"] call AS_fnc_getHighSupplies;
			if (random 100 < 10) then {_types = [_currentCity, "LOW"] call AS_fnc_getHighSupplies};
			if ( count _types != 0 AND !_cityDecreased ) then {
				_cityDecreased = true;
				_type = selectRandom _types;

                [_type, -1, _currentCity] remoteExec ["AS_fnc_changeCitySupply", 2];
			};
		};
		_passedtype = selectRandom["FOOD", "WATER", "FUEL"];
		[[], _passedtype] remoteExec ["createSupplyBox", call AS_fnc_getNextWorker];
	};


	if ((_popFIA > _popEnemy) AND ("airport_3" in mrkFIA)) then {["end1",true,true,true,true] remoteExec ["BIS_fnc_endMission",0]};

	{
		_factory = _x;
		_power = [_factory] call AS_fnc_powerCheck;
		if (_power AND !(_factory in destroyedCities)) then {
			if (_factory in mrkFIA) then {_bonusFIA = _bonusFIA + 0.25};
			if (_factory in mrkAAF) then {_bonusEnemy = _bonusEnemy + 0.25};
		};
	} forEach fabricas;

	{
		_resource = _x;
		_power = [_resource] call AS_fnc_powerCheck;

		if !(_resource in destroyedCities) then {
			if (_power) then {
				if (_resource in mrkFIA) then {_incomeFIA = _incomeFIA + (300 * _bonusFIA)};
				if (_resource in mrkAAF) then {_incomeEnemy = _incomeEnemy + (300 * _bonusEnemy)};
			} else {
				if (_resource in mrkFIA) then {_incomeFIA = _incomeFIA + (100 * _bonusFIA)};
				if (_resource in mrkAAF) then {_incomeEnemy = _incomeEnemy + (100 * _bonusEnemy)};
			};
		};
	} forEach recursos;

	if (server getVariable ["easyMode",false]) then {
		_hrFIA = _hrFIA * 2;
		_incomeFIA = _incomeFIA * 1.5;
	};

	_hrFIA = (round _hrFIA);
	_incomeFIA = (round _incomeFIA);

	// BE module
	if (activeBE) then {
		if (_hrFIA > 0) then {
			_hrFIA = _hrFIA min (["HR"] call fnc_BE_permission);
		};
	};
	// BE module

	_text = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €",_hrFIA,_incomeFIA];
	if !(activeJNA) then {
		_updated = [] call AS_fnc_updateArsenal;
		if (count _updated > 0) then {_text = format ["%1<br/>Arsenal Updated<br/><br/>%2",_text,_updated]};
	};

	[[petros,"taxRep",_text],"commsMP"] call BIS_fnc_MP;

	_hrFIA = _hrFIA + (server getVariable ["hr",0]);
	_incomeFIA = _incomeFIA + (server getVariable ["resourcesFIA",0]);

	if !(activeBE) then {
		if (_hrFIA > 100) then {_hrFIA = 100}; // HR capped to 100
	};

	server setVariable ["hr",_hrFIA,true];
	server setVariable ["resourcesFIA",_incomeFIA,true];
	_resourcesAAF = server getVariable ["resourcesAAF",0];
	if (isMultiplayer) then {_resourcesAAF = _resourcesAAF + (round (_incomeEnemy + (_incomeEnemy * ((server getVariable "prestigeCSAT")/100))))} else {_resourcesAAF = _resourcesAAF + (round _incomeEnemy)};
	server setVariable ["resourcesAAF",_resourcesAAF,true];
	if (isMultiplayer) then {[] spawn assignStavros};
	if (!("AtaqueAAF" in misiones) AND (random 100 < 50)) then {[] call missionRequestAUTO};
	if (AAFpatrols < 3) then {[] remoteExec ["genRoadPatrol", call AS_fnc_getNextWorker]};

	/* Remove static auto rearm 28.07.2017 Sparker
	{
		_vehicle = _x;
		if ((_vehicle isKindOf "StaticWeapon") AND ({isPlayer _x} count crew _vehicle == 0) AND (alive _vehicle)) then {
			_vehicle setDamage 0;
			[_vehicle,1] remoteExec ["setVehicleAmmoDef",_vehicle];
		};
	} forEach vehicles;
	*/
	cuentaCA = cuentaCA - 600;
	publicVariable "cuentaCA";
	if ((cuentaCA < 1) AND (diag_fps > minimoFPS) AND ((count allUnits) < 170)) then { //If there are not too many units on the map already, 17/08 Stef increased from 150 to 170

		[1200] remoteExec ["AS_fnc_increaseAttackTimer",2];
		if ((count mrkFIA > 0) AND !("AtaqueAAF" in misiones) AND !(server getVariable ["waves_active",false])) then {
			_script = [] spawn AS_fnc_spawnAttack;
			waitUntil {sleep 5; scriptDone _script};
		};
	};

    sleep 3;
	diag_log "resourcecheck.sqf: calling AAFEconomics";
	call AAFeconomics;
	sleep 4;
	[] call AS_fnc_FIAradio;
    diag_log "resourcecheck.sqf: calling FIAradio";

	if (_oneIteration) exitWith {};
};
