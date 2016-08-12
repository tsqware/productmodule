<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
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
		<cfif StructKeyExists(rc, "valerrors") and not ArrayIsEmpty(rc.valerrors)>
			<ul>
				<cfloop array="#rc.valerrors#" index="er">
					<li>#er.getMessage()#</li>
				</cfloop>
			</ul>
		</cfif>
	</div>
</cfif>

<cfif StructKeyExists(rc, "prod")>

<form action="#buildURL(argumentcollection='#rc.formAction#')#" method="post">
	<input type="hidden" name="productID" value="#rc.productID#" />
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Form Name</label>
							<input class="form-control" type="text" name="formName" placeholder="Name of Form" maxlength="100" value="#rc.formName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Form Param</label>
							<input class="form-control" type="text" name="formParam" maxlength="100" value="#rc.formParam#" readonly placeholder="Machine Name, dashes allowed, no spaces">
						</div>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<h3 style="margin-top:0px;">Email Notifications</h3>
						<div style="padding-bottom:5px;">
							<h4>To the Venue</h4>
							<p>You will be able to configure email notifications to the venue after saving.</p>
						</div>
						<div>
							<h4>To the Customer</h4>
							<p style="margin-bottom:0px;">You will be able to configure email notifications to the customer after saving.</p>
						</div>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
							
						<h3 style="margin-top:0px;">Required Fields</h3>
						<cfif ArrayIsEmpty(rc.requiredFields)>
							<p>There are no Required Fields created.</p>
						<cfelse>
							<div style="margin-bottom:20px;">
							<cfloop array="#rc.requiredFields#" index="requiredFieldItm">
								<input name="fieldID" type="checkbox" value="#requiredFieldItm.getFieldID()#" />
									#requiredFieldItm.getFieldName()# - <a href="#buildURL(action='adminconfig:requiredfield.edit', querystring='rf=#requiredFieldItm.getFieldID()#')#">edit</a><br />
							</cfloop>
							</div>
						</cfif>
						<div><a href="#buildURL('adminconfig:requiredfield.create')#">Create new Required Field</a></div>						
					</fieldset>
				</div>
			</div>
			<cfif rc.hasPaymentType>	
			<div class="panel panel-default">
				<div class="panel-body">
	
					<fieldset>
						
						<h3 style="margin-top:0px;">Payment Types</h3>
						<cfif ArrayIsEmpty(rc.paymentTypes)>
							<p>There are no Payment Types created.</p>
						<cfelse>
							<div style="margin-bottom:20px;">
							<cfloop array="#rc.paymentTypes#" index="paymentTypeItm">
								<input name="paymentTypeID" type="checkbox" value="#paymentTypeItm.getPaymentTypeID()#" />
									#paymentTypeItm.getPaymentTypeName()#<br />
							</cfloop>
							</div>
						</cfif>
						<div><a href="#buildURL('adminconfig:paymenttype.create')#">Create new Payment Type</a></div>
					</fieldset>
				</div>
			</div>
			</cfif>
		</div>
	</div>
	<div class="row" style="text-align:center;">
		<button type="submit" class="btn">Save</button>
	</div>
</form>
</cfif>
</cfoutput>