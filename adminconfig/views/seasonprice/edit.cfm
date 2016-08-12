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
		<cfif StructKeyExists(rc, "seasonLink")>
			<li>
				<a href="#buildURL(argumentcollection='#rc.seasonLink#')#">
					#rc.seasonName#
				</a>
			</li>
		</cfif>
	</cfif>
	<li class="active">#rc.title#</li>
</ol>
<!-- end venue nav -->

<h1>#rc.title#</h1>
<cfif StructKeyExists(rc, "productName")>
	<h3 style="margin:0px;">#rc.productName#</h3>
</cfif>
<cfif StructKeyExists(rc, "seasonName")>
	<h3 style="margin-top:0px;margin-bottom:20px;">#rc.seasonName#</h3>
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
	<form action="#buildURL(action='adminconfig:seasonprice.doEdit', querystring='seaprice=#rc.seaprice#')#" method="post">
		<input type="hidden" name="priceTypeID" value="#rc.priceTypeID#" />
		<input type="hidden" name="pricetype" value="#rc.pricetypeName#" />		
		<input type="hidden" name="seasonID" value="#rc.seasonID#" />

		<div class="row">
			<div class="col-xs-6">
				<div class="panel panel-default">
					<div class="panel-body">	
						<fieldset>
							<div style="padding-bottom:20px;">
								<label>Price Name</label>
								<input class="form-control" type="text" name="priceName" placeholder="Name of Price" maxlength="100" value="#rc.priceName#" >
							</div>
							<div style="padding-bottom:20px;">
								<label>Price Param</label>
								<input class="form-control" type="text" name="priceParam" maxlength="100" value="#rc.priceParam#" placeholder="Machine Name, dashes allowed, no spaces">
							</div>
							<div style="padding-bottom:20px;">
								<label>Price Amount</label>
								<input class="form-control" type="text" name="priceAmount" maxlength="7" style="width:80px;" value="#rc.priceAmount#" placeholder="Money">
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