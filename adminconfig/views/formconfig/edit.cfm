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
	

<form action="#buildURL(action='adminconfig:formconfig.doEdit', querystring='conf=#rc.conf#')#" method="post">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Form Name</label>
							<p class="termdescription">Name of the form, as it appears in the main heading.</p>
							<input class="form-control" type="text" name="formName" placeholder="Name of Form" maxlength="100" value="#rc.formName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Form Param</label>
							<p class="termdescription">For Developers - the name that is used to identify the form in programming.</p>
							<input class="form-control" type="text" name="formParam" maxlength="100" value="#rc.formParam#" readonly placeholder="Machine Name, dashes allowed, no spaces">

						</div>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<h3 style="margin-top:0px;">Email Notifications</h3>
						<p class="termdescription">If you wish to send a email to venue or the customer after the form for this product is completed, click the Edit button next to the name below.</p>
						<div style="padding-bottom:20px;">
							<h4>To the Venue</h4>
							<cfif rc.hasVenueEmailNotification>
								<cfloop array="#rc.selectedEmailsToVenue#" index="vnot">
									#vnot.getEmailSubject()# - <a class="jumpto" href="#buildURL(action='adminconfig:emailnotification.edit', querystring='emnot=#vnot.getEmailNotificationID()#')#">edit</a><br />
								</cfloop>
							<cfelse>
								<p><a class="jumpto" href="#buildURL(action='adminconfig:emailnotification.create', querystring='conf=#rc.conf#&goesto=venue')#">Create new Venue Email Notification</a></p>
							</cfif>
						</div>
						<div style="padding-bottom:20px;">
							<h4>To the Customer</h4>
							<cfif rc.hasCustEmailNotification>
								<cfloop array="#rc.selectedEmailsToCustomer#" index="cnot">
									#cnot.getEmailSubject()# - <a class="jumpto" href="#buildURL(action='adminconfig:emailnotification.edit', querystring='emnot=#cnot.getEmailNotificationID()#')#">edit</a><br />
								</cfloop>
							<cfelse>
								<p><a class="jumpto" href="#buildURL(action='adminconfig:emailnotification.create', querystring='conf=#rc.conf#&goesto=customer')#">Create new Customer Email Notification</a></p>
							</cfif>			
						</div>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">	
	
					<fieldset>
							
						<h3 style="margin-top:0px;">Required Fields</h3>
						<p class="termdescription">The are form fields that are required to complete the form. These are limited to the form fields commonly used in our forms: first name, last name, address, email, etc. <strong>Not to be used for fields specific to a particular form.</strong></p>
						<cfif ArrayIsEmpty(rc.requiredFields)>
							<p>There are no Required Fields created.</p>
						<cfelse>
							<div style="margin-bottom:20px;">
								
							<cfloop array="#rc.requiredFields#" index="requiredFieldItm">
								<cfset requiredFieldChecked = "" />
							
								<cfif rc.hasRequiredField>
									<cfloop array="#rc.selectedRequiredFields#" index="selRequiredFieldItm">
										<cfif selRequiredFieldItm.getFieldID() eq requiredFieldItm.getFieldID()>
											<cfset requiredFieldChecked = 'checked="checked"' />
											<cfbreak />
										</cfif>
									</cfloop>
								</cfif>
								<input name="fieldID" type="checkbox" value="#requiredFieldItm.getFieldID()#" #requiredFieldChecked# />
									#requiredFieldItm.getFieldName()# - <a class="jumpto" href="#buildURL(action='adminconfig:requiredfield.edit', querystring='rf=#requiredFieldItm.getFieldID()#&conf=#rc.conf#')#">edit</a><br />
							</cfloop>
							</div>
						</cfif>
						<div><a class="jumpto" 
								href="#buildURL(action='adminconfig:requiredfield.create', querystring='conf=#rc.conf#')#">Create new Required Field</a></div>
						
						
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
								<cfset ptchecked = "" />
								<cfloop array="#rc.paymentTypesForForm#" index="paymentTypeSel">
									<cfif paymentTypeSel.getPaymentTypeID() eq paymentTypeItm.getPaymentTypeID()>
										<cfset ptchecked = "checked" />
									</cfif>
								</cfloop>
								<input name="paymentTypeID" type="checkbox" value="#paymentTypeItm.getPaymentTypeID()#" #ptchecked# />
									#paymentTypeItm.getPaymentTypeName()#<br />
							</cfloop>
							</div>
						</cfif>
						<div><a href="#buildURL(action='adminconfig:paymenttype.create', querystring='conf=#rc.conf#')#">Create new Payment Type</a></div>
						
						
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

<script language="javascript">
	$('.jumpto').click(function() {
		return onGoToPage(this.href);
	});
	function onGoToPage(target) {

		console.log(target);
		if (confirm("WARNING! All unsaved settings will be lost.\nAre you sure you want to leave this page?") == true) {
	        location.href = target;
	    } else {
	        alert('Navigation canceled.');
	        return false;
	    }
	    return true;
	}
</script>
</cfoutput>