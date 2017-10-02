if (!isServer) exitWith {};

params ["_delta"];
private ["_average", "_text"];

_delta = _delta + minimoFPS;

if (_delta < 0) then {_delta = 0};

_average = fpsTotal / fpsCuenta;
_text = "";

if ((_delta > _average * 0.6) and (_average > 24)) then {
	_delta = round (_average * 0.6);
	_text = format ["FPS limit set to %2.\n\nAverage FPS on server is %1, a higher limit may stop civilian spawning.",_average, _delta];
	minimoFPS = _delta;
} else {
	minimoFPS = _delta;
	_text = format ["FPS limit set to %2.\n\nAverage FPS on server is %1.",_average, _delta];
};

[[petros,"hint",_text],"commsMP"] call BIS_fnc_MP;
publicVariable "minimoFPS";