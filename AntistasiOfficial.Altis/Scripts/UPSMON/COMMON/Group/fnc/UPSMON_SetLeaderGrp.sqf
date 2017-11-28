/****************************************************************
File: UPSMON_SetLeaderGrp.sqf
Author: Azroul13

Description:
	Set the leader of the group
Parameter(s):
	<--- Unit or Group
Returns:
	---> Leader
****************************************************************/

params[["_unit", objNull, [ objNull, grpNull]]];
private ["_leader", "_grp"];

if (typename _unit == "GROUP") then {
    _grp = _unit;
    _unit = leader _grp;
} else {
      _grp = group _unit;
};
_leader = leader _grp;

if ((_unit iskindof "Man")) then {

	if(_unit != _leader) then {
		_grp selectLeader _unit;
	};

} else {

	if (!isnull(commander _unit) ) then {
		_unit = commander _unit;
	}else{
		if (!isnull(driver _unit) ) then {
			_unit = driver _unit;
		}else{
			_unit = gunner _unit;
		};
	};
	_grp selectLeader _unit;
};

_unit;
