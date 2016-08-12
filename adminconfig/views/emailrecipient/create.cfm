<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<li><a href="#buildURL(action='emailrecipient.list')#">Email Recipients</a></li>
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

<form action="#buildURL(action='adminconfig:emailrecipient.doCreate')#" method="post">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Recipeint Name</label>
							<input class="form-control" type="text" name="contactName" placeholder="Recipient Name - can be a person or department" maxlength="100" value="#rc.contactName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Contact Email</label>
							<input class="form-control" type="text" name="contactEmail" maxlength="100" value="#rc.contactEmail#" placeholder="Recipient Email">
						</div>
						<div style="padding-bottom:20px;">
							<label>Contact Phone</label>
							<input class="form-control" type="text" name="contactPhone" maxlength="100" value="#rc.contactPhone#" placeholder="Recipient Phone">
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