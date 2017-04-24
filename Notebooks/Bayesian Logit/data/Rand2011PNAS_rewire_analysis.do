clear
insheet using "Rand2011PNAS_rewire_data.txt"


////////////////////
// fig2A - tie reciprocity
//
//    more likely to make link w C
xi: logit2 nowtie otherd   if previouslytie==0 , fcluster(sessionnum) tcluster(playerid)
xi: logit2 nowtie otherd  roundnum if previouslytie==0 , fcluster(sessionnum) tcluster(playerid)
//    and to break link with D
xi: logit2 nowtie otherd   if previouslytie==1 , fcluster(sessionnum) tcluster(playerid)
xi: logit2 nowtie otherd  roundnum if previouslytie==1 , fcluster(sessionnum) tcluster(playerid)
//    but more discriminating with breaking links
logit act otherd  if  ( (previouslytie ==1 & otherd==1) | (previouslytie ==0 & otherd==0))
logit act otherd roundnum if  ( (previouslytie ==1 & otherd==1) | (previouslytie ==0 & otherd==0))


////////////////////////////
// SI analysis showing CC vs CD vs DD link survival
//
//  CC v CD/DC
logit2 break cc if previouslytie==1  & (state=="CC" | state=="CD" | state=="DC"), fcluster(sessionnum) tcluster(playerid)
//  CC V DD
logit2 break cc if previouslytie==1  & (state=="CC" | state=="DD"), fcluster(sessionnum) tcluster(playerid)
//  DD v CD/DC
logit2 break dd if previouslytie==1  & (state=="DD" | state=="CD" | state=="DC"), fcluster(sessionnum) tcluster(playerid)


