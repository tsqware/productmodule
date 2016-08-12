<cfoutput>
<h3 style="margin-top:0px;">Divisions</h3>
<cfif  rc.hasDivision >
	<div style="">	
		<cfloop array="#rc.selectedDivisions#" index="selectedDivisionItm">
			#selectedDivisionItm.getDivisionName()# - <a href="#buildURL(action='sportsseasondivision.edit', querystring='div=#selectedDivisionItm.getDivisionID()#')#">edit</a><br />
		</cfloop>	
	</div>
	<div><a href="#buildURL(action='adminconfig:sportsseasondivision.create', querystring='sea=#rc.sea#')#">Create new Division for this Season</a></div>	
<cfelse>	
	<p>You will be able to create Divisions once the Season is saved.</p>	
</cfif>
</cfoutput>