<cfoutput>
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
<h1>Create New #rc.priceTypeName#</h1>
<form action="#buildURL(action='adminconfig:price.doCreate', querystring='pricetype=#rc.pricetype#')#" method="post">
	<input type="hidden" name="priceTypeID" value="#rc.priceTypeID#" />
	<fieldset style="padding:20px; margin:0px; margin-bottom:20px;">
		<div style="padding-bottom:20px;">
			<label>Price Name</label>
			<input type="text" name="priceName" placeholder="Name of Price" maxlength="100" style="width:300px;" value="#rc.priceName#" >
		</div>
		<div style="padding-bottom:20px;">
			<label>Price Param</label>
			<input type="text" name="priceParam" maxlength="100" style="width:300px;" value="#rc.priceParam#" placeholder="Machine Name, dashes allowed, no spaces">
		</div>
		<div style="padding-bottom:20px;">
			<label>Price Amount</label>
			<input type="text" name="priceAmount" maxlength="7" style="width:80px;" value="#rc.priceAmount#" placeholder="Money">
		</div>
		
		<button type="submit" class="btn">Save</button>
	</fieldset>
</form>
</cfif>
</cfoutput>