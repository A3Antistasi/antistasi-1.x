params ["_marker","_group"];

private _position = getMarkerPos _marker;
private _size = [_marker] call sizeMarker;

waitUntil {sleep 5; (leader _group distance _position < _size) or ({alive _x} count units _group == 0)};

if (leader _group distance _position < _size) then{
	[_group, _marker, "COMBAT","SPAWNED","NOFOLLOW"] execVM "scripts\UPSMON.sqf";
};
