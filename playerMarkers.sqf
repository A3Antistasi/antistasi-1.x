private ["_players","_player","_mrk","_veh"];

while {true} do
{
	waitUntil {sleep 0.5; (visibleMap or visibleGPS) and ([player] call hasRadio)};
	_players = [];
	_markers = [];
	while {visibleMap or visibleGPS} do{

		{
			_player = _x getVariable ["owner",_x];
			if ((not(_player in _players)) and (player != _player) and (side player isEqualTo side group _x)) then
			{
				_players pushBack _player;
				_mrk = createMarkerLocal [format ["%1",_player],position _player];
				_mrk setMarkerTypeLocal "mil_triangle";
				_mrk setMarkerColorLocal "ColorWhite";
				_mrk setMarkerTextLocal format ["%1",name _player];
				if (server getVariable ["hardMode", false]) then {_mrk setMarkerAlphaLocal 0};
				//_mrk setMarkerAlphaLocal 0; // <<-- hard mode
				_markers pushBack _mrk;
			};
		} forEach playableUnits;

		{
			_player = _x;
			_mrk = format ["%1",_player];
			if (vehicle _player == _player) then{
				if !(server getVariable ["hardMode", false]) then {_mrk setMarkerAlphaLocal 1};
				//_mrk setMarkerAlphaLocal 1; // <<-- normal mode
				_mrk setMarkerPosLocal position _player;
				_mrk setMarkerDirLocal getDir _player;
				if ((_player getVariable ["inconsciente",false]) || (_player getVariable ["ACE_isUnconscious",false])) then{
					_mrk setMarkerTypeLocal "mil_join";
					if (server getVariable ["hardMode", false]) then {_mrk setMarkerAlphaLocal 1};
					//_mrk setMarkerAlphaLocal 1; // <<-- hard mode
					_mrk setMarkerTextLocal format ["%1 Injured",name _player];
					_mrk setMarkerColorLocal "ColorPink";
				}else{
					_mrk setMarkerTypeLocal "mil_triangle";
					if (server getVariable ["hardMode", false]) then {_mrk setMarkerAlphaLocal 0};
					//_mrk setMarkerAlphaLocal 0; // <<-- hard mode
					_mrk setMarkerTextLocal format ["%1",name _player];
					_mrk setMarkerColorLocal "ColorWhite";
				};
			}else{
				_veh = vehicle _player;
				if ((isNull driver _veh) or (driver _veh == _player)) then{
					if !(server getVariable ["hardMode", false]) then {_mrk setMarkerAlphaLocal 1};
					//_mrk setMarkerAlphaLocal 1; // <<-- normal mode
					_mrk setMarkerPosLocal position _veh;
					_mrk setMarkerDirLocal getDir _veh;
					_texto = format ["%1 (%2)/",name _player,getText(configFile>>"CfgVehicles">>typeOf _veh>>"DisplayName")];
					{
						if ((_x!=_player) and (vehicle _x == _veh)) then{
							_texto = format ["%1%2/",_texto,name _x];
						};
					} forEach playableUnits;
						_mrk setMarkerTextLocal _texto;
					}else{
						_mrk setMarkerAlphaLocal 0;
					};
			};
		} forEach _players;


		sleep 1;

	};//end while loop

	{deleteMarkerLocal _x} forEach _markers;
};
