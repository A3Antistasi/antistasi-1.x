params["_type", "_delta", "_location"];
private["_city", "_data", "_supplyLevels", "_index", "_currentLevel", "_newLevels", "_oldLevel"];

//Gather the needed data
_city = [[ciudades, _location] call BIS_fnc_nearestPosition, _location] select (typeName _location == typeName "");
_data = server getVariable _city;
if !(_data isEqualType []) exitWith {diag_log format ["Error in changeCitySupply. Passed %1 as reference.", _location]};

//Execute command
_supplyLevels = _data select 4;

if (_type == "FOOD") then {_index = 0;};
if (_type == "WATER") then {_index = 1;};
if (_type == "FUEL") then {_index = 2;};

_currentLevel = _supplyLevels select _index;

diag_log format ["supplylevels food,water,fuel = %1 city = %2", _supplyLevels, _city];
diag_log format ["type = %1 _currentLevel = %1 city = %2", _type, _currentLevel, _city];

// TODO : dont seem to work properly
_oldLevel = _currentLevel;
if (_delta > 0 AND _currentLevel != "GOOD") then {
    diag_log format ["delta %1", _delta];
    diag_log format ["_currentLevel %1", _currentLevel];

	if (_currentLevel == "LOW") then {
		_currentLevel = "GOOD";
        // TODO : need testing
		[0, 5, _city] remoteExec ["AS_fnc_changeCitySupport", 2];

        // TO DO : not working
        // {
            // if (_x distance _location < 500) then {[5,_x] call playerScoreAdd};
        // } forEach (allPlayers - entities "HeadlessClient_F");
        [5,Slowhand] call playerScoreAdd;
	};

	if (_currentLevel == "CRITICAL") then
	{
		_currentLevel = "LOW";
        // TODO : need testing
        [0, 10, _city] remoteExec ["AS_fnc_changeCitySupport", 2];

        // TO DO : not working
        // {
            // if (_x distance _location < 500) then {[10,_x] call playerScoreAdd};
        // } forEach (allPlayers - entities "HeadlessClient_F");
        [10, Slowhand] call playerScoreAdd;
	};
    diag_log format ["log changeCitySupply %1 increased to %2", _city, _currentLevel];
};
if (_delta < 0 AND _currentLevel != "CRITICAL") then {
    diag_log format ["delta %1", _delta];
    diag_log format ["_currentLevel %1", _currentLevel];
    diag_log format ["(_delta < 0 AND _currentLevel != 'GOOD')"];

    // TODO : missing changeCitySupport call
    if (_currentLevel == "LOW") then {
		_currentLevel = "CRITICAL";
	};
	if (_currentLevel == "GOOD") then {
		_currentLevel = "LOW";
	};

    diag_log format ["log changeCitySupply %1 decreased to %2", _city, _currentLevel];
};

diag_log format ["delta %1", _delta];
diag_log format ["_currentLevel %1", _currentLevel];
diag_log format ["log changeCitySupply %1 changed %2 to %3", _city, _oldLevel, _currentLevel];

//Create new Array containing the new data
_newLevels = [];
for "_i" from 0 to 2 do
{
	if(_i != _index) then
	{
		_newLevels pushback (_supplyLevels select _i);
	}
	else
	{
		_newLevels pushback _currentLevel;
	};
};

//Prepare data for save
_data = [_data select 0, _data select 1, _data select 2,_data select 3, _newLevels];

//Save data
server setVariable [_city,_data,true];

systemChat format ["%1 is %2 on %3 supply", _city, _currentLevel, _type];
diag_log format ["ANTISTASI %1 city is %2 on %3 supply", _city, _currentLevel, _type];
