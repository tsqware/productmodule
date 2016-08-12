<cfset customerChecked = "" />
<cfset venueChecked = "" />
<cfset emailSenderChecked = "" />
<cfset emailRecipientChecked = "" />



<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<cfif StructKeyExists(rc, "productEditLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.productEditLink#')#">Product: #rc.productName#</a>
		</li>
	</cfif>
	<cfif StructKeyExists(rc, "formEditLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.formEditLink#')#">Form Settings: #rc.formName#</a>
		</li>
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

<cfif rc.hasConf>
<form action="#buildURL(argumentcollection='#rc.formAction#')#" method="post">
	<input type="hidden" name="formID" value="#rc.conf#" />
	<div class="row">
		<div class="col-md-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<h4>Form: #rc.formName#</h4>
							<label>Subject</label>
							<input class="form-control" type="text" name="emailSubject" placeholder="Email Subject" maxlength="100" value="#rc.emailSubject#" >
						</div>
						<div style="margin-bottom:20px;">
							<label style="font-weight:bold;">Email Goes to:</label>
							<cfif StructKeyExists(rc, "emailGoesTo") and rc.emailGoesTo neq "">
								<input name="emailGoesToHidden" type="hidden" value="#rc.emailGoesTo#" /><span style="color: ##D40000; font-weight:bold; text-transform:capitalize;">#rc.emailGoesTo#</span><br>
							<cfelse>
								<br />
								<cfif rc.emailGoesTo eq "customer">
									<cfset customerChecked = "checked" />
								<cfelseif rc.emailGoesTo eq "venue">
									<cfset venueChecked = "checked" />
								</cfif>			
								<input name="emailGoesTo" type="radio" value="customer" #customerChecked# /> To the Customer<br>
								<input name="emailGoesTo" type="radio" value="venue" #venueChecked# /> To the Venue
							</cfif>
							
						</div>
						
						<!--- show Sender if goesTo = "customer" --->
						<div style="margin-bottom:10px;" id="emSenderBlock">
							<label style="font-weight:bold;">Email Sender:</label>
							<div>
							<cfif ArrayIsEmpty(rc.EmailSenderList)>
								<p>no Email Senders yet.</p>
							<cfelse>
								<ul style="list-style:none;margin:5px 0px 0px 5px;padding:0px;">
								<cfloop array="#rc.EmailSenderList#" index="emSenderItm">
									<cfif rc.emailSenderID eq emSenderItm.getContactID()>
										<cfset emailSenderChecked = "checked" />
									</cfif>
									<li style="margin:0px;padding:0px;">
									<input type="radio" name="emailSenderID" value="#emSenderItm.getContactID()#" #emailSenderChecked# /> #emSenderItm.getContactName()#
									</li>
								</cfloop>
								</ul>
							</cfif>
							</div>
							
						</div>
						
						<!--- show Recipients if goesTo = "venue" --->
						<div style="margin-bottom:10px;" id="emRecipientBlock">
							<label style="font-weight:bold;">Email Recipients:</label>
							<div>
							<cfif ArrayIsEmpty(rc.EmailRecipientList)>
								<p>no Email Recipients yet.</p>
							<cfelse>
								<ul style="list-style:none;margin:5px 0px 0px 5px;padding:0px;">
								<cfloop array="#rc.EmailRecipientList#" index="emRecipientItm">
									<cfloop list="#rc.emailRecipientID#" index="thisEmRecipient" >
										<cfif thisEmRecipient eq emRecipientItm.getContactID()>
											<cfset emailRecipientChecked = "checked" />
										</cfif>
									</cfloop>
									<li style="margin:0px;padding:0px;">
									<input type="checkbox" name="emailRecipientID" value="#emRecipientItm.getContactID()#" #emailRecipientChecked# /> #emRecipientItm.getContactName()#
									</li>
								</cfloop>
								</ul>
							</cfif>
							</div>
							
						</div>
					</fieldset>
	<div style="text-align:center;">
		<button type="submit" class="btn">Save</button>
	</div>
</form>
</cfif>
</cfoutput>

<script language="javascript">
	$(document).ready(function() {
		$("#emSenderBlock").hide();
		$("#emRecipientBlock").hide();

		var emailGoesToCustOb = $("input[name='emailGoesTo'][value='customer']");
		var emailGoesToVenueOb = $("input[name='emailGoesTo'][value='venue']");
		var emailGoesToVal = "";
		
		if ( $("input[name='emailGoesTo']:checked").length > 0 ) {
			var emailGoesToVal = $("input[name='emailGoesTo']:checked").val();
		}
		else if (
			$("input[name='emailGoesToHidden']")
		) {
			var emailGoesToVal = $("input[name='emailGoesToHidden']").val();
		}

		if (emailGoesToVal == "customer") {
			onClickCustomer();
		}
		else if (emailGoesToVal == "venue") {
			onClickVenue();
		}
		
		emailGoesToCustOb.click(function() {
			onClickCustomer();
		});
		emailGoesToVenueOb.click(function() {
			onClickVenue();
		});
	});
	
	function onClickCustomer() {
		$("#emSenderBlock").show();
		$("#emRecipientBlock").hide();
		$("input[name='emailRecipientID']").each(function(index, item) {
			console.log(item);
			item.checked = false;
		});
	}
	function onClickVenue() {
		$("#emRecipientBlock").show();
		$("#emSenderBlock").hide();
		$("input[name='emailSenderID']:checked").each(function(index, item) {
			item.checked = false;
		});
	}
	
	
</script>