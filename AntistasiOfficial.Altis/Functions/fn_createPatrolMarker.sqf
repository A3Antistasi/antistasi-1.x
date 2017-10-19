params ["_marker",["_size",[(distanciaSPWN/2), (distanciaSPWN/2)]]];
private ["_markerPos","_patrolMarker"];

_markerPos = getMarkerPos _marker;

_patrolMarker = createMarkerLocal [format ["%1patrolarea", random 100], _markerPos];
_patrolMarker setMarkerShapeLocal "RECTANGLE";
_patrolMarker setMarkerSizeLocal [_size select 0, _size select 1];
_patrolMarker setMarkerTypeLocal "hd_warning";
_patrolMarker setMarkerColorLocal "ColorRed";
_patrolMarker setMarkerBrushLocal "DiagGrid";
_patrolMarker setMarkerDirLocal (markerDir _marker);
_patrolMarker setMarkerAlpha 0;

_patrolMarker
