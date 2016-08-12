<cfoutput>

<h3 style="margin-top:0px;">Leagues</h3>
<cfif rc.hasLeague>
	<div style="">	
		<cfloop array="#rc.selectedLeagues#" index="selectedLeagueItm">
			#selectedLeagueItm.getLeagueName()# - <a href="#buildURL(action='sportsleague.edit', querystring='lg=#selectedLeagueItm.getLeagueID()#')#">edit</a><br />
		</cfloop>	
	</div>
	<div><a href="#buildURL(action='adminconfig:sportsleague.create', querystring='sea=#rc.sea#')#">Create new League for this Season</a></div>
	
<cfelse>
	<p>You will be able to create Leagues once the Season is saved.</p>
</cfif>

</cfoutput>