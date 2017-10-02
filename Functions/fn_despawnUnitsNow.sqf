params [["_groups", []], ["_soldiers", []], ["_vehicles", []]];

if (count _vehicles > 0) then {
	{
		if !(_x in staticsToSave) then {
			[_x] spawn {
				deleteVehicle (_this select 0);
			};
		};
		if (_x in reportedVehs) then {
			reportedVehs = reportedVehs - [_x];
			publicVariable "reportedVehs";
		};
	} forEach _vehicles;
};

if (count _soldiers > 0) then {
	{
		[_x] spawn {
			deleteVehicle (_this select 0);
		};
	} forEach _soldiers;
};

if (count _groups > 0) then {
	{
		_x deleteGroupWhenEmpty true;
	} forEach _groups;
};