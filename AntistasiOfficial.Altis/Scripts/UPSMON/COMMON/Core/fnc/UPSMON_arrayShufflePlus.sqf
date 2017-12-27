/****************************************************************
File: UPSMON_arrayShufflePlus.sqf
Author: KillZoneKid

Description:

Parameter(s):
	<--- Array
Returns:
	Array
****************************************************************/

private ["_cnt","_el1","_rnd","_indx","_el2"];

_cnt = count _this - 1;
if (_cnt < 1) exitWith {_this;}; //Nothing to shuffle
_el1 = _this select _cnt;
_rnd = random diag_tickTime * _cnt;
for "_i" from 1 to _cnt do {
    _indx = floor random _rnd % _cnt;
    _el2 = _this select _indx;
    _this set [_indx, _el1];
	_el1 = _el2;
};
_this set [_cnt, _el1];
_this