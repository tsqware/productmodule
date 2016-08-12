<cfcomponent accessors="true">
	<cfproperty name="ProductTransactionReportManager">
	
	<cffunction name="init" access="public" returntype="AdultLeagueProductReportManager">
		<cfset setProductTransactionReportManager(new ProductTransactionReportManager())>
		<cfreturn this />		
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
	
	<cffunction name="getProductByParam" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qProduct">
			SELECT productClassParam from tr_productselected
			WHERE productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
		</cfquery>
		<cfreturn qProduct />
	</cffunction>
	
	<cffunction name="getProductName" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qName">
			SELECT productName from tr_productselected
			WHERE productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
		</cfquery>
		<cfreturn qName.productName />
	</cffunction>
	
	<cffunction name="doesProductParameterExist" access="public" returntype="boolean">
		<cfargument name="eventparam" type="string" />
		<cfset thisProductParam = getProductByParam(eventparam) />
		<cfreturn thisProductParam.RecordCount gt 0 />
	</cffunction>
	
	<cffunction name="loadTransactionCount" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfquery name="qCountPending">
			SELECT Count(tr.transactionID) as num
				from tr_transactions tr 
				INNER JOIN tr_productselected ps ON tr.transactionID = ps.transactionID
				INNER JOIN tr_productselected_#arguments.eventparam# it ON it.productSelectedID = ps.productSelectedID
				WHERE tr.transactionStatus = 'pending'
				AND ps.productClassParam = '#eventparam#'
		</cfquery>
		<!---<cfdump var="#qCountPending#" />--->
		<cfreturn qCountPending.num />
	</cffunction>
	
	<cffunction name="getProductsForDashboardByProduct" access="public" returntype="any">
		<cfargument name="eventtype">
		<cfset var products = [] />
		<cfscript>
			ptstruct = {};
			ptstruct.name = eventtype;
			var tMgr = getProductTransactionReportManager();			
			
			var getproducts = tMgr.loadProducts(eventtype);
			//WriteDump(var=getproducts, label="getproducts");
			
			parray = [];
			for (row2 in getproducts) {
				pstruct = {};
				pstruct.productname = row2['productName'];
				pstruct.productClassParam = row2['productClassParam'];
				tra = loadTransactionCount(row2['productClassParam']);
				tr = loadTransactions(row2['productClassParam']);
				pstruct.pendingtransactions = tra;
				pstruct.pendingtransactionslist = tr;
				ArrayAppend(products, pstruct);
			}			
			ptstruct.products = products;
		</cfscript>
		<cfreturn ptstruct />
	</cffunction>
	
	<cffunction name="loadTransactions" access="public" returntype="any">
		<cfargument name="product" type="string" />
		<cfargument name="startdate" type="date" />
		<cfargument name="enddate" type="date" />
		<cfargument name="confirmationNum" />
		<cfargument name="trstatus" default="pending" />
		
		<!---<cfdump var="#arguments#" />--->
		
		<cfquery name="qPending" datasource="devcpctproducts" result="res" >
			select
				t.transactionID
				, t.confirmationNum
				, t.transactionDate
				, t.transactionStatus
				, t.processedBy
				, t.processDate
				, c.firstName
				, c.lastName
				, c.email
				, c.priPhone
				, p.amount
				, ps.productName
				, ps.productClassParam
				#addProductSpecific(arguments.product)#
			from tr_transactions as t
			left outer join 
				tr_customers as c on c.transactionID = t.transactionID			
			left outer join 
				tr_paymenttypes as p on p.transactionID = t.transactionID			
			left outer join 
				tr_productselected as ps on ps.transactionID = t.transactionID
			left outer join tr_productselected_#arguments.product# as it on ps.productSelectedID = it.productSelectedID
			where  t.transactionStatus in (
				<cfloop index="idx" from="1" to="#ListLen(arguments.trstatus)#">
					'#ListGetAt(arguments.trstatus, idx)#'<cfif idx neq Listlen(arguments.trstatus)>,</cfif>
				</cfloop>
			)
			and ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">
			<cfif IsDefined("arguments.startdate") and IsDefined("arguments.enddate")>
				and t.transactionDate >= '#arguments.startdate#'
				and t.transactionDate <= '#arguments.enddate# 23:59:59'
			</cfif>
			<cfif IsDefined("arguments.confirmationNum")>
				and t.confirmationNum = #arguments.confirmationNum#
			</cfif>
			
		</cfquery>
		<!---<cfdump var="#res#" />--->
		<cfreturn qPending />
	</cffunction>
	<cffunction name="addProductSpecific" access="private" returntype="string">
		<cfargument name="product" type="string" />
		<cfset addQuery= "" />
		<cfswitch expression="#arguments.product#">
		<cfcase value="SoccerAdultLeague">
			<cfset addQuery="
				, it.leagueName
				, it.leagueSeason
				, it.leagueStartDate
				, it.leagueEndDate				
			">
		</cfcase>
		<cfcase value="BasketballAdultLeague">
			<cfset addQuery="
				, it.leagueName
				, it.leagueSeason
				, it.leagueStartDate
				, it.leagueEndDate				
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
				, ln.eventStart
				, ln.guestFirstName
				, ln.guestLastName
				, ln.guestEmail		
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