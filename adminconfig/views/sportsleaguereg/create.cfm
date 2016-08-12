<cfoutput>

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
		<cfif not ArrayIsEmpty(rc.valerrors)>
			<ul>
				<cfloop array="#rc.valerrors#" index="er">
					<li>#er.getMessage()#</li>
				</cfloop>
			</ul>
		</cfif>
	</div>
</cfif>

<form action="#buildURL(action='adminconfig:sportsleaguereg.doCreate')#" method="post">
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
							<label>Product URL Param</label>
							<p class="termdescription">The name that is used in the web address to identify the product.</p>
							<input type="text" name="productURLParam" maxlength="100"  class="form-control" value="#rc.productURLParam#" placeholder="Machine Name, used for programming">
						</div>
						<div style="padding-bottom:20px;">
							<label>Product Class Name</label>
							<p class="termdescription">For Developers - this is the name of the component associated with this product.</p>
							<input type="text" name="productClassName" maxlength="100"  class="form-control" value="#rc.productClassName#" placeholder="Machine Name, used for programming">
						</div>
						<div style="padding-bottom:20px;">
							<label>Sold Out</label>
							<input type="radio" name="isSoldOut" value="1" <cfif IsBoolean(rc.isSoldOut) and rc.isSoldOut eq true> checked="checked"</cfif> placeholder="Machine Name, used for programming"> Yes
							<input type="radio" name="isSoldOut" value="0" <cfif IsBoolean(rc.isSoldOut) and rc.isSoldOut eq false> checked="checked"</cfif> placeholder="Machine Name, used for programming"> No
						</div>
						<div>
							<label>Product Type</label>
							<cfif StructKeyExists(rc, "productTypeName")>
								#rc.productTypeName#
								<input type="hidden" name="productTypeID" value="#rc.productTypeID#" />
							<cfelse>
								<ul>
									<cfloop array="#rc.productTypes#" index="pt">
										<li><input type="radio" name="productTypeID" value="#pt.getProductTypeID()#"></li>
									</cfloop>
								</ul>
							</cfif>
						</div>	
						
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">		
					<fieldset>						
						<h3 style="margin-top:0px;">Seasons</h3>
						<p class="termdescription">This is where you create new league seasons, including dates, prices, and leagues.</p>

						<p>You will be able to add seasons once the product is saved.</p>
						
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
								<input name="contactID" type="checkbox" value="#venueContactItm.getContactID()#" />
									#venueContactItm.getContactName()# - edit<br />
							</cfloop>
							</div>
						</cfif>
						<div><p>You will be able to create new Venue Contacts once the product is saved.</p></div>
						
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<h3>Form Settings</h3>
						<p class="termdescription">This is where you set the form name, who receives the forms, who sends the email confirmation, etc.</p>
						
						<p>You will be able to configure form settings once the product is saved.</p>
						
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<div class="row" style="text-align:center;">
		<button type="submit" class="btn">Save</button>
	</div>
</form>

</cfoutput>