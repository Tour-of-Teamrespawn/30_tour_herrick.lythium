private ["_pos"];

_locations = [[9375.09,12280.4,0],[9529.69,12072.2,0],[9493.41,11812.6,0],[9253.37,11659.9,0],[9237.86,11550.4,0],[9967.43,11347.3,0],[9980.34,11133.3,0],[10188.6,11252.9,0],[10498.9,10982.3,0],[10327.1,10845.1,0],[10290.5,10644.2,0],[10473.1,10604.6,0],[9196.67,10833.6,0],[9105.55,10746.6,0],[8986.36,10748.6,0],[8833.92,10910.2,0],[8928.24,10966.1,0],[9662.67,10508.8,0],[9776.31,10431.2,0],[9739,10829.4,0]];

_time = time + 5;
while {true} do 
{
	_pos = _locations call BIS_fnc_selectRandom;
	if ({((alive _x) && ((vehicle _x) distance _pos < 300)) or (_pos in TOUR_taskLocations)}count (playableUnits + switchableunits) == 0) exitWith {TOUR_tskAccept = true};
	if (time > _time) exitWith {TOUR_tskAccept = false};
	sleep 0.05;
};

if !(TOUR_tskAccept) exitWith {};

if (str getMarkerPos "TOUR_mkr_tskAssault" == "[0,0,0]") then 
{
	_mkr = createMarker ["TOUR_mkr_tskAssault", _pos];
}else
{
	"TOUR_mkr_tskAssault" setMarkerPos _pos;
};

TOUR_taskLocations pushBack _pos;

["TOUR_objAssault", {"Assault Compound"}] call A2S_createSimpleTask;
["TOUR_objAssault", {"Assault the <marker name=""TOUR_mkr_tskAssault"">compound</marker> and eliminate all hostiles."}, {"Assault Compound"}, {"Assault Compound"}] call A2S_setSimpleTaskDescription;
"TOUR_objAssault" call A2S_taskCommit;
sleep 1;
"TOUR_objAssault" call A2S_taskHint;

waitUntil 
{
	sleep 5;
	(({(side _x == EAST) && (alive _x) && ((vehicle _x) distance _pos < 60)}count allunits == 0) && ({(alive _x) && ((vehicle _x) distance _pos < 50)}count (playableUnits + switchableunits) > 0))
};

["TOUR_objAssault", "SUCCEEDED"] call A2S_setTaskState;
"TOUR_objAssault" call A2S_taskCommit;
sleep 2;
"TOUR_objAssault" call A2S_taskHint;

sleep 60;

TOUR_taskLocations delteAt (TOUR_taskLocations find _pos);

//remove task?