params ["_marker", "_time"];
private ["_currentTimer"];

_currentTimer = server getVariable _marker;
if (_currentTimer < dateToNumber date) then {_currentTimer = dateToNumber date};

_currentTimer = numberToDate [2035, _currentTimer];
_currentTimer = [_currentTimer select 0, _currentTimer select 1, _currentTimer select 2, _currentTimer select 3, (_currentTimer select 4) + _time];

server setVariable [_marker, dateToNumber _currentTimer, true];