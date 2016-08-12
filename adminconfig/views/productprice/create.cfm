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
	<cfif StructKeyExists(rc, "seasonLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.seasonLink#')#">
				#rc.seasonName#
			</a>
		</li>
	</cfif>
	<cfif StructKeyExists(rc, "leagueLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.leagueLink#')#">
				 #rc.leagueName#
			</a>
		</li>
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
		<cfif StructKeyExists(rc, "valerrors") and not ArrayIsEmpty(rc.valerrors)>
			<ul>
				<cfloop array="#rc.valerrors#" index="er">
					<li>#er.getMessage()#</li>
				</cfloop>
			</ul>
		</cfif>
	</div>
</cfif>
<cfif rc.messagestatus neq "notfound">	

<form action="#buildURL(action='adminconfig:productprice.doCreate', querystring='prod=#rc.prod#')#" method="post">
	<input type="hidden" name="priceTypeID" value="#rc.priceTypeID#" />
	<input type="hidden" name="pricetype" value="#rc.pricetype#" />
	<input type="hidden" name="productID" value="#rc.productID#" />
	<input type="hidden" name="productTypeID" value="#rc.productTypeID#" />
	
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Price Name</label>
							<p class="termdescription">The name to be displayed on the public website.</p>
							<input class="form-control" type="text" name="priceName" placeholder="Name of Price" maxlength="100" value="#rc.priceName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Price Param</label>
							<p class="termdescription">For Developers - The name that is used in the web address in the admin.</p>
							<input class="form-control" type="text" name="priceParam" maxlength="100" value="#rc.priceParam#" placeholder="Machine Name, dashes allowed, no spaces">
						</div>
						<div style="padding-bottom:20px;">
							<label>Price Amount</label>
							<input class="form-control" type="text" name="priceAmount" maxlength="7" style="width:80px;" value="#rc.priceAmount#" placeholder="Money">
						</div>
						
					</fieldset>
				</div>
			</div>
			
		</div>
	</div>
	<div class="row" style="text-align:center;">	
		<button type="submit" class="btn">Save</button>
	</div>
</form>
</cfif>
</cfoutput>