if !((worldName == "Napf") OR (worldName == "NapfWinter")) exitWith {};

private ["_terrainObjects"];

power = ["power","power_1","power_2","power_3","power_5","power_6","power_8","power_9","power_10"]; // power plants
bases = ["base","base_1","base_2","base_3","base_4","base_5","base_6","base_7","base_9","base_10","base_11","base_12"]; // army bases
aeropuertos = ["airport","airport_1","airport_2","airport_3","airport_4","airport_5"]; // airports
recursos = ["resource","resource_1","resource_2","resource_3","resource_4","resource_5","resource_6","resource_7"]; // resources
fabricas = ["factory","factory_1","factory_2","factory_3","factory_4","factory_5"]; // factories
puestos = ["puesto","puesto_1","puesto_2","puesto_3","puesto_4","puesto_5","puesto_6","puesto_7","puesto_8","puesto_9","puesto_10","puesto_11","puesto_12","puesto_13","puesto_14","puesto_15","puesto_16","puesto_17","puesto_18","puesto_19","puesto_20","puesto_21","puesto_22","puesto_23","puesto_24","puesto_25","puesto_26","puesto_27"]; // outposts
puestosAA = ["puesto_1","puesto_2","puesto_6","puesto_17","puesto_23","puesto_27"]; // AA outposts
puertos = ["puerto","puerto_1","puerto_2","puerto_3","puerto_4"]; // harbours
controles = []; // roadblocks
colinas = []; // mountaintops
colinasAA = []; // mountaintops for special purposes (compositions, etc)
artyEmplacements = []; // artillery encampments
seaMarkers = ["seaPatrol","seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14","seaPatrol_15","seaPatrol_16","seaPatrol_17","seaPatrol_18","seaPatrol_19","seaPatrol_20","seaPatrol_21","seaPatrol_22","seaPatrol_23","seaPatrol_24","seaPatrol_25","seaPatrol_26","seaPatrol_27"]; // naval patrol zones

posAntenas = [[16070.8,18728.7,0.954071],[16105.7,18770.7,1.18446],[15110.4,16165.1,0.776001],[16855,13751.4,0.000402451],[11110.4,11832.6,0],[10978.9,16997.1,7.60431],[9907.12,16868.7,0],[8410.67,17166.2,-3.8147e-006],[5809.04,15678,-1.90735e-005],[6539.08,13680.5,0],[6993.03,9640.53,-3.8147e-006],[4971,12145.6,19.5774],[8862.57,11069.1,-0.00062561],[10142.6,7573.33,0.892677],[13022.3,7666.49,0],[16135.4,8015.4,0.00234985],[17036.6,9705.19,-0.00144958],[15731.1,11408.6,0.000213623],[14745.5,14058.3,15.58],[12787.8,5307.9,0.67067],[8886.64,5414,-8.39233e-005],[5151.94,4478.55,0.272263],[8086.47,2926.47,0],[9683.31,2941.17,1.07095],[1915.22,2531.94,4.76837e-007],[2911.67,6244.56,-0.000724792],[2484.53,8348.84,3.8147e-006],[2339.39,11281.3,-0.00195313],[14653,3201.34,0.000709534],[18109.9,2065.21,0.470627],[17163.8,3466.25,0.000549316],[19112.5,6732.14,0],[11691.7,10256.6,-0.00038147]];

posbancos = [];

_terrainObjects = nearestTerrainObjects [[11178.6,8680.91,0], [], 10];
{hideObjectGlobal _x} foreach _terrainObjects;

safeDistance_undercover = 350;
safeDistance_garage = 500;
safeDistance_recruit = 500;
safeDistance_garrison = 500;
safeDistance_fasttravel = 500;

static_defPosHQ = [11181.81,7839.2,0.00124454];

bld_smallBunker = "Land_BagBunker_Small_F";