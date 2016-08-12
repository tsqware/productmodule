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
	<cfif StructKeyExists(rc, "formEditLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.formEditLink#')#">
				Form Settings: #rc.formName#
			</a>
		</li>
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

<form action="#buildURL(argumentcollection='#rc.formAction#')#" method="post">
	<div class="row">
		<div class="col-md-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Field Name</label>
							<input class="form-control" type="text" name="fieldName" placeholder="Field Label in the form" value="#rc.fieldName#" />
						</div>
						<div style="padding-bottom:20px;">
							<label>Field Param</label>
							<input class="form-control" type="text" name="fieldParam" value="#rc.fieldParam#" placeholder="Machine Name, dashes allowed, no spaces" />
						</div>
					</fieldset>
				</div>
			</div>
		</div>		
	</div>
	<div class="row" style="text-align:center;">
		<div class="col-md-6">
		<button type="submit" class="btn">Save</button>
		</div>
	</div>
</form>
</cfoutput>