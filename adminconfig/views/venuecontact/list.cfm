<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<li class="active">#rc.title#</li>
</ol>
<!-- end venue nav -->

<h1>#rc.title#</h1>

<cfif StructKeyExists(rc, "message")>
	<div>
		<h3>#rc.message#</h3>
	</div>
</cfif>

<div>
	<table class="table table-bordered">
		<tr>
			<th>Name</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		<cfloop array="#rc.venuecontacts#" index="venuecontact">
			<tr>
				<td>#venuecontact.getContactName()#</td>
				<td><a href="#buildURL(action='adminconfig:venuecontact.edit', querystring='vc=#venuecontact.getContactID()#')#">edit</td>
				<td>delete</td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>