private ["_muerto","_killer","_coste","_enemy","_grupo"];
_muerto = _this select 0;
_killer = _this select 1;
if (_muerto getVariable ["OPFORSpawn",false]) then {_muerto setVariable ["OPFORSpawn",nil,true]};
[_muerto] spawn postmortem;

if (activeACE) then {
	if ((isNull _killer) || (_killer == _muerto)) then {
		_killer = _muerto getVariable ["ace_medical_lastDamageSource", _killer];
	};
};

if ((side _killer == side_blue) || (captive _killer)) then {
	if (activeBE) then {["kill"] remoteExec ["fnc_BE_XP", 2]};
	_grupo = group _muerto;
	if (isPlayer _killer) then {
		[2,_killer,true] call playerScoreAdd;

		if ((captive _killer) && (_killer distance _muerto < 300)) then {
			[_killer,false] remoteExec ["setCaptive",_killer];
		};
	} else {
		_skill = skill _killer;
		[_killer,_skill + 0.05] remoteExec ["setSkill",_killer];
	};
	if (vehicle _killer isKindOf "StaticMortar") then {
		if (isMultiplayer) then {
			{
				if ((_x distance _muerto < 300) and (captive _x)) then {[_x,false] remoteExec ["setCaptive",_x]};
			} forEach playableUnits;
		} else {
			if ((player distance _muerto < 300) and (captive player)) then {player setCaptive false};
		};
	};
	if (count weapons _muerto < 1) then {
		[-1,0] remoteExec ["prestige",2];
		[2,0,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2];
		if (isPlayer _killer) then {_killer addRating -1000};
	} else {
		_coste = server getVariable (typeOf _muerto);
		if (isNil "_coste") then {diag_log format ["Falta incluir a %1 en las tablas de coste",typeOf _muerto]; _coste = 0};
		[-_coste] remoteExec ["resourcesAAF",2];
		[-0.5,0,getPos _muerto] remoteExec ["AS_fnc_changeCitySupport",2];
	};

	{
		if (alive _x) then {
			if (fleeing _x) then {
				if !(_x getVariable ["surrendered",false]) then {
					if (([100,1,_x,"BLUFORSpawn"] call distanceUnits) and (vehicle _x == _x)) then {
						[_x] spawn surrenderAction;
					} else {
						if (_x == leader group _x) then {
							if (random 1 < 0.1) then {
								_enemy = _x findNearestEnemy _x;
								if (!isNull _enemy) then {
									[position _enemy] remoteExec ["patrolCA",HCattack];
								};
							};
						};
					[_x,_x] spawn cubrirConHumo;
					};
				};
			} else {
				if (random 1 < 0.5) then {_x allowFleeing (0.5 -(_x skill "courage") + (({(!alive _x) or (_x getVariable ["surrendered",false])} count units _grupo)/(count units _grupo)))};
			};
		};
	} forEach units _grupo;

	//Test the WarStatistics script. Sparker.
	_posMuerto = getPos _muerto;
	[ws_grid, _posMuerto select 0, _posMuerto select 1, 1] call ws_fnc_addValue;
};