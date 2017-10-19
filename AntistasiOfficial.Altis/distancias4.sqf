if (!isServer) exitWith{};

debugperf = false;

private ["_tiempo","_locationes","_mrkNATO","_mrkSDK","_location","_position"];

_tiempo = time;

while {true} do {
	//sleep 0.01;
	if (time - _tiempo >= 0.5) then {sleep 0.1} else {sleep 0.5 - (time - _tiempo)};
	if (debugperf) then {hint format ["Tiempo transcurrido: %1 para %2 marcadores", time - _tiempo, count marcadores]};
	_tiempo = time;

	waitUntil {!isNil "stavros"};

	_greenfor = [];
	_blufor = [];
	_opfor = [];

	{
	if (_x getVariable ["GREENFORSpawn",false]) then
		{
		_greenfor pushBack _x;
		/*
		if (isPlayer _x) then
			{
			if (!isNull (getConnectedUAV _x)) then
				{
				_greenfor pushBack (getConnectedUAV _x);
				};
			};
		*/
		}
	else
		{
		if (_x getVariable ["BLUFORSpawn",false]) then
			{
			_blufor pushBack _x;
			}
		else
			{
			if (_x getVariable ["OPFORSpawn",false]) then
				{
				_opfor pushBack _x;
				};
			};
		}
	} forEach allUnits;

	{//foreach markers
		_location = _x;

		_position = getMarkerPos (_location);

		if (_location in mrkNATO) then{
			if (spawner getVariable _location != 0) then{
				if (spawner getVariable _location == 2) then{
					if (
					    ({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor > 0) or
					    ({if ((_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _opfor > 0) or
					    ({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _blufor > 0) or
					    (_location in forcedSpawn)
					)then{
						spawner setVariable [_location,0,true];
						if (_location in ciudades) then{

							if(
								({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor > 0) or
								({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _blufor > 0) or
								(_location in forcedSpawn)
							)then {
								[_location] remoteExec ["createAIciudades",HCGarrisons]
							};

							if (not(_location in destroyedCities)) then{
								if(
									({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN)) exitWith {1};false} count allUnits > 0) or
									(_location in forcedSpawn)
								)then{
									[_location] remoteExec ["createCIV",HCciviles]
								};
							};
						}else{
							if (_location in controles) then {[_location] remoteExec ["createAIcontroles",HCGarrisons]} else {
							if (_location in aeropuertos) then {[_location] remoteExec ["createAIaerop",HCGarrisons]} else {
							if (((_location in recursos) or (_location in fabricas))) then {[_location] remoteExec ["createAIrecursos",HCGarrisons]} else {
							if ((_location in puestos) or (_location in puertos)) then {[_location] remoteExec ["createAIpuestos",HCGarrisons]};};};};
						};
					};
				}else{
					if (({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _opfor > 0) or ({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _blufor > 0) or (_location in forcedSpawn)) then
						{
						spawner setVariable [_location,0,true];
						if (isMUltiplayer) then
							{
							{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
							}
						else
							{
							{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
							};
					}else{
						if (({if (_x distance2D _position < distanciaSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _position < distanciaSPWN)) exitWith {1}} count _opfor == 0) and ({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN)) exitWith {1}} count _blufor == 0) and (not(_location in forcedSpawn))) then
							{
							spawner setVariable [_location,2,true];
							};
					};
				};
			}else{
				if(
					({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor == 0) and
					({if ((_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _opfor == 0) and
					({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _blufor == 0) and
					(not(_location in forcedSpawn))
				)then{
					spawner setVariable [_location,1,true];
					if (isMUltiplayer) then{
						{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
					}else{
						{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
					};
				};
			};
		}else{
			if (_location in mrkSDK) then{
				if (spawner getVariable _location != 0) then{
					if (spawner getVariable _location == 2) then{
						if (
							({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _blufor > 0) or
							({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _opfor > 0) or
							({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _greenfor > 0) or
							(_location in forcedSpawn)
						)then{

							spawner setVariable [_location,0,true];

							if (_location in ciudades) then{
								//[_location] remoteExec ["createAIciudades",HCGarrisons];
								if (not(_location in destroyedCities)) then{
									if (({if ((isPlayer _x) and (_x distance2D _position < distanciaSPWN)) exitWith {1};false} count allUnits > 0) or (_location in forcedSpawn))
									then {
										[_location] remoteExec ["createCIV",HCciviles]
									};
								};
							};

							if (_location in puestosFIA) then {[_location] remoteExec ["createFIApuestos2",HCGarrisons]} else {if (not(_location in controles)) then {[_location] remoteExec ["createSDKGarrisons",HCGarrisons]}};
							};
					}else{
						if (({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _blufor > 0) or ({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _opfor > 0) or ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _position < distanciaSPWN2) or (_location in forcedSpawn)) exitWith {1}} count _greenfor > 0)) then
							{
							spawner setVariable [_location,0,true];
							if (isMUltiplayer) then
								{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
								}
							else
								{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
								};
							}
						else
							{
							if (({if (_x distance2D _position < distanciaSPWN1) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _position < distanciaSPWN1) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _position < distanciaSPWN)) exitWith {1}} count _greenfor == 0) and (not(_location in forcedSpawn))) then
								{
								spawner setVariable [_location,2,true];
								};
							};
						};
				}else{
					if (({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _blufor == 0) and ({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _opfor == 0) and ({if (((_x getVariable ["owner",objNull]) == _x) and (_x distance2D _position < distanciaSPWN2)) exitWith {1}} count _greenfor == 0) and (not(_location in forcedSpawn))
					)then{
						spawner setVariable [_location,1,true];
						if (isMUltiplayer) then{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
						}else{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
						};
					};
				};
			}else{
				if (spawner getVariable _location != 0) then{
					if (spawner getVariable _location == 2) then
						{
						if (({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _position < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if (_x distance2D _position < distanciaSPWN2) exitWith {1}} count _blufor > 0) or (_location in forcedSpawn)) then
							{
							spawner setVariable [_location,0,true];
							if (_location in controles) then {[_location] remoteExec ["createAIcontroles",HCGarrisons]} else {
							if (_location in aeropuertos) then {[_location] remoteExec ["createAIaerop",HCGarrisons]} else {
							if (((_location in recursos) or (_location in fabricas))) then {[_location] remoteExec ["createAIrecursos",HCGarrisons]} else {
							if ((_location in puestos) or (_location in puertos)) then {[_location] remoteExec ["createAIpuestos",HCGarrisons]};};};};
							};
					}else{
						if (({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor > 0) or ({if ((_x distance2D _position < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor > 0) or ({if (_x distance2D _position < distanciaSPWN2) exitWith {1}} count _blufor > 0) or (_location in forcedSpawn)) then
							{
							spawner setVariable [_location,0,true];
							if (isMUltiplayer) then
								{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulationGlobal true}}} forEach allUnits;
								}
							else
								{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulation true}}} forEach allUnits;
								};
						}else{
							if (({if (_x distance2D _position < distanciaSPWN1) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _position < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if ((_x distance2D _position < distanciaSPWN)) exitWith {1}} count _blufor == 0) and (not(_location in forcedSpawn)))
							then{
								spawner setVariable [_location,2,true];
							};
						};
					};
				}else{
					if (({if (_x distance2D _position < distanciaSPWN) exitWith {1}} count _greenfor == 0) and ({if ((_x distance2D _position < distanciaSPWN2) and (isPlayer _x)) exitWith {1}} count _opfor == 0) and ({if (_x distance2D _position < distanciaSPWN2) exitWith {1}} count _blufor == 0) and (not(_location in forcedSpawn))) then{
							spawner setVariable [_location,1,true];

							if (isMUltiplayer) then{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulationGlobal false}}} forEach allUnits;
							}else{
								{if (_x getVariable ["marcador",""] == _location) then {if (vehicle _x == _x) then {_x enableSimulation false}}} forEach allUnits;
							};
						};
					};
				};
		};

	} forEach marcadores;

};//end while{true}