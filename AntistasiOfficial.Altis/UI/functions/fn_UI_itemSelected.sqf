disableSerialization;
params ["_idc", "_index"];
private ["_display"];

_display = findDisplay 100;

if (_index < 0) then {
	_display displayCtrl (ctrlIDC _idc + 2) ctrlSetText "1";
} else {
	_display displayCtrl (ctrlIDC _idc + 2) ctrlSetText format ["%1", AS_currentCounts select _index];
};
