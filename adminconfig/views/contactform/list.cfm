<cfoutput>
<cfif StructKeyExists(rc, "message")>
	<div>
		<h3>#rc.message#</h3>
	</div>
</cfif>
<h1>Product Types</h1>
<div>
	<table class="table table-bordered">
		<tr>
			<th>Product Type</th>
			<th>&nbsp;</th>
			<th>&nbsp;</th>
		</tr>
		<cfloop array="#rc.productTypes#" index="productType">
			<tr>
				<td>#productType.getProductTypeName()#</td>
				<td><a href="#buildURL(action='productType.edit', querystring='prodtype=#productType.getProductTypeParam()#')#">edit</td>
				<td>delete</td>
			</tr>
		</cfloop>
	</table>
</div>
</cfoutput>