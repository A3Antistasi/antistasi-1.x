[campsFIA + [guer_respawn],false,true,false,false,false,false] params ["_targetLocations","_isHC","_travelAlone","_enemiesNearGroup","_break","_playersInGroup","_forceSpawn"];

private ["_group","_groupLeader","_enemy","_targetPosition","_position","_distance","_unit"];

if (count hcSelected player > 1) exitWith {hintSilent localize "STR_HINTS_FT_SINGLEGROUP"};

if (count hcSelected player == 1) then {
	_group = hcSelected player select 0;
	_isHC = true
} else {
	_group = group player;
};

_groupLeader = leader _group;

if ((_groupLeader != player) and !_isHC) then {
	_travelAlone = true;
};

if (player != player getVariable ["owner",player]) exitWith {hint localize "STR_HINTS_FT_TEMPAI"};

{
	_enemy = _x;
	{
		if (((side _enemy == side_red) OR (side _enemy == side_green)) AND (_enemy distance _x < safeDistance_fasttravel) AND !(captive _enemy)) exitWith {_enemiesNearGroup = true};
	} forEach units _group;
	if (_enemiesNearGroup) exitWith {};
} forEach allUnits;

if (_isHC AND _enemiesNearGroup) exitWith {hintSilent localize "STR_HINTS_FT_ENEMIES"};

if (_groupLeader == player) then {
	{
		if ((group _x == group player) AND (_x != player)) exitWith {
			_playersInGroup = true;
		};
	} forEach allPlayers - entities "HeadlessClient_F";
};

{
	if (((side _x == side_red) OR (side _x == side_green)) AND (player distance _x < safeDistance_fasttravel) AND !(captive _x)) exitWith {_break = true};
} foreach allUnits;

if (_break) exitWith {hintSilent localize "STR_HINTS_FT_ENEMIES_PERS"};

{
	if !(canMove vehicle _x) then {
		if !(vehicle _x isKindOf "StaticWeapon") then {_break = true};
	}
} forEach units _group;

if (_break) exitWith {hintSilent localize "STR_HINTS_FT_DAMAGE"};

_transportUnit = {
	params ["_ftPos",["_unit",player],["_isVehicle",false]];

	if (_isVehicle) then {
		{
			_x allowDamage false;
		} forEach crew _unit;
		_tam = 10;
		_roads = [];
		while {true} do {
			_roads = _ftPos nearRoads _tam;
			if (count _roads < 1) then {_tam = _tam + 10};
			if (count _roads > 0) exitWith {};
		};
		_road = _roads select 0;
		_ftPos = position _road;
	} else {
		_unit allowDamage false;
	};
	_ftPos = _ftPos findEmptyPosition [1, 50, typeOf _unit];
	if !(isNil {_unit getVariable "inconsciente"}) then {
		if !(_unit getVariable "inconsciente") then {
			_ftPos = _ftPos findEmptyPosition [1, 50, typeOf _unit];
			_unit setPosATL _ftPos;
		};
	} else {
		_ftPos = _ftPos findEmptyPosition [1, 50, typeOf _unit];
		_unit setPosATL _ftPos;
	};
};

targetPosition = [];
if (_isHC) then {hcShowBar false};
hint localize "STR_HINTS_FT_TARGET";
openMap true;
onMapSingleClick "targetPosition = _pos;";

waitUntil {sleep 1; (count targetPosition > 0) or !(visiblemap)};
onMapSingleClick "";

_targetPosition = targetPosition;

if (count _targetPosition > 0) then {
	_marker = [_targetLocations, _targetPosition] call BIS_Fnc_nearestPosition;

	if (_marker in mrkAAF) exitWith {hintSilent localize "STR_HINTS_FT_MARKER"; openMap [false, false]};

	{
		if (((side _x == side_red) OR (side _x == side_green)) AND (_x distance (getMarkerPos _marker) < safeDistance_fasttravel) AND !(captive _x)) then {_break = true};
	} forEach allUnits;

	if (_break) exitWith {Hint localize "STR_HINTS_FT_ATTACK"; openMap [false,false]};

	if (_targetPosition distance getMarkerPos _marker < 50) then {
		_position = [getMarkerPos _marker, 10, random 360] call BIS_Fnc_relPos;
		_distance = round (((position player) distance _position)/200);
		if (!_isHC) then {
			disableUserInput true;
			cutText ["Fast traveling, please wait","BLACK",2];
			sleep 2;
		} else {
			hcShowBar false;
			hcShowBar true;
			hint format ["Moving group %1 to destination",groupID _group];
			sleep _distance;
		};

		_forceSpawn = false;
		if !(isMultiplayer) then {
			if !(_marker in forcedSpawn) then {
				_forceSpawn = true;
				forcedSpawn pushBack _marker;
			};
		};

		if (!_isHC) then {
			sleep _distance;
		};

		if ((_marker in campsFIA) AND (random 10 < 1) AND !(captive player)) then {
			[_marker] remoteExec ["DEF_Camp",HCattack];
			[format ["Camp under attack: %1", _marker]] remoteExec ["AS_fnc_logOutput", 2];
		};

		_proximityCheck = {
			params ["_unit"];
			[false] params ["_break"];
			{
				if !(((side _x == side_red) OR (side _x == side_green)) AND (_unit distance _x < safeDistance_fasttravel) AND !(captive _x)) exitWith {_break = true};
			} forEach allUnits;
			_break
		};

		// UNIT BLOCK
		_handleUnit = {
			params ["_unit","_position","_danger"];
			private ["_vehicle"];

			if (vehicle _unit != _unit) then {
				// MOUNTED
				_vehicle = vehicle _unit;
				if (driver _vehicle == _unit) then {
					// DRIVER
					if (_danger) then {
						// ENEMIES NEAR GROUP
						if ([_unit] call _proximityCheck) exitWith {diag_log format ["%1 cannot fast-travel, enemies nearby", _unit]};
						/*if (count (crew _vehicle arrayIntersect allPlayers) > 0) then {
							// HUMANS ABOARD
							{
								if ((_x in (crew _vehicle)) AND !(group _x == group _unit)) then {moveOut _x};
							} forEach allPlayers;
						};*/
					} else {
						// CLEAR
						/*if (count (crew _vehicle arrayIntersect allPlayers) > 0) then {
							// HUMANS ABOARD
							{
								if ((_x in (crew _vehicle)) AND !(group _x == group _unit)) then {moveOut _x};
							} forEach allPlayers;
						};*/
					};
					[_position, _vehicle, true] call _transportUnit;

				} else {
					// PASSENGER
					if (_danger) then {
						// ENEMIES NEAR GROUP
						if ([_unit] call _proximityCheck) exitWith {diag_log format ["%1 cannot fast-travel, enemies nearby", _unit]};

						if (isNull (driver _vehicle)) then {
							// NO DRIVER
							if (vehicle _groupLeader == _vehicle) exitWith {}; // GROUP LEADER IN VEHICLE
						} else {
							if (group (driver _vehicle) != group _unit) then {
								// DRIVER NOT IN SAME GROUP
								moveOut _unit;
								[_position, _unit] call _transportUnit;
							};
						};

					} else {
						// CLEAR
						if (isNull (driver _vehicle)) then {
							// NO DRIVER
							if (vehicle _groupLeader == _vehicle) exitWith {}; // GROUP LEADER IN VEHICLE
							moveOut _unit;
							[_position, _unit] call _transportUnit;
						} else {
							if (group (driver _vehicle) != group _unit) then {
								// DRIVER NOT IN SAME GROUP
								moveOut _unit;
								[_position, _unit] call _transportUnit;
							};
						};
					};
				};
			} else {
				// ON FOOT
				if (_danger) then {
					// ENEMIES NEAR GROUP
					if ([_unit] call _proximityCheck) exitWith {diag_log format ["%1 cannot fast-travel, enemies nearby", _unit]};
					[_position, _unit] call _transportUnit;
				} else {
					[_position, _unit] call _transportUnit;
				};
			};
		};

		call {
			if (_isHC) exitWith {
				{
					_unit = _x;
					_unit allowDamage false;
					if !(_unit == vehicle _unit) then {
						if (driver vehicle _unit == _unit) then {
							sleep 3;

							[_position, vehicle _unit, true] call _transportUnit;
						};
						if ((vehicle _unit isKindOf "StaticWeapon") and !(isPlayer (leader _unit))) then {
							[_position, vehicle _unit] call _transportUnit;
						};
					} else {
						if (!isNil {_unit getVariable "inconsciente"}) then {
							if (!(_unit getVariable "inconsciente")) then {
								[_position, _unit] call _transportUnit;
								if (isPlayer leader _unit) then {_unit setVariable ["rearming",false]};
								_unit doWatch objNull;
								_unit doFollow leader _unit;
							};
						} else {
							[_position, _unit] call _transportUnit;
						};
					};
				} forEach units _group;
			};

			if (vehicle player != player) then {
				// PLAYER MOUNTED
				_playerVehicle = vehicle player;

				if (driver _playerVehicle == player) then {
					// PLAYER IS DRIVER
					[_position, _playerVehicle, true] call _transportUnit;
					{
						[_x, _position, _enemiesNearGroup] call _handleUnit;
					} forEach (units _group) - allPlayers;

				} else {
					// PLAYER IS PASSENGER
					call {
						if (isNull (driver _playerVehicle)) exitWith {
							// NO DRIVER
							moveOut player;
							{
								[_x, _position, _enemiesNearGroup] call _handleUnit;
							} forEach ((units _group) - allPlayers + [player]);
						};

						if (driver _playerVehicle in allPlayers) exitWith {
							// DRIVER IS HUMAN
							moveOut player;
							[_position, player] call _transportUnit;
							{
								[_x, _position, _enemiesNearGroup] call _handleUnit;
							} forEach (units _group) - allPlayers;
						};

						if !(driver _playerVehicle in allPlayers) exitWith {
							// DRIVER IS AI
							{
								[_x, _position, _enemiesNearGroup] call _handleUnit;
							} forEach ((units _group) - allPlayers + [player]);
						};
					};
				};

			} else {
				// PLAYER ON FOOT
				{
					[_x, _position, _enemiesNearGroup] call _handleUnit;
				} forEach ((units _group) - allPlayers + [player]);
			};
		};

		if (!_isHC) then {
			disableUserInput false;
			cutText ["You arrived at your destination.","BLACK IN",3];
		} else {
			hint format ["Group %1 arrived at their destination.", groupID _group]};
		if (_forceSpawn) then {
			forcedSpawn = forcedSpawn - [_marker];
		};
		sleep 5;
		{_x allowDamage true} forEach units _group;
	} else {
		Hint localize "STR_HINTS_FT_TARGET_FAIL";
	};
};
openMap false;