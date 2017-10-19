if (server getVariable "prestigeNATO" < 10) exitWith {hint format ["You lack of enough %1 Support to make this request", A3_Str_BLUE]};
if (!allowPlayerRecruit) exitWith {hint "Server is very loaded. \nWait one minute or change FPS settings in order to fulfill this request"};
	if (!([player] call hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};
_tipo = _this select 0;

posicionTel = [];

hint "Select the spot from which the plane will start to drop the bombs";

openMap true;
onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_pos1 = posicionTel;
posicionTel = [];

_mrkorig = createMarker [format ["BRStart%1",random 1000], _pos1];
_mrkorig setMarkerShape "ICON";
_mrkorig setMarkerType "hd_destroy";
_mrkorig setMarkerColor "ColorRed";
_mrkOrig setMarkerText "Bomb Run Init";

hint "Select the map position to which the plane will exit to calculate plane's route vector";

onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (!visibleMap)};
onMapSingleClick "";

if (!visibleMap) exitWith {deleteMarker _mrkOrig};

_pos2 = posicionTel;
posicionTel = [];

_ang = [_pos1,_pos2] call BIS_fnc_dirTo;

_central = [_pos1, 100, _ang] call BIS_fnc_relPos;
_ciudad = [ciudades,_central] call BIS_fnc_nearestPosition;
if (_central distance getMarkerPos _ciudad < ([_ciudad] call sizeMarker) * 1.5) exitWith {hint format ["That path is very close to %1.\n\n%2 won't perform any bomb run that may cause civilian casualties",_ciudad, A3_Str_BLUE]; deleteMarker _mrkOrig; openMap false};

[-10,0] remoteExec ["prestige",2];

_mrkDest = createMarker [format ["BRFin%1",random 1000], _pos2];
_mrkDest setMarkerShape "ICON";
_mrkDest setMarkerType "hd_destroy";
_mrkDest setMarkerColor "ColorRed";
_mrkDest setMarkerText "Bomb Run Exit";

//openMap false;

_angorig = _ang - 180;

_origpos = [_pos1, 2500, _angorig] call BIS_fnc_relPos;
_finpos = [_pos2, 2500, _ang] call BIS_fnc_relPos;

_planefn = [_origpos, _ang, selectRandom bluCASFW, side_blue] call bis_fnc_spawnvehicle;
_plane = _planefn select 0;
_plane setVariable ["BLUFORSpawn",false];
_plane setPosATL [getPosATL _plane select 0, getPosATL _plane select 1, 1000];
_plane disableAI "TARGET";
_plane disableAI "AUTOTARGET";
_plane flyInHeight 100;

driver _plane sideChat "Starting Bomb Run. ETA 30 seconds.";
_wp1 = group _plane addWaypoint [_pos1, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "LIMITED";
_wp1 setWaypointBehaviour "CARELESS";
if (_tipo == "CARPET") then {_wp1 setWaypointStatements ["true", "[this,""CARPET""] execVM 'AI\airbomb.sqf'"]};
if (_tipo == "NAPALM") then {_wp1 setWaypointStatements ["true", "[this,""NAPALM""] execVM 'AI\airbomb.sqf'"]};
if (_tipo == "HE") then {_wp1 setWaypointStatements ["true", "[this] execVM 'AI\airbomb.sqf'"]};


_wp2 = group _plane addWaypoint [_pos2, 1];
_wp2 setWaypointSpeed "LIMITED";
_wp2 setWaypointType "MOVE";

_wp3 = group _plane addWaypoint [_finpos, 2];
_wp3 setWaypointType "MOVE";
_wp3 setWaypointSpeed "FULL";
_wp3 setWaypointStatements ["true", "{deleteVehicle _x} forEach crew this; deleteVehicle this; deleteGroup (group this)"];

waitUntil {sleep 1; (currentWaypoint group _plane == 4) or (!canMove _plane)};

deleteMarker _mrkOrig;
deleteMarker _mrkDest;
if ((!canMove _plane) and (!isNull _plane)) then
	{
	sleep cleantime;
	{deleteVehicle _x} forEach crew _plane; deleteVehicle _plane;
	deleteGroup group _plane;
	};