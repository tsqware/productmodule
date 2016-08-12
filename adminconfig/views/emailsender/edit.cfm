<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<li><a href="#buildURL(action='emailsender.list')#">Email Senders</a></li>
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

<form action="#buildURL(action='adminconfig:emailsender.doEdit', querystring='emsend=rc.emsend')#" method="post">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Sender Name</label>
							<input class="form-control" type="text" name="contactName" placeholder="Sender Name - can be a person or department" maxlength="100" value="#rc.contactName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Sender Email</label>
							<input class="form-control" type="text" name="contactEmail" maxlength="100" value="#rc.contactEmail#" placeholder="Sender Email">
						</div>
						<div style="padding-bottom:20px;">
							<label>Sender Phone</label>
							<input class="form-control" type="text" name="contactPhone" maxlength="100" value="#rc.contactPhone#" placeholder="Sender Phone">
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