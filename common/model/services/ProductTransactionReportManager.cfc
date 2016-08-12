<cfcomponent accessors="true">
	
	<cffunction name="init" access="public" returntype="ProductTransactionReportManager">
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="loadProductTypes" access="public" returntype="query">
		<cfquery name="qProductTypes">
			SELECT DISTINCT ps.productTypeName from tr_transactions tr 
			INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
		</cfquery>
		<cfreturn qProductTypes />
	</cffunction>
	
	<cffunction name="loadProducts" access="public" returntype="query">
		<cfargument name="producttype" type="string" />
		<cfquery name="qProducts">
			SELECT DISTINCT ps.productName, ps.productClassParam from tr_transactions tr
			INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
			WHERE ps.productTypeName=
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.producttype#">
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
		<cfreturn qCountPending.num />
	</cffunction>
	
	<cffunction name="getProductsForDashboard" access="public" returntype="array">
		<cfset var productTypes = [] />
		<cfset var products = [] />
		<cfset productTypeNames = loadProductTypes() />
		<cfdump var="#productTypeNames#" />
		<cfscript>
			for (row in productTypeNames) {
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
			ptstruct.products = products;		
			//
		}
		</cfscript>
		<cfreturn productTypes />
	</cffunction>
	
	<cffunction name="processTransaction" access="public" returntype="string">
		<cfargument name="id" type="numeric" required="true">
		<cfargument name="stat" type="string" required="true">
		<cfargument name=admUser type="string" required="true" />
		
		<cfset var dao = CreateObject("component", "pmdao.ProductTransactionDAO").init()>
		<cfset var svc = CreateObject("component", "pmservices.ProductTransactionService").init(dao)>
		
			
		<!--- decrypt credit card --->
		
		<cfscript>
			var ent = svc.load(id);
			if (IsBoolean(ent)) return false;
			
			var payment = ent.getPayment();
			
			var encrypted = payment.getCreditCardNum();
			var theKey = payment.getCryptKey();		
			var decrypted = payment.decryptCreditCard(encrypted, theKey);
			var chopped = payment.chopDecrypted(decrypted);
			
			payment.setCreditCardNum(chopped);
			ent.setTransactionStatus(stat);
			ent.setAdminUserName(admUser);
			ent.setProcessDate(CreateODBCDateTime(now()));
			
			var txn = ORMGetSession("devcpctproducts").beginTransaction();
			try {
				svc.save(ent);
				txn.commit();
			}
			catch(any e) {
				txn.rollback();
				throw e;
			}
			if (txn.wasCommitted()) {
				
				return stat;
			}
		</cfscript>
		
		<cfreturn false />
	</cffunction> 
	
	<cffunction name="loadTransactionByID" access="public" returntype="any">
		<cfargument name="trID" type="numeric">
		<cfset trDao = new pmdao.ProductTransactionDAO().init() />
		<cfset trSvc = new ProductTransactionService(trDao) />
		<cfset tr = trSvc.load(trID) />
		<cfreturn tr />
	</cffunction> 	
	
</cfcomponent>