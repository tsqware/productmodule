<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<cfif StructKeyExists(rc, "productEditLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.productEditLink#')#">
			Product: #rc.productName#
			</a>
		</li>
	</cfif>
	<cfif StructKeyExists(rc, "seasonLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.seasonLink#')#">
				#rc.seasonName#
			</a>
		</li>
	</cfif>
	<li class="active">#rc.title#</li>
</ol>
<!-- end venue nav -->

<h1>#rc.title#</h1>
<cfif StructKeyExists(rc, "productName")>
	<h3 style="margin:0px;">#rc.productName#</h3>
</cfif>
<cfif StructKeyExists(rc, "seasonName")>
	<h3 style="margin:0px;">#rc.seasonName#</h3>
</cfif>

<cfif StructKeyExists(rc, "message")>
	<div>
		<h3>#rc.message#</h3>
		<cfif not ArrayIsEmpty(rc.valerrors)>
			<ul>
				<cfloop array="#rc.valerrors#" index="er">
					<li>#er.getMessage()#</li>
				</cfloop>
			</ul>
		</cfif>
	</div>
</cfif>

<form action="#buildURL(action='adminconfig:sportsleaguedivision.doEdit', querystring='div=#rc.div#')#" method="post">
	<input type="hidden" name="seasonID" value="#rc.seasonID#" />
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Division Name</label>
							<input class="form-control" type="text" name="divisionName" placeholder="Name of Division" maxlength="100" value="#rc.divisionName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Product Param</label>
							<input class="form-control" type="text" name="divisionParam" maxlength="100" value="#rc.divisionParam#" placeholder="Machine Name, used for programming">
						</div>			
					</fieldset>
				</div>
			</div>
			<div class="row" style="text-align:center;">	
				<button type="submit" class="btn">Save</button>
			</div>
		</div>
	</div>
	
	
	</form>

</cfoutput>