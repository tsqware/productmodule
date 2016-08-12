<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<li><a href="#buildURL(action='venuecontact.list')#">Venue Contacts</a></li>
	<cfif StructKeyExists(rc, "productEditLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.productEditLink#')#">
				Product: #rc.productName#
			</a></li>
		</cfif>
	<li class="active">#rc.title#</li>
</ol>
<!-- end venue nav -->

<h1>#rc.title#</h1>
<cfif StructKeyExists(rc, "productTypeName")>
	<h3>For Product: #rc.productName#</h3>
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

<form action="#buildURL(argumentcollection='#rc.formAction#')#" method="post">
	<cfif IsDefined("rc.prod")>
		<input type="hidden" name="productID" value="#rc.prod#" />
	</cfif>
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Contact First Name</label>
							<input class="form-control" type="text" name="contactName" placeholder="Contact Name" maxlength="100" value="#rc.contactName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Contact Email</label>
							<input class="form-control" type="text" name="contactEmail" maxlength="100" value="#rc.contactEmail#" placeholder="Contact Email">
						</div>
						<div style="padding-bottom:20px;">
							<label>Contact Phone</label>
							<input class="form-control" type="text" name="contactPhone" maxlength="100" value="#rc.contactPhone#" placeholder="Phone">
						</div>						
					</fieldset>
				</div>
			</div>
			<div style="text-align: center;">
				<button type="submit" class="btn">Save</button>
			</div>
		</div>
	</div>
</form>
</cfoutput>