<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<li><a href="#buildURL(action='paymenttype.list')#">Payment Types</a></li>
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
<cfif rc.messagestatus neq "notfound">

<form action="#buildURL(action='adminconfig:paymenttype.doCreate')#" method="post">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Payment Type Name</label>
							<input class="form-control" type="text" name="paymentTypeName" placeholder="Name of Payment Type" maxlength="100" value="#rc.paymentTypeName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Payment Type Param</label>
							<input class="form-control" type="text" name="paymentTypeParam" maxlength="100" value="#rc.paymentTypeParam#" placeholder="Machine Name, dashes allowed, no spaces">
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
</cfif>
</cfoutput>
