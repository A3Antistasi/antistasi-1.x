if (!isServer) exitWith {};

#define gear_threshold [125,175]

params [["_type","LOG"],["_muted",false],["_manual",false]];
[getMarkerPos guer_respawn,[],[],false] params ["_positionHQ","_options","_zones"];

private ["_currentZone","_markerPos","_nearestZone","_gearCount","_threshold","_base","_data","_prestigeOPFOR","_prestigeBLUFOR"];

if (_type in misiones) exitWith {
	if (!_muted) then {
		[petros,"globalChat",localize "STR_HINTS_MIS_TYPE_ACTIVE"] remoteExec ["commsMP",[0,-2] select isDedicated];
	};
};

call {
	if (_type == "DES") exitWith {
		_zones = ciudades + antenas - mrkFIA;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;
				if (_currentZone in markers) then {
					_markerPos = getMarkerPos _currentZone;
				} else {
					_markerPos = getPos _currentZone;
				};

				if (_markerPos distance _positionHQ < 4000) then {
					if (_currentZone in markers) then {
						if !(spawner getVariable _currentZone) then {_options pushBackUnique _currentZone};
					} else {
						_nearestZone = [markers, getPos _currentZone] call BIS_fnc_nearestPosition;
						if (_nearestZone in mrkAAF) then {_options pushBackUnique _currentZone};
					};
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_DES_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_DES_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			if (_currentZone in antenas) then {[_currentZone, "mil"] remoteExec ["DES_Antena",HCgarrisons]};
			if (_currentZone in ciudades) then {
				[_currentZone, "mil"] remoteExec [([["DES_fuel","DES_EnemySuppression"],[0.5,0.5]] call BIS_fnc_selectRandomWeighted),HCgarrisons]};
		};
	};

	if (_type == "LOG") exitWith {
		_zones = puestos + ciudades - ["puesto_13"];
		if (random 100 < 20) then {_zones = _zones + bancos};
		_zones = _zones - mrkFIA;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;
				if (_currentZone in markers) then {
					_markerPos = getMarkerPos _currentZone;
				} else {
					_markerPos = getPos _currentZone;
				};

				if (_markerPos distance _positionHQ < 4000) then {
					if (_currentZone in ciudades) then {
						_options pushBackUnique _currentZone;
					} else {
						if (_currentZone in puestos) then {
							_gearCount = (count unlockedWeapons) + (count unlockedMagazines) + (count unlockedItems) + (count unlockedBackpacks);
							_threshold = gear_threshold select activeACE;
							if (_gearCount < _threshold) then {_options pushBackUnique _currentZone};
						} else {
							_options pushBackUnique _currentZone;
						};
					};
				};

				if (_currentZone in bancos) then {
					_nearestZone = [ciudades, _markerPos] call BIS_fnc_nearestPosition;
					if (_nearestZone in mrkFIA) then {_options pushBackUnique _currentZone};
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_LOG_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_LOG_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;

			call {
				if (_currentZone in ciudades) exitWith {
					[_currentZone] remoteExec [([["LOG_Suministros","LOG_Medical"],[0.5,0.5]] call BIS_fnc_selectRandomWeighted),HCgarrisons]
				};
				if (_currentZone in puestos) exitWith {
					[_currentZone] remoteExec ["LOG_Ammo",HCgarrisons];
				};
				if (_currentZone in bancos) then {
					[_currentZone] remoteExec ["LOG_Bank",HCgarrisons];
				};
			};
		};
	};

	if (_type == "RES") exitWith {
		_zones = ciudades + bases + puestos - mrkFIA;
		if (_manual) then {_zones = ciudades - mrkFIA};

		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;
				_markerPos = getMarkerPos _currentZone;
				if (_currentZone in ciudades) then {
					if (_markerPos distance _positionHQ < 4000) then {
						_options pushBackUnique _currentZone;
					};
				} else {
					if ((_markerPos distance _positionHQ < 4000) AND !(spawner getVariable _currentZone)) then {
						_options pushBackUnique _currentZone;
					};
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_RES_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_RES_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			[_currentZone] remoteExec [(["RES_Prisioneros","RES_Refugiados"] select (_currentZone in ciudades)),HCgarrisons];
		};
	};

	if (_type == "FND_M") exitWith {
		_zones = ciudades - mrkFIA;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;

				if (_currentZone in markers) then {
					_markerPos = getMarkerPos _currentZone;
				} else {
					_markerPos = getPos _currentZone;
				};

				if (_markerPos distance _positionHQ < 4000) then {
						_options pushBackUnique _currentZone;
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_FND_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_FND_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			[_currentZone] remoteExec ["FND_MilCon", 2];
		};
	};

	if (_type == "FND_C") exitWith {
		_zones = ciudades - mrkFIA;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;

				if (_currentZone in markers) then {
					_markerPos = getMarkerPos _currentZone;
				} else {
					_markerPos = getPos _currentZone;
				};

				if (_markerPos distance _positionHQ < 4000) then {
						_options pushBackUnique _currentZone;
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_FND_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_FND_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			[_currentZone] remoteExec ["FND_CivCon", 2];
		};
	};

	if (_type == "FND_E") exitWith {
		_zones = ciudades;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;

				if (_currentZone in markers) then {
					_markerPos = getMarkerPos _currentZone;
				}
				else {
					_markerPos = getPos _currentZone;
				};
				if (_markerPos distance _positionHQ < 4000) then {
						_options pushBackUnique _currentZone;
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_FNDE_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_FNDE_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			[_currentZone] remoteExec ["FND_ExpDealer", 2];
		};
	};

	if (_type == "CONVOY") exitWith {
		_zones = ciudades - mrkFIA;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;
				_markerPos = getMarkerPos _currentZone;
				_base = [_currentZone] call AS_fnc_findBaseForConvoy;
				if ((_markerPos distance _positionHQ < 4000) AND (_base !="")) then {
					_options pushBackUnique _currentZone;
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_CVY_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_CVY_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			_base = [_currentZone] call AS_fnc_findBaseForConvoy;
			[_currentZone,_base,"auto"] remoteExec ["CONVOY",HCgarrisons];
		};
	};

	if (_type == "ASS") exitWith {
		_zones = ciudades + puestos - mrkFIA;
		if (count _zones > 0) then {
			for "_i" from 0 to ((count _zones) - 1) do {
				_currentZone = _zones select _i;
				_markerPos = getMarkerPos _currentZone;
				if ((_markerPos distance _positionHQ < 4000) AND !(spawner getVariable _currentZone)) then {
					_options pushBackUnique _currentZone;
				};
			};
		};

		if (count _options == 0) then {
			if (!_muted) then {
				[petros,"globalChat",localize "STR_HINTS_MIS_ASS_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				[petros,"hint",localize "STR_HINTS_MIS_ASS_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
			};
		} else {
			_currentZone = selectRandom _options;
			[_currentZone, "civ"] remoteExec [(["ASS_Traidor","AS_forest"] select (_currentZone in puestos)),HCgarrisons];
		};
	};

	if (_type == "PR") exitWith {
		[[],[]] params ["_optionsPamphlet","_optionsBrainwash"];

		if (_manual) then {
			_zones = ciudades - mrkFIA;
			if (count _zones > 0) then {
				for "_i" from 0 to ((count _zones) - 1) do {
					_currentZone = _zones select _i;

					if (_currentZone in markers) then {
						_markerPos = getMarkerPos _currentZone;
					} else {
						_markerPos = getPos _currentZone;
					};

					if (_markerPos distance _positionHQ < 4000) then {
						_data = server getVariable _currentZone;
						_prestigeOPFOR = _data select 2;
						_prestigeBLUFOR = _data select 3;
						if (_prestigeOPFOR > 0) then {
							_optionsPamphlet pushBackUnique _currentZone;
						};
						if (_prestigeBLUFOR > 10) then {
							_optionsBrainwash pushBackUnique _currentZone;
						};
					};
				};
			};

			[_optionsPamphlet, _optionsBrainwash] remoteExec ["missionSelect", Slowhand];
		} else {
			_zones = ciudades - mrkFIA;
			if (count _zones > 0) then {
				for "_i" from 0 to ((count _zones) - 1) do {
					_currentZone = _zones select _i;
					if (_currentZone in markers) then {
						_markerPos = getMarkerPos _currentZone;
					}
					else {
						_markerPos = getPos _currentZone;
					};
					if (_markerPos distance _positionHQ < 4000) then {
						_options pushBackUnique _currentZone;
					};
				};
			};

			if (count _options == 0) then {
				if (!_muted) then {
					[petros,"globalChat",localize "STR_HINTS_MIS_PR_NO_CHAT"] remoteExec ["commsMP",[0,-2] select isDedicated];
					[petros,"hint",localize "STR_HINTS_MIS_PR_NO_HINT"] remoteExec ["commsMP",[0,-2] select isDedicated];
				};
			} else {
				_currentZone = selectRandom _options;
				[_currentZone] remoteExec ["PR_Pamphlet",HCgarrisons];
			};
		};
	};
};

if ((count _options > 0) AND (!_muted)) then {
	[petros,"globalChat",localize "STR_HINTS_MIS_GIVEN"] remoteExec ["commsMP",[0,-2] select isDedicated];
};