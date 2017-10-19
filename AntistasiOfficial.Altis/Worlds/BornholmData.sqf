if !(worldName == "Bornholm") exitWith {};

power = ["power","power_1","power_2","power_3","power_5","power_6","power_8","power_9","power_10"]; // power plants
bases = ["base","base_1","base_2","base_3","base_4","base_5","base_6","base_7","base_9","base_10","base_11","base_12"]; // army bases
aeropuertos = ["airport","airport_1","airport_2"]; // airports
recursos = ["resource","resource_1","resource_2","resource_3","resource_4","resource_5","resource_6","resource_7"]; // resources
fabricas = ["factory","factory_1","factory_2","factory_3","factory_4","factory_5"]; // factories
puestos = ["puesto","puesto_1","puesto_2","puesto_3","puesto_4","puesto_5","puesto_6","puesto_7","puesto_8","puesto_9","puesto_10","puesto_11","puesto_12","puesto_13","puesto_14","puesto_15","puesto_16","puesto_17","puesto_18","puesto_19","puesto_20","puesto_21","puesto_22","puesto_23","puesto_24","puesto_25","puesto_26","puesto_27"]; // outposts
puestosAA = ["puesto_1","puesto_2","puesto_6","puesto_17","puesto_23","puesto_27"]; // AA outposts
puertos = ["puerto","puerto_1","puerto_2","puerto_3","puerto_4"]; // harbours
controles = ["control","control_1","control_2","control_3","control_4","control_5","control_6","control_7","control_8","control_9","control_10","control_11","control_12","control_13","control_14","control_15","control_16","control_17","control_18","control_19","control_20"]; // roadblocks
colinas = []; // mountaintops
colinasAA = []; // mountaintops for special purposes (compositions, etc)
artyEmplacements = ["artillery_1", "artillery_2", "artillery_3", "artillery_4", "artillery_5"]; // artillery encampments
seaMarkers = ["seaPatrol","seaPatrol_1","seaPatrol_2","seaPatrol_3","seaPatrol_4","seaPatrol_5","seaPatrol_6","seaPatrol_7","seaPatrol_8","seaPatrol_9","seaPatrol_10","seaPatrol_11","seaPatrol_12","seaPatrol_13","seaPatrol_14","seaPatrol_15","seaPatrol_16","seaPatrol_17","seaPatrol_18","seaPatrol_19","seaPatrol_20","seaPatrol_21","seaPatrol_22","seaPatrol_23","seaPatrol_24","seaPatrol_25","seaPatrol_26","seaPatrol_27"]; // naval patrol zones

posAntenas = [[19706.8,22039.3,0],[14666.1,11039.6,0],[16337.1,8484.57,-7.62939e-006],[14562.8,5206,-0.000164032],[15014.4,1853.52,1.90735e-006],[9572.47,3798.09,-0.000198364],[12259.7,7643.89,0],[11003.7,10999.8,7.62939e-006],[8378.54,8321.88,-0.000976563],[3349.53,5377.37,0.00136662],[1963.77,8948.32,0],[5390.02,10690.4,0.0220871],[8098.16,14104.1,0],[2950.24,11570.6,0.0131912],[3225.53,15209.5,0],[6484.44,16989.9,-3.8147e-006],[3318.8,18824.8,7.62939e-006]];

posbancos = [];

safeDistance_undercover = 350;
safeDistance_garage = 500;
safeDistance_recruit = 500;
safeDistance_garrison = 500;
safeDistance_fasttravel = 500;

static_defPosHQ = [6765.81,15323.2,0.00124454];

bld_smallBunker = "Land_BagBunker_Small_F";