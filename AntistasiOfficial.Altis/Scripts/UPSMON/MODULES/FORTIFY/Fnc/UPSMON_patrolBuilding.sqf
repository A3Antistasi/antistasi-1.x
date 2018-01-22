/****************************************************************
File: UPSMON_patrolBuilding.sqf
Author: Monsada

Description:
	unit will patrol in building

Parameter(s):
	<--- soldier to move
	<--- building to patrol
	<--- positions of building (optional)
Returns:
	nothing
****************************************************************/

private ["_units","_bldpos","_grp","_unit","_patrolto","_time"];

_units = _this select 0;
_bldpos = _this select 1;
_grp = _this select 2;

_bldpos = _bldpos select {!isNil "_x"};

private _grpid = _grp getVariable "UPSMON_grpid";
_grp setVariable ["UPSMON_inbuilding",true];
private _exitPos = (leader _grp) getPos [30, random 360];
{_x forceSpeed -1; _x doMove getPos _x; false;}count _units;
sleep 0.1;
_units = [_units] call UPSMON_Getunits;

if (count _units > 0) then {
	_bldpos = _bldpos - ["deletethis"];

    private _countAlive = 1;
    _time = time + (60 * count _bldpos);
    while {_time > time AND count _bldpos > 0 AND _countAlive > 0 AND {_grp getvariable "UPSMON_Grpmission" isEqualTo "PATROLINBLD"}} do{
        _countAlive = 0;
        {
            _unit = _x;
            If (alive _unit) then
            {
                _countAlive = _countAlive + 1;
                If (vehicle _unit == _unit) then
                {
                    private _unitNum = _forEachIndex;
                    private _currPos = getPos _unit;
                    //What i see from current pos
                    private _eyePos = eyePos _unit;
                    {
                        private _aslPos = AGLToASL _x;
                        if (((lineIntersectsWith [_eyePos, _aslPos]) isEqualTo []) OR  (_x vectordistance _currPos < 1)) then {
                            _bldpos set [_forEachIndex, "deletethis"];
                        };
                    }forEach _bldpos;
                    _bldpos = _bldpos - ["deletethis"];
                    //Stuck checkWWW
                    _currPos = getPos _unit;
                    private _lastPos = _unit getVariable ["UPSMON_PATROLINBLD_lastpos", _currPos];
                    _unit setVariable ["UPSMON_PATROLINBLD_lastpos", _currPos];
                    if (_lastPos vectordistance _currPos < 0.1) then {
                        //unstuck
                        If (count _bldpos > 0) then {
                            _patrolto = selectRandom _bldpos;
                            doStop _unit;
                            _unit doMove _patrolto;
                            _unit setdestination [_patrolto,"LEADER PLANNED",true];
                        };
                    };
                    sleep 1;
                };
            };
        } foreach _units;
        sleep 2;
    };
};

{_x forceSpeed -1; _x doMove _exitPos; false;}count _units;
sleep 30;
_grp setvariable ["UPSMON_bldposToCheck",nil];
_grp setVariable ["UPSMON_inbuilding",nil];
