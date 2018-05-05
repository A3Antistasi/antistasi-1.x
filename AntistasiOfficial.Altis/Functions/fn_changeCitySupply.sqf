params["_type", "_delta", "_location"];
private["_city", "_data", "_supplyLevels", "_index", "_currentLevel", "_newLevels"];

//Gather the needed data
_city = [[ciudades, _location] call BIS_fnc_nearestPosition, _location] select (typeName _location == typeName "");
_data = server getVariable _city;
if !(_data isEqualType []) exitWith {diag_log format ["Error in changeCitySupply. Passed %1 as reference.", _location]};

//Execute command
_supplyLevels = _data select 4;

if(_type == "FOOD") then {_index = 0;};
if(_type == "WATER") then {_index = 1;};
if(_type == "FUEL") then {_index = 2;};

systemChat format ["type = %1 _supplyLevels = %2 city = %3", _type,_supplyLevels, _city];
diag_log format ["type = %1 _supplyLevels = %2 city = %3", _type,_supplyLevels, _city];
_currentLevel = _supplyLevels select _index;

if(_delta > 0 && _currentLevel != 'GOOD') then
{
    diag_log format ["allPlayers = %1", allPlayers - entities "HeadlessClient_F"];
	if(_currentLevel == 'LOW') then
	{
		_currentLevel = 'GOOD';
		[0,5,_city] remoteExec ["AS_fnc_changeCitySupport",2];
        // stef this is already done in createSupplyBox don't you want to remove from playerScoreAdd ?
        {
            systemChat format ["1private x = %1", _x];
            systemChat format ["location x = %1", _location];
            diag_log format ["1private x = %1", _x];
            diag_log format ["location x = %1", _location];
            // if (_x distance _location < 500) then {[5,_x] call playerScoreAdd};
        } forEach (allPlayers - entities "HeadlessClient_F");
        [5,Slowhand] call playerScoreAdd;
	};

	if(_currentLevel == 'CRITICAL') then
	{
		_currentLevel = 'LOW';
		[0,10,_city] remoteExec ["AS_fnc_changeCitySupport",2];
        // stef this is already done in createSupplyBox don't you want to remove from playerScoreAdd ?
        {
            systemChat format ["2private x = %1", _x];
            diag_log format ["2private x = %1", _x];
            systemChat format ["location x = %1", _location];
            diag_log format ["location x = %1", _location];
            // if (_x distance _location < 500) then {[10,_x] call playerScoreAdd};
        } forEach (allPlayers - entities "HeadlessClient_F");
        [10,Slowhand] call playerScoreAdd;
	};
};
if(_delta < 0 && _currentLevel != 'CRITICAL') then
{
	if(_currentLevel == 'GOOD') then
	{
		_currentLevel = 'LOW';
	};
	if(_currentLevel == 'LOW') then
	{
		_currentLevel = 'CRITICAL';
	};
};

systemChat format ["type_currentLevel = %1_%2", _type, _currentLevel];
diag_log format ["type_currentLevel = %1_%2", _type, _currentLevel];
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
