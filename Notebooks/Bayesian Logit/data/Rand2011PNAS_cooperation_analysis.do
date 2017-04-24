clear
insheet using "Rand2011PNAS_cooperation_data.txt"


//////////////////
// Cooperation over round in each treatment
///////////////////
sort condition round_num
by condition round_num: sum decision
by condition: logit2 decision round_num, fcluster(sessionnum) tcluster(playerid)
//  excluding guys with no connections:
by condition round_num: sum decision if num_neighbors>0
by condition: logit2 decision round_num if num_neighbors>0, fcluster(sessionnum) tcluster(playerid)

//////////////////////////////
// No difference in cooperation between fluid and other treatments in round 1
///////////////////////////
char condition[omit] "Fluid"
xi: logit2 decision i.condition  if round_num==1, fcluster(sessionnum) tcluster(playerid)

//////////////////////////
// Difference in cooperation between fluid and other treatments emerges over time
/////////////////////////////
xi: logit2 decision i.fluid*round_num , fcluster(sessionnum) tcluster(playerid)


//////////////////////////////
// Difference in cooperation between fluid and other treatments, rounds 7-11 
///////////////////////////
char condition[omit] "Fluid"
xi: logit2 decision i.condition if round_num>=7, fcluster(sessionnum) tcluster(playerid)
// Fluid vs other 3 combined
xi: logit2 decision i.fluid if round_num>=7, fcluster(sessionnum) tcluster(playerid)

//////////////////////////////
// No sig difference in cooperation between non-fluid treatments
///////////////////////////
// all rounds
char condition[omit] "Random"
xi: logit2 decision i.condition  , fcluster(sessionnum) tcluster(playerid)
char condition[omit] "Static"
xi: logit2 decision i.condition  , fcluster(sessionnum) tcluster(playerid)
// just rounds 7-11 
char condition[omit] "Random"
xi: logit2 decision i.condition  if round_num>=7, fcluster(sessionnum) tcluster(playerid)
char condition[omit] "Static"
xi: logit2 decision i.condition  if round_num>=7, fcluster(sessionnum) tcluster(playerid)


/////////////////////////////
// Cooperators have more connections than defectors in fluid condition
//////////////////
logit2 decision num_neighbors if condition=="Fluid", fcluster(sessionnum) tcluster(playerid)





