params ["_unit"];
private ["_groupsHC","_oldUnit","_oldProviders","_HQ","_providerModule","_used"];

_groupsHC = hcAllGroups Slowhand;
_oldUnit = Slowhand;

if (!isNil "_groupsHC") then {
	{
  		_oldUnit hcRemoveGroup _x;
  	} forEach _groupsHC;
};

_oldUnit synchronizeObjectsRemove [HC_comandante];
HC_comandante synchronizeObjectsRemove [_oldUnit];
Slowhand = _unit;
publicVariable "Slowhand";
[group _unit, _unit] remoteExec ["selectLeader",_unit];
Slowhand synchronizeObjectsAdd [HC_comandante];
HC_comandante synchronizeObjectsAdd [Slowhand];
if (!isNil "_groupsHC") then {
  	{_unit hcSetGroup [_x]} forEach _groupsHC;
} else {
	{
		if (_x getVariable ["isHCgroup",false]) then {
			_unit hcSetGroup [_x];
		};
	} forEach allGroups;
};

if (isNull _oldUnit) then {
	[_oldUnit,[group _oldUnit]] remoteExec ["hcSetGroup",_oldUnit];
};