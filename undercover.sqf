if (player != player getVariable ["owner",player]) exitWith {hint localize "STR_HINTS_UND_SINGLEGROUP"};
if (captive player) exitWith {hint localize "STR_HINTS_UND_DISGUISED"};


["",false] params ["_reason","_spotted"];
private ["_milThreatGround","_milThreatAir","_civVehicles","_size","_compromised","_base","_size","_vehicle","_vehicleType","_break"];

//_milThreatGround = (bases + puestos + controles) arrayIntersect mrkAAF; //Sparker: allow players to go through roadblocks undercover
_milThreatGround = (bases + puestos) arrayIntersect mrkAAF;
_milThreatAir = (bases + aeropuertos + puestos + colinas) arrayIntersect mrkAAF;
_compromised = player getVariable ["compromised",dateToNumber date];

/*
	Add vehicles to the Array above to allow them to be used as Undercover.
	Ideal for hand-placed objects that you don't want spawning as traffic.
	Vehicles you want added as traffic should be added to CIV_vehicles.
*/
_civVehicles = CIV_vehicles + [civHeli] +
	[
		"C_Rubberboat",				// Civ. Zodiac
		"C_Boat_Civil_01_F",		// Speedboat
		"C_Boat_Civil_01_rescue_F",	// Rescue Speedboat
		"C_Boat_Civil_01_police_F",	// Police Speedboat
		"C_Scooter_Transport_01_F",	// Jetski
		"C_Boat_Transport_02_F"		// RHIB transport boat
	];

_fnc_compromiseVehicle = {
	params ["_player"];
	{
		if ((isPlayer _x) AND (captive _x)) then {
			[_x,false] remoteExec ["setCaptive",_x];
			reportedVehs pushBackUnique (vehicle _player);
			publicVariable "reportedVehs";
		};
	} forEach ((crew (vehicle _player)) + (assignedCargo (vehicle _player)) - [_player]);
};

_fnc_displayGear = {
	params ["_gearString"];
	if (primaryWeapon player != "") then {_gearString = format [localize "STR_HINTS_UND_GEAR_PRIM", _gearString, getText (configFile >> "CfgWeapons" >> (primaryWeapon player) >> "displayName")]};
	if (secondaryWeapon player != "") then {_gearString = format [localize "STR_HINTS_UND_GEAR_SEC", _gearString, getText (configFile >> "CfgWeapons" >> (secondaryWeapon player) >> "displayName")]};
	if (handgunWeapon player != "") then {_gearString = format [localize "STR_HINTS_UND_GEAR_HGUN", _gearString, getText (configFile >> "CfgWeapons" >> (handgunWeapon player) >> "displayName")]};
	if (vest player != "") then {_gearString = format [localize "STR_HINTS_UND_GEAR_VEST", _gearString, getText (configFile >> "CfgWeapons" >> (vest player) >> "displayName")]};
	if (headgear player in genHelmets) then {_gearString = format [localize "STR_HINTS_UND_GEAR_HEAD", _gearString, getText (configFile >> "CfgWeapons" >> (headgear player) >> "displayName")]};
	if (hmd player != "") then {_gearString = format [localize "STR_HINTS_UND_GEAR_HMD", _gearString, getText (configFile >> "CfgWeapons" >> (hmd player) >> "displayName")]};
	if !(uniform player in civUniforms) then {_gearString = format [localize "STR_HINTS_UND_GEAR_UNI", _gearString, getText (configFile >> "CfgWeapons" >> (uniform player) >> "displayName")]};
	_gearString
};


call {
	// Enemies nearby
	if ({((side _x == side_red) OR (side _x == side_green)) AND (_x distance player < safeDistance_undercover)} count allUnits > 0) exitWith {
		_reason = format [localize "STR_HINTS_UND_ENEMY_DIST",safeDistance_undercover];
	};

	// Known to nearby enemies
	if ({((side _x == side_red) OR (side _x == side_green)) AND ((_x knowsAbout player > 1.4) AND (_X distance player < (1.5*safeDistance_undercover)))} count allUnits > 0) exitWith {
		_reason = format [localize "STR_HINTS_UND_ENEMY_KNOW",safeDistance_undercover];
	};

	// Player is still on the enemy's watch list
	if (dateToNumber date < _compromised) exitWith {
		hint localize "STR_HINTS_UND_REPORTED";
	};

	// Close to an enemy facility
	_base = [_milThreatGround,player] call BIS_fnc_nearestPosition;
	_size = [_base] call sizeMarker;
	if (player distance getMarkerPos _base < (_size*2)) exitWith {_reason = localize "STR_HINTS_UND_FAC_GRND"};

	// Player is in a vehicle
	if (vehicle player != player) exitWith {
		// Vehicle doesn't qualify for undercover
		if !(typeOf(vehicle player) in _civVehicles) exitWith {
			_reason = localize "STR_HINTS_UND_NOTCIV";
		};

		// Vehicle has been reported
		if (vehicle player in reportedVehs) exitWith {
			_reason = localize "STR_HINTS_UND_REPORTED_CAR";
		};
	};

	// You are wearing compromising gear
	call {
		_break = false;
		if (primaryWeapon player != "") exitWith {_break = true};
		if (secondaryWeapon player != "") exitWith {_break = true};
		if (handgunWeapon player != "") exitWith {_break = true};
		if (vest player != "") exitWith {_break = true};
		if (headgear player in genHelmets) exitWith {_break = true};
		if (hmd player != "") exitWith {_break = true};
		if !(uniform player in civUniforms) exitWith {_break = true};
		if (_break) then {
			if ({((side _x== side_red) or (side _x== side_green)) and ((_x knowsAbout player > 1.4) or (_x distance player < safeDistance_undercover))} count allUnits > 0) then {
				_spotted = true;
			};
		};
	};

	if (_break) exitWith {
		_reason = [localize "STR_HINTS_UND_GEAR"] call _fnc_displayGear;
	};
};

if (_reason != "") exitWith {
	if (_spotted) then {
		_player setVariable ["compromised",(dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
		_reason = format ["%1\n\n%2", _reason, localize "STR_HINTS_UND_CMP_REPWAN"];
	};

	[player] spawn _fnc_compromiseVehicle;
	hint _reason;
};

["<t color='#1DA81D'>Incognito</t>",0,0,4,0,0,4] spawn bis_fnc_dynamicText;
player setCaptive true;
_player = player getVariable ["owner",player];

if (_player == leader group _player) then {
	{
		if (!isplayer _x) then {
			[_x] spawn undercoverAI;
		};
	} forEach units group _player;
};

scopeName "main";
while {_reason == ""} do {
	sleep 1;
	// Spotted
	if (!captive player) then {
		_reason = localize "STR_HINTS_UND_CMP_REPORTED";
		_spotted = true;
		breakTo "main";
	};

	if (vehicle _player != _player) then {
		_vehicle = vehicle _player;
		_vehicleType = typeOf _vehicle;

		// Wrong vehicle
		if !(_vehicleType in _civVehicles) then {
			_reason = localize "STR_HINTS_UND_CMP_VEH_MIL";
			breakTo "main";
		};

		// Reported vehicle
		if (_vehicle in reportedVehs) then {
			_reason = localize "STR_HINTS_UND_CMP_VEH_REP";
			_spotted = true;
			breakTo "main";
		};

		if (_vehicleType != civHeli) then {
			_base = [_milThreatGround,_player] call BIS_fnc_nearestPosition;
			_size = [_base] call sizeMarker;
			// Too close to an enemy facility
			if ((_player distance getMarkerPos _base < _size*2) and (_base in mrkAAF)) then {
				_reason = localize "STR_HINTS_UND_CMP_FAC";
				_spotted = true;
				breakTo "main";
			};

			// Offroad and spotted
			if !(isOnRoad position _vehicle) then {
				if (count (_vehicle nearRoads 50) == 0) then {
					if ({((side _x== side_red) or (side _x== side_green)) and ((_x knowsAbout player > 1.4) or (_x distance player < safeDistance_undercover))} count allUnits > 0) then {
						_reason = localize "STR_HINTS_UND_CMP_ROAD";
						breakTo "main";
					};
				};
			};

			// ACE bombs placed on vehicle
			if (activeACE) then {
			  	if (((position player nearObjects ["DemoCharge_Remote_Ammo", 5]) select 0) mineDetectedBy side_green) then {
					_reason = localize "STR_HINTS_UND_CMP_EXP";
					_spotted = true;
					breakTo "main";
				};

				if (((position player nearObjects ["SatchelCharge_Remote_Ammo", 5]) select 0) mineDetectedBy side_green) then {
					_reason = localize "STR_HINTS_UND_CMP_EXP";
					_spotted = true;
					breakTo "main";
				};
			};
		} else {
			// Too close to facility while flying
			_base = [_milThreatAir,_player] call BIS_fnc_nearestPosition;
			if (_player distance2d getMarkerPos _base < safeDistance_undercover) then {
				_reason = localize "STR_HINTS_UND_CMP_FAC";
				breakTo "main";
			};
		};
	} else {
		// Wearing compromising gear
		call {
			_break = false;
			if (primaryWeapon player != "") exitWith {_break = true};
			if (secondaryWeapon player != "") exitWith {_break = true};
			if (handgunWeapon player != "") exitWith {_break = true};
			if (vest player != "") exitWith {_break = true};
			if (headgear player in genHelmets) exitWith {_break = true};
			if (hmd player != "") exitWith {_break = true};
			if !(uniform player in civUniforms) exitWith {_break = true};
		};

		if (_break) then {
			// Spotted
			if ({((side _x== side_red) or (side _x== side_green)) and ((_x knowsAbout player > 1.4) or (_x distance player < safeDistance_undercover))} count allUnits > 0) then {
				_spotted = true;
				_reason = localize "STR_HINTS_UND_CMP_GEAR";
			} else {
				_reason = localize "STR_HINTS_UND_CMP_GEAR";
			};
			breakTo "main";
		};

		// Still on the watch list
		if (dateToNumber date < _compromised) then {
			_reason = localize "STR_HINTS_UND_CMP_WANTED";
			breakTo "main";
		};
	};
};

if (captive _player) then {_player setCaptive false};
["<t color='#D8480A'>Overt</t>",0,0,4,0,0,4] spawn bis_fnc_dynamicText;

if (_reason == localize "STR_HINTS_UND_CMP_GEAR") then {
	_reason = [_reason] call _fnc_displayGear;
};

// Compromise all passengers of the player's vehicle
if (vehicle _player != _player) then {
	[_player] spawn _fnc_compromiseVehicle;
};

// Be placed on the watch list
if (_spotted) then {
	_player setVariable ["compromised",(dateToNumber [date select 0, date select 1, date select 2, date select 3, (date select 4) + 30])];
	_reason = format ["%1\n\n%2", _reason, localize "STR_HINTS_UND_CMP_REPWAN"];
};

hint _reason;