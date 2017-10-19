if !(isPlayer Slowhand) exitWith {};

params ["_veh"];
private _tipo = typeOf _veh;

call {
	if ((_tipo in vehAPC) || (_tipo in vehIFV)) exitWith {
		APCAAFcurrent = APCAAFcurrent -1;
		if (APCAAFcurrent < 1) then {
			APCAAFcurrent = 0;
			enemyMotorpool = enemyMotorpool - vehAPC - vehIFV;
			publicVariable "enemyMotorpool";
		};
		publicVariable "APCAAFcurrent";
	};
	if (_tipo in vehTank) exitWith {
		tanksAAFcurrent = tanksAAFcurrent -1;
		if (tanksAAFcurrent < 1) then {
			tanksAAFcurrent = 0;
			enemyMotorpool = enemyMotorpool - vehTank;
			publicVariable "enemyMotorpool";
		};
		publicVariable "tanksAAFcurrent";
	};
	if (_veh isKindOf "Helicopter") exitWith {
		helisAAFcurrent = helisAAFcurrent -1;
		if (helisAAFcurrent < 1) then {
			helisAAFcurrent = 0;
			indAirForce = indAirForce - heli_armed;
			publicVariable "indAirForce";
		};
		publicVariable "helisAAFcurrent";
	};
	if (_tipo in planes) exitWith {
		planesAAFcurrent = planesAAFcurrent -1;
		if (planesAAFcurrent < 1) then {
			planesAAFcurrent = 0;
			indAirForce = indAirForce - planes;
				publicVariable "indAirForce";
		};
		publicVariable "planesAAFcurrent";
	};
};