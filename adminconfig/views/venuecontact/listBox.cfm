<cfoutput>
<cfif StructKeyExists(rc, "message")>
	<div>
		<h3>#rc.message#</h3>
	</div>
</cfif>
<h3>Product Types</h3>
<div>
	<table class="table table-bordered">
		<cfloop array="#rc.venuecontacts#" index="venueContact">
			<tr>
				<td>#venueContact.getContactName()#</td>
				<td><a href="#buildURL(action='adminconfig:venuecontact.edit', querystring='vc=#venueContact.getContactID#')#">edit</td>
				<td>delete</td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>