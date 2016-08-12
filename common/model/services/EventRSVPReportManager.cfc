<cfcomponent accessors="true">
	<cfproperty name="ProductTransactionReportManager">
	
	<cffunction name="init" access="public" returntype="EventRSVPReportManager">
		<cfset setProductTransactionReportManager(new ProductTransactionReportManager())>
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="getProductsForDashboardByProduct" access="public" returntype="any">
		<cfargument name="eventtype">
		<cfset var products = [] />
		<cfscript>
			ptstruct = {};
			ptstruct.name = eventtype;
			var tMgr = getProductTransactionReportManager();			
			
			var getproducts = tMgr.loadProducts(eventtype);
			parray = [];
			for (prodrow in getproducts) {
				pstruct = {};
				
				pstruct.productname = prodrow['productName'];
				pstruct.productClassParam = prodrow['productClassParam'];
				
				tra = loadTransactionCount(prodrow['productClassParam']);
				pstruct.pendingtransactions = tra;
				
				tr = loadTransactions(prodrow['productClassParam']);
				pstruct.pendingtransactionslist = tr;
				
				ArrayAppend(products, pstruct);
			}			
			ptstruct.products = products;
		</cfscript>
		<cfreturn ptstruct />
	</cffunction>
	
	<cffunction name="getLatestEventDate" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qProductTypes">
			SELECT MAX(it.eventStart) as mr from tr_transactions tr 
			INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
			INNER JOIN tr_productselected_#arguments.eventparam# it ON it.productSelectedID = ps.productSelectedID
			WHERE tr.transactionStatus = 'pending'
			AND ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
		</cfquery>
		<!---<cfdump var="#qProductTypes#" label="latesteventdate" />--->
		<cfreturn qProductTypes.mr />
	</cffunction>
	
	<cffunction name="getEventDateFormatted" access="public" returntype="string">
		<cfargument name="yr" type="numeric" required="true" />
		<cfargument name="mo" type="numeric" required="true" />
		<cfargument name="da" type="numeric" required="true" />
		<cfargument name="hr" type="numeric" required="true" />
		<cfargument name="mi" type="numeric" required="true" />
		
		<cftry>
			<cfreturn "#evmonth#/#evday#/#evyear# #evhour#:#evmin#" />
			<cfcatch>
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn false />
	</cffunction>
	
	<cffunction name="getEventDates" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qEventDates">
			SELECT DISTINCT it.eventStart from tr_transactions tr 
			INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
			INNER JOIN tr_productselected_#arguments.eventparam# it ON it.productSelectedID = ps.productSelectedID
			WHERE tr.transactionStatus = 'pending'
			AND ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
			ORDER BY it.eventStart DESC
		</cfquery>
		<cfreturn qEventDates />
	</cffunction>
	
	<cffunction name="getEventByParam" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qProduct">
			SELECT productClassParam from tr_productselected
			WHERE productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
		</cfquery>
		<cfreturn qProduct />
	</cffunction>
	
	<cffunction name="getEventName" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qName">
			SELECT productName from tr_productselected
			WHERE productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
		</cfquery>
		<cfreturn qName.productName />
	</cffunction>
	
	<cffunction name="doesEventParameterExist" access="public" returntype="boolean">
		<cfargument name="eventparam" type="string" />
		<cfset thisEventParam = getEventByParam(eventparam) />
		<cfreturn thisEventParam.RecordCount gt 0 />
	</cffunction>
	
	<cffunction name="loadTransactionCount" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfargument name="eventdate" type="date" default="#getLatestEventDate(eventparam)#" />
		<cfquery name="qCountPending">
			SELECT Count(tr.transactionID) as num
				from tr_transactions tr 
				INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
				INNER JOIN tr_productselected_#arguments.eventparam# it ON it.productSelectedID = ps.productSelectedID
				WHERE tr.transactionStatus = 'pending'
				AND ps.productClassParam = '#eventparam#'
				AND it.eventStart = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.eventdate#">
		</cfquery>
		<cfreturn qCountPending.num />
	</cffunction>
	
	<cffunction name="loadTransactions" access="public" returntype="any">
		<cfargument name="product" type="string" />
		<cfargument name="eventdate" type="date" default="#getLatestEventDate(product)#" />
		
		<!---<cfdump var="#arguments#" label="eventRSVP loadTransactions args" />--->
		
		<cfset querystring = '
			select
				t.transactionID
				, t.confirmationNum
				, t.transactionDate
				, t.transactionStatus
				, c.firstName
				, c.lastName
				, c.email
				, c.priPhone
				, p.amount
				, ps.productName
				#addProductSpecific(arguments.product)#
			from tr_transactions as t
			left outer join 
				tr_customers as c on c.transactionID = t.transactionID			
			left outer join 
				tr_paymenttypes as p on p.transactionID = t.transactionID			
			left outer join 
				tr_productselected as ps on ps.transactionID = t.transactionID
			left outer join tr_productselected_#arguments.product# as it on ps.productSelectedID = it.productSelectedID
			
		' />
		
		<cfquery name="qPending">
			#querystring#
			where  t.transactionStatus = 'pending'
			and ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">
			<cfif IsDefined("arguments.eventdate") and IsDate(arguments.eventdate)>
				and it.eventStart = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.eventdate#">
			</cfif>
		</cfquery>
		<cfreturn qPending />
	</cffunction>
	<cffunction name="addProductSpecific" access="public" returntype="string">
		<cfargument name="product" type="string" />
		<cfset addQuery= "" />
		<cfswitch expression="#arguments.product#">
		<cfcase value="DateNightRSVP">
			<cfset addQuery="
				, it.eventStart
				, it.numberOfChildrenOver5
				, it.numberOfChildrenUnder5				
			">
		</cfcase>
		<cfcase value="LadiesNightRSVP">
			<cfset addQuery="
				, it.eventStart
				, it.guestFirstName
				, it.guestLastName
				, it.guestEmail				
			">
		</cfcase>
		</cfswitch>
		<cfreturn addQuery />
	</cffunction>
	
	<cffunction name="loadAllTransactions" access="public" returntype="any">
		<cfargument name="product" type="string" />
		<cfquery name="qPending">
			select
				t.confirmationNum
				, t.transactionDate
				, t.transactionStatus
				, c.firstName
				, c.lastName
				, c.email
				, c.priPhone
				, p.amount
				, ps.productName
				#addProductSpecific(arguments.product)#
			from tr_transactions as t
			left outer join 
				tr_customers as c on c.transactionID = t.transactionID			
			left outer join 
				tr_paymenttypes as p on p.transactionID = t.transactionID			
			left outer join 
				tr_productselected as ps on ps.transactionID = t.transactionID
			left outer join tr_productselected_ladiesnightrsvp as ln on ps.productSelectedID = ln.productSelectedID
			where ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">
		</cfquery>
		<cfreturn qPending />
	</cffunction>
</cfcomponent>