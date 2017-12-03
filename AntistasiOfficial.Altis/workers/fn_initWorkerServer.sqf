/*
 * Author: IrLED
 * Initializes worker server infrastructure
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */
#define DEBUG_SYNCHRONOUS
#define DEBUG_MODE_FULL
#include "script_component.hpp"

workerArray = [2];
addMissionEventHandler ["PlayerDisconnected",{[_this select 4] call AS_fnc_unregisterWorker;}];
INFO("WorkerServer init done");