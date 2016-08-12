<cfoutput>
<cfinclude template='/productmodule/includes/assets/js/adm_datepicker_defaultdate.cfm' />

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
<form action="#buildURL(action='adminconfig:contactform.doEdit', querystring='prod=#rc.prod#')#" method="post">
	<div class="row">
		<div class="col-md-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Product Name</label>
							<p class="termdescription">The name that identifies the product in the admin.<br />
								The form name is different, it is set in the Form Settings screen.</p>
							<input type="text" name="productName" placeholder="Name of Product" maxlength="100" class="form-control" value="#rc.productName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Product URL Param</label><br />
							<p class="termdescription">The name that is used in the web address to identify the product.</p>
							<input type="text" name="productURLParam" maxlength="100" class="form-control" value="#rc.productURLParam#" placeholder="Machine Name, used for programming">
						</div>
						<div style="padding-bottom:20px;">
							<label>Product Class Name</label><br />
							<p class="termdescription">For Developers - this is the name of the component associated with this product.</p>
							<input type="text" name="productClassName" maxlength="100" class="form-control" value="#rc.productClassName#" placeholder="Machine Name, used for programming">
						</div>
						<div style="padding-bottom:20px;">
							<label>Sold Out</label>
							<input type="radio" name="isSoldOut" value="1" <cfif IsBoolean(rc.isSoldOut) and rc.isSoldOut eq true> checked="checked"</cfif> placeholder="Machine Name, used for programming"> Yes
							<input type="radio" name="isSoldOut" value="0" <cfif IsBoolean(rc.isSoldOut) and rc.isSoldOut eq false> checked="checked"</cfif> placeholder="Machine Name, used for programming"> No
						</div>
						<div>
							<h5 style="margin:0px;">Product Type: #rc.productTypeName#</h5>				
						</div>	
						
					</fieldset>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>					
						<h3>Venue Contacts</h3>
						<p class="termdescription">This is the information where you see "For more information, contact..."</p>
						<cfif ArrayIsEmpty(rc.VenueContacts)>
							<p>There are no Venue Contacts created.</p>
						<cfelse>
							<div style="margin-bottom:20px;">
							<cfloop array="#rc.VenueContacts#" index="venueContactItm">
								<cfset venueContactChecked = "" />
								<cfloop array="#rc.selectedVenueContacts#" index="selectedVenueContact">
									<cfif selectedVenueContact.getContactID() eq venueContactItm.getContactID()>
										<cfset venueContactChecked = 'checked="checked"' />
									</cfif>
								</cfloop>
								<input name="contactID" type="checkbox" value="#venueContactItm.getContactID()#" #venueContactChecked# />
									#venueContactItm.getContactName()#
									- <a class="jumpto" href="#buildURL(action='venuecontact.edit', querystring='vc=#venueContactItm.getContactID()#&prod=#rc.prod#')#">edit</a><br />
							</cfloop>
							</div>
						</cfif>
						<div><a class="jumpto" href="#buildURL(action='adminconfig:venuecontact.create', querystring='prod=#rc.prod#')#">Create new Venue Contact for this product</a></div>
						
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<h3>Form Settings</h3>
						<p class="termdescription">This is where you set the form name, who receives the forms, who sends the email confirmation, etc.</p>

						<cfset hasFormConfig = false />
						<cfif rc.hasFormConfig>
							#rc.selectedFormConfig.getFormName()# - <a class="jumpto" href="#buildURL(action='adminconfig:formconfig.edit', querystring='conf=#rc.selectedFormConfig.getFormConfigID()#')#">edit</a><br />
								
						<cfelse>
							<p>No configuration set up.</p>
							<div><a class="jumpto" href="#buildURL(action='adminconfig:formconfig.create', querystring='prod=#rc.prod#')#">Create new Form Configuration</a></div>
						</cfif>
					</fieldset>
				</div>
			</div>
	</div>
	<div class="row" style="text-align:center;">
		<button type="submit" class="btn">Save</button>
	</div>
</form>
</cfif>
</cfoutput>

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