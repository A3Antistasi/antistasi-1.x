if !(worldName == "Malden") exitWith {};

call compile preprocessFileLineNumbers "roadsDB.sqf";

power = ["power_1","power_2","power_3"]; // power plants
bases = ["base_1","base_2"]; // army bases
aeropuertos = ["airport_1","airport_2"]; // airports
recursos = ["resource_1","resource_2","resource_3","resource_4"]; // resources
fabricas = ["factory_1","factory_2"]; // factories
puestos = ["puesto_1","puesto_2","puesto_3"]; // outposts
puestosAA = ["puestoAA_1","puestoAA_2","puestoAA_3"]; // AA outposts
puertos = ["puerto_1","puerto_2","puerto_3","puerto_4","puerto_5","puerto_6"]; // harbours
controles = ["control_1","control_2","control_3"]; // roadblocks
colinas = []; // mountaintops
colinasAA = []; // mountaintops for special purposes (compositions, etc)
artyEmplacements = ["artillery_1","artillery_2","artillery_3"]; // artillery encampments
seaMarkers = ["seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14",]; // naval patrol zones

posAntenas = [[7001.08,10034.1,0],[7057.09,9932.42,0],[9635.78,3309.5,0],[11320,4122.09,0]];

posbancos = [[5549.48,7036.58,0],[5409.55,2786.7,0],[5895.06,3498.52,0],[7075.43,7136.82,0],[3557.67,8506.6,0],[3180.11,6338.45,0],[3744.26,3249.65,0]];

defaultPopulation = 7060;

safeDistance_undercover = 250;
safeDistance_garage = 200;
safeDistance_recruit = 200;
safeDistance_garrison = 200;
safeDistance_fasttravel = 250;

static_defPosHQ = [];

bld_smallBunker = "Land_BagBunker_01_small_F";