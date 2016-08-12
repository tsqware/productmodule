<cfcomponent accessors="true">
	<cffunction name="init" access="public" returntype="ProductTransactionReportManager">
		<cfreturn this />		
	</cffunction>
	<cffunction name="loadProductTypes" access="public" returntype="array">
		<cfquery name="qProductTypes" dbtype="hql" datasource="devcpctproducts" >
			SELECT DISTINCT productTypeName from ProductSelected ps
		</cfquery>
		<cfreturn qProductTypes />
	</cffunction>
	<cffunction name="loadProducts" access="public" returntype="array">
		<cfargument name="producttype" type="string" />
		<cfquery name="qProducts" dbtype="hql" datasource="devcpctproducts">
			SELECT DISTINCT productName, productClassParam
			FROM ProductSelected
			WHERE productTypeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.producttype#">
			
		</cfquery>
		<cfreturn qProducts />
	</cffunction>
	<cffunction name="loadPendingTransactionCount" access="public" returntype="any">
		<cfargument name="product" type="string" />
		<cfquery name="qCountPending">
			SELECT Count(tr.transactionID) as num
				from tr_transactions tr 
				INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
				WHERE tr.transactionStatus = 'pending'
				AND ps.productName = '#product#'
		</cfquery>
		<cfdump var="#qCountPending#" />
		<cfreturn qCountPending />
	</cffunction>
	<cffunction name="getProductsForDashboard" access="public" returntype="array">
		<cfset var productTypes = [] />
		<cfset var products = [] />
		<cfset productTypeNames = loadProductTypes() />
		<cfdump var="#productTypeNames#" label="productTypeNames" />
		<cfscript>
			for (row in productTypeNames) {
				WriteDump(var=row, label="row");
				WriteDump(productTypeNames[1]);
				if (row eq productTypeNames[1]) {
			ptstruct = {};
			ptstruct.name = row['productTypeName'];				
			
			var getproducts = loadProducts(row['productTypeName']);
			parray = [];
				
			for (row2 in getproducts) {
				pstruct = {};
				pstruct.productname = row2['productName'];
				pstruct.productClassParam = row2['productClassParam'];
				tra = loadPendingTransactionCount(row2['productName']);
				pstruct.pendingtransactions = tra;
				ArrayAppend(products, pstruct);
			}
			ArrayAppend(productTypes, ptstruct);
			ptstruct.products = products;	}	
			//
		}
		</cfscript>
		<cfreturn productTypes />
	</cffunction>
	<cffunction name="loadTransactionByID" access="public" returntype="any">
		<cfargument name="trID" type="numeric">
		<cfset trDao = new pmdao.ProductTransactionDAO().init() />
		<cfset trSvc = new ProductTransactionService(trDao) />
		<cfset tr = trSvc.load(trID) />
		<cfreturn tr />
	</cffunction> 	
</cfcomponent>