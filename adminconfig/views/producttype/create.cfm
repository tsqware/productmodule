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
<h1>Create New Product Type</h1>
<form action="#buildURL(action='producttype.doCreate')#" method="post">
	<div class="col-xs-6">
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<div style="padding-bottom:20px;">
						<label>Product Type Name</label>
						<input type="text" name="productTypeName" placeholder="Name of Product Type" maxlength="100" class="form-control" value="#rc.productTypeName#" >
					</div>
					<div style="padding-bottom:20px;">
						<label>Product Type Param</label>
						<input type="text" name="productTypeParam" maxlength="100" class="form-control" value="#rc.productTypeParam#" placeholder="Machine Name, used for programming">
					</div>
					<div style="padding-bottom:20px;">
						<label>Product Class Param</label>
						<input type="text" name="productTypeClassName" maxlength="100" class="form-control" value="#rc.productTypeClassName#" placeholder="Class Name, used for programming">
					</div>
				</fieldset>
			</div>
		</div>
		<div style="text-align: center">
			<button type="submit" class="btn">Save</button>
		</div>
	</div>
</form>
</cfoutput>