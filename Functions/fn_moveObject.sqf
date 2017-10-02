if (player != Slowhand) exitWith {hint localize "STR_INFO_MOVEASSETS_1"};
if (vehicle player != player) exitWith {hint localize "STR_INFO_MOVEASSETS_2"};

params ["_object", "_player", "_id", ["_category", ""]];
private ["_position","_distance","_attachPoint","_bbr","_p1","_p2","_maxHeight","_checkAttachments","_actionParams"];

_position = server getVariable ["posHQ", getMarkerPos guer_respawn];
_distance = 30;
_attachPoint = [0,2,1];

if !(_category == "") then {
	_position = getMarkerPos ([mrkFIA, _player] call BIS_fnc_nearestPosition);
	_distance = 50;
	_bbr = boundingBoxReal _object;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_maxHeight = abs ((_p2 select 2) - (_p1 select 2));
	if (_maxHeight > 2.5) then {
		_attachPoint = [0,2,1.5];
	};
	if (_maxHeight > 3) then {
		_attachPoint = [0,2,2];
	};
};

if (position _object distance _position > _distance) exitWith {hint localize "STR_INFO_MOVEASSETS_3"};

_object removeAction _id;
_object attachTo [player, _attachPoint];
player setVariable ["ObjAttached", true, true];

player addAction [localize "STR_ACT_DROPASSET", {
	params ["_obj", "_caller", "_actionID"];
	_obj removeAction _actionID;
	_obj setVariable ["ObjAttached", nil, true];
	{detach _x} forEach attachedObjects _obj;
	}, nil, 0, false, true, "", "_target getVariable ['ObjAttached', false]"];

_checkAttachments = {
	private _return = false;
	{
		if !(isNull _x) exitWith {_return = true};
	} forEach attachedObjects _player;
	_return
};

waitUntil {sleep 1; (vehicle player != player) OR (player distance _position > _distance) OR !(alive player) OR !(isPlayer player) OR !(call _checkAttachments)};

{detach _x} forEach attachedObjects player;
if (_category == "") then {
	_object addAction [localize "STR_ACT_MOVEASSET", {[_this select 0,_this select 1,_this select 2] spawn AS_fnc_moveObject},nil,0,false,true,"","(_this == Slowhand)", 5];
} else {
	_object addAction [localize "STR_ACT_MOVEASSET", {[_this select 0,_this select 1,_this select 2,"static"] spawn AS_fnc_moveObject},nil,0,false,true,"","(_this == Slowhand)", 5];
};

_object setPosATL [getPosATL _object select 0,getPosATL _object select 1,0];

if (vehicle player != player) exitWith {hint localize "STR_INFO_MOVEASSETS_2"};
if (player distance _position > _distance) exitWith {hint format [localize "STR_INFO_MOVEASSETS_4", _distance]};