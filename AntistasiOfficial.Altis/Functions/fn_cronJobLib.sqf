// Author
// set this value to 0 at server start
// added cron jobs would get incremented ids
libsqf_cron_job_id_sec = 0;
libsqf_cron_timetable = [];

// job format:
// cronjob_##id = [{code},[params],when_to_run_first_time,repeat_in_time]
// id - number, used if we want to remove this from scheduler
// {code} - code to execute, when time comes
// [params] - params passed to code
// repeat_in_time - if set, run this job again in <repeat_in_time> seconds

// how to add cron job
// [{code},[params],when_to_run_first_time,repeat_interval,is_new] call cron_addjob
libsqf_cron_addjob =
{
	private ["_job","_isnew","_first_time","_index","_time"];
	_time = if (isMultiplayer) then {serverTime} else {time};
	_job = _this;
	// if we add new job this param should be 0
	// if modifying existing should be equal to job's id
	_isnew = _this select 4;
	// get cron job id
	_index = if (_isnew == 0) then
	{
		libsqf_cron_job_id_sec = libsqf_cron_job_id_sec + 1;
		libsqf_cron_job_id_sec;
	} else {_isnew};
	// write the cron job to variable cronjob_##id
	_job call compile format ["libsqf_cronjob_%1 = _this",_index];
	// first time to run this job
	// rounding down to seconds
	_first_time = floor (_this select 2);

	// if first time run is earlier current server time means immediate execution
	// all immedtiate to run jobs are considered to run at time 0 seconds from server start
	// means that we put all these jobs to var cron_jobs_at_0
	// otherwise job execution may be delayed
	if (_time > _first_time) then {_first_time = 0};
	// if we already have _first_time in time table, do not alter it
	// primarily to avoid unnecessary sorting for immediate events
	if (!(_first_time in libsqf_cron_timetable)) then
	{
		// adding to timetable and sorting array to have earliest event always by select 0
		libsqf_cron_timetable pushBack _first_time;
		// not using sort command to keep backward compatibility with 1.42 :)
		libsqf_cron_timetable call BIS_fnc_sortNum;
	};
	// get the list of existing jobs for requested time
	_jobs = call compile format ["missionNamespace getVariable ['libsqf_cron_jobs_at_%1',[]]",_first_time];
	_jobs pushBack _index;
	_jobs call compile format ["libsqf_cron_jobs_at_%1 = _this",_first_time];
};

libsqf_cron_removejob =
{
	_id = _this;
	call compile format ["libsqf_cronjob_%1 = nil",_id];
};

// time call cron_runjobs;
libsqf_cron_runjobs =
{
	private ["_time","_earliest","_jobs"];
	// current time
	_time = if (isMultiplayer) then {serverTime} else {time};
	// exit if no jobs
	if (count libsqf_cron_timetable == 0) exitWith {false};

	// get the time of earliest event
	_earliest = libsqf_cron_timetable select 0;
	// exit if earliest event is in future
	if (_time < _earliest) exitWith {false};
	// remove event from timetable if it occurs
	libsqf_cron_timetable deleteAt 0;
	_jobs = call compile format ["missionNamespace getVariable ['libsqf_cron_jobs_at_%1',[]]",_earliest];

	// if no jobs at this time, nil this var and exit
	if (_jobs isEqualTo []) exitWith
	{
		[] call compile format ["libsqf_cron_jobs_at_%1 = nil",_earliest];
		false;
	};

	// run jobs
	{
		private ["_job","_interval","_new_time","_index"];
		// read job data
		_new_time = 0;
		_index = _x;
		// job we run in this iteration
		_job = call compile format ["libsqf_cronjob_%1",_index];
		// finding job interval
		_interval = _job select 3;
		// spawn function defined in _job's code
		(_job select 1) spawn (_job select 0);
		if (_interval != 0) then
		{
			// reschedule job for new time
			_new_time = _interval + _time;
			_job set [2,_new_time];
			_job set [4,_index];
			_job call libsqf_cron_addjob;
		} else {_index call libsqf_cron_removejob;};
	} forEach _jobs;
	// nil var with jobs, since we ran them
	[] call compile format ["libsqf_cron_jobs_at_%1 = nil",_earliest];
};

libsqf_cron_scheduler = createTrigger ["EmptyDetector",[0,0,0],false];
libsqf_cron_scheduler setTriggerActivation ["NONE","PRESENT",true];
libsqf_cron_scheduler setTriggerStatements ["[] call libsqf_cron_runjobs", "", ""];
