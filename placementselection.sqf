if (!isNil "placementDone") then {
	Slowhand allowDamage false;
	(localize "STR_HINTS_HQPLACE_DEATH_TITLE") hintC localize "STR_HINTS_HQPLACE_DEATH";
} else {
	diag_log "Antistasi: New Game selected";
	(localize "STR_HINTS_HQPLACE_START_TITLE") hintC [localize "STR_HINTS_HQPLACE_START_1",localize "STR_HINTS_HQPLACE_START_2",localize "STR_HINTS_HQPLACE_START_3"];
};

[mrkAAF,false] params ["_markers","_enemiesNearby"];
private ["_nearestZone","_position","_oldUnit","_spawnPos","_direction"];

if (isNil "placementDone") then {
	_markers = _markers - controles;
	openMap true;
} else {
	openMap [true,true];
};

while {true} do {
	clickPosition = [];
	onMapSingleClick "clickPosition = _pos;";

	waitUntil {sleep 1; (count clickPosition > 0) OR !visiblemap};
	onMapSingleClick "";
	if !(visiblemap) exitWith {};
	_position = clickPosition;
	_nearestZone = [_markers,_position] call BIS_fnc_nearestPosition;
	if (getMarkerPos _nearestZone distance _position < 1000) then {hint localize "STR_HINTS_HQPLACE_ZONES"};
	if (surfaceIsWater _position) then {hint localize "STR_HINTS_HQPLACE_WATER"};

	_enemiesNearby = false;
	if (!isNil "placementDone") then {
		{
			if ((side _x == side_green) OR (side _x == side_red)) then {
				if (_x distance _position < 1000) then {_enemiesNearby = true};
			};
		} forEach allUnits;
	};
	if (_enemiesNearby) then {hint localize "STR_HINTS_HQPLACE_ENEMIES"};
	if ((getMarkerPos _nearestZone distance _position > 1000) AND (!surfaceIsWater _position) AND (!_enemiesNearby)) exitWith {};
};

if (visiblemap) then {
	if (isNil "placementDone") then {
		{
			if (getMarkerPos _x distance _position < 1000) then {
				mrkAAF = mrkAAF - [_x];
				mrkFIA = mrkFIA + [_x];
			};
		} forEach controles;
		publicVariable "mrkAAF";
		publicVariable "mrkFIA";
		petros setPos _position;
	} else {
		AS_flag_resetDone = false;
		[_position] remoteExec ["AS_fnc_resetHQ",2];
		waitUntil {AS_flag_resetDone};
		AS_flag_resetDone = false;
	};

	guer_respawn setMarkerPos _position;
	guer_respawn setMarkerAlpha 1;
	if (count (server getVariable ["obj_vehiclePad",[]]) > 0) then {
		[obj_vehiclePad, {deleteVehicle _this}] remoteExec ["call", 0];
		[obj_vehiclePad, {obj_vehiclePad = nil}] remoteExec ["call", 0];
		server setVariable ["AS_vehicleOrientation", 0, true];
		server setVariable ["obj_vehiclePad",[],true];
	};

	if (isMultiplayer) then {hint localize "STR_HINTS_HQPLACE_MOVING"; sleep 5};
	_spawnPos = [_position, 3, getDir petros] call BIS_Fnc_relPos;
	fuego setPos _spawnPos;
	_direction = getdir Petros;
	if (isMultiplayer) then {sleep 5};
	_spawnPos = [getPos fuego, 3, _direction] call BIS_Fnc_relPos;
	caja setPos _spawnPos;
	_direction = _direction + 45;
	_spawnPos = [getPos fuego, 3, _direction] call BIS_Fnc_relPos;
	mapa setPos _spawnPos;
	mapa setDir ([fuego, mapa] call BIS_fnc_dirTo);
	_direction = _direction + 45;
	_spawnPos = [getPos fuego, 3, _direction] call BIS_Fnc_relPos;
	bandera setPos _spawnPos;
	_direction = _direction + 45;
	_spawnPos = [getPos fuego, 3, _direction] call BIS_Fnc_relPos;
	cajaVeh setPos _spawnPos;

	if (isNil "placementDone") then {
		if (isMultiplayer) then {
			{
				_x setPos getPos petros;
			} forEach playableUnits
		} else {
			Slowhand setPos (getMarkerPos guer_respawn);
		}
	} else {
		Slowhand allowDamage true;
	};

	if (isMultiplayer) then {
		caja hideObjectGlobal false;
		cajaVeh hideObjectGlobal false;
		mapa hideObjectGlobal false;
		fuego hideObjectGlobal false;
		bandera hideObjectGlobal false;
	} else {
		caja hideObject false;
		cajaVeh hideObject false;
		mapa hideObject false;
		fuego hideObject false;
		bandera hideObject false;
	};

	openmap [false,false];
};

"FIA_HQ" setMarkerPos (getMarkerPos guer_respawn);
posHQ = getMarkerPos guer_respawn; publicVariable "posHQ";
server setVariable ["posHQ", getMarkerPos guer_respawn, true];

if (isNil "placementDone") then {
	placementDone = true;
	publicVariable "placementDone";
};