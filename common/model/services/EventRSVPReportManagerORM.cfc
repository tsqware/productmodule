<cfcomponent accessors="true">
	<cfproperty name="ProductTransactionReportManager">
	
	<cffunction name="init" access="public" returntype="EventRSVPReportManager">
		<cfset setProductTransactionReportManager(new ProductTransactionReportManager())>
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="loadProducts" access="public" returntype="array">
		<cfargument name="producttype" type="string" />
		<cfquery name="qProducts" dbtype="hql" datasource="devcpctproducts">
			SELECT DISTINCT productName, productClassParam
			FROM ProductSelected
			WHERE productTypeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.producttype#">
			
		</cfquery>
		<cfset prArray = [] />
		<cfloop array="#qProducts#" index="aProduct">
			<cfscript>
				var prStruct = {
					productname = aProduct[1],
					productparam = aProduct[2]
				};
				ArrayAppend(prArray, prStruct);
			</cfscript>
		</cfloop>
		<cfreturn prArray />
	</cffunction>	
	
	<cffunction name="getProductsForDashboardByProduct" access="public" returntype="any">
		<cfargument name="eventtype">
		<cfset var products = [] />
		<cfscript>
			ptstruct = {};
			ptstruct.name = eventtype;
			//var tMgr = getProductTransactionReportManager();			
			
			var getproducts = loadProducts(eventtype); //array
			
			var dateNightTrs = loadDateNightRSVPTransactions();
			WriteDump(var=dateNightTrs, label="dateNightTrs");
			
			var ladiesNightTrs = loadLadiesNightRSVPTransactions();
			WriteDump(var=ladiesNightTrs, label="ladiesNightTrs");
			
			WriteDump(var=getproducts, label="getproducts");
			parray = [];
			for (prod in getproducts) {
				WriteDump(var=prod, label="prod")
				pstruct = {};
				pstruct.productname = prod.productname;
				pstruct.productClassParam = prod.productparam;
				
				tra = loadTransactionCount(prod.productparam);
				pstruct.pendingtransactions = tra;
				WriteDump(var=tra, label="tra");
				
				tr = loadTransactions(prod.productparam);				
				pstruct.pendingtransactionslist = tr;
				ArrayAppend(products, pstruct);
			}			
			ptstruct.products = products;
			WriteDump(var=ptstruct, label="ptstruct");
			abort;
		</cfscript>
		<cfreturn ptstruct />
	</cffunction>
	
	<cffunction name="loadTransactionCount" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfargument name="eventdate" type="date" default="#getLatestEventDate(eventparam)#" />
		
		<!---<cfquery name="qCountPending" dbtype="hql" datasource="devcpctproducts">
			SELECT tr
				from ProductTransaction tr
				join tr.ProductSelected ps
				
				WHERE tr.transactionStatus = 'pending'
				
				AND ps.eventStart = '#DateTimeFormat(arguments.eventdate, "yyyy-mm-dd HH:nn:ss.s")#'
		</cfquery>--->
		
		<cfset qCountPending = ORMExecuteQuery("
			select count(tr) from ProductTransaction tr join tr.ProductSelected ps
			where tr.transactionStatus = 'pending'
				and ps.productClassParam = ?
				
		",
		['#arguments.eventparam#'],
		true, 
		{datasource="devcpctproducts"}) />
		
		<!--- and ps.eventStart = '#DateTimeFormat(arguments.eventdate, "yyyy-mm-dd HH:nn")#' --->
		
		<cfdump var="#qCountPending#" label="trcount" />
		<cfreturn qCountPending />
	</cffunction>
	
	<cffunction name="loadTransactions" access="public" returntype="any">
		<cfargument name="product" type="string" />
		<cfargument name="eventdate" type="date" default="#getLatestEventDate(product)#" />
		
		<cfdump var="#arguments#" label="loadTransactions args" />
		
		<!---<cfquery name="qPending"  dbtype="hql" datasource="devcpctproducts" >
			select tr
			from ProductTransaction tr
			join tr.ProductSelected ps
			
			where ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">
			<cfif IsDefined("arguments.eventdate") and IsDate(arguments.eventdate)>
				and ps.eventStart = <cfqueryparam cfsqltype="cf_sql_timestamp" value="2014-05-16 19:00">
			</cfif>
		</cfquery>--->
		
		<cfset qPending = ORMExecuteQuery("
			select tr from ProductTransaction tr join tr.ProductSelected ps
			where tr.transactionStatus = 'pending'
			and ps.productClassParam = ?
			and ps.eventStart = '5/16/2014 7:00pm'
		",
		['#arguments.product#'],
		false, 
		{datasource="devcpctproducts"}) />
		
		<!--- and ps.eventStart = '#DateTimeFormat(arguments.eventdate, "yyyy-mm-dd HH:nn")#' --->
		
		<cfreturn qPending />
	</cffunction>
	
	<cffunction name="loadDateNightRSVPTransactions" access="public" returntype="any">
		<cfargument name="eventdate" type="date" default="#getLatestEventDate('DateNightRSVP')#" />
		
		<cfdump var="#arguments#" label="loadTransactions args" />
		
		<!---<cfquery name="qPending"  dbtype="hql" datasource="devcpctproducts" >
			select tr
			from ProductTransaction tr
			join tr.ProductSelected ps
			
			where ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">
			<cfif IsDefined("arguments.eventdate") and IsDate(arguments.eventdate)>
				and ps.eventStart = <cfqueryparam cfsqltype="cf_sql_timestamp" value="2014-05-16 19:00">
			</cfif>
		</cfquery>--->
		
		<cfset qPending = ORMExecuteQuery("
			select tr from ProductTransaction tr join tr.ProductSelected ps
			where tr.transactionStatus = 'pending'
			and ps.productClassParam = 'DateNightRSVP'
			and ps.eventStart = '05-23-2014 18:00:00'
		",
		false, 
		{datasource="devcpctproducts"}) />
		
		<!--- and ps.eventStart = '#DateTimeFormat(arguments.eventdate, "yyyy-mm-dd HH:nn")#' --->
		
		<cfreturn qPending />
	</cffunction>
	
	<cffunction name="loadLadiesNightRSVPTransactions" access="public" returntype="any">
		<cfargument name="eventdate" type="date" default="#getLatestEventDate('LadiesNightRSVP')#" />
		
		<cfdump var="#arguments#" label="loadTransactions args" />
		
		<!---<cfquery name="qPending"  dbtype="hql" datasource="devcpctproducts" >
			select tr
			from ProductTransaction tr
			join tr.ProductSelected ps
			
			where ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product#">
			<cfif IsDefined("arguments.eventdate") and IsDate(arguments.eventdate)>
				and ps.eventStart = <cfqueryparam cfsqltype="cf_sql_timestamp" value="2014-05-16 19:00">
			</cfif>
		</cfquery>--->
		
		<cfset qPending = ORMExecuteQuery("
			select tr from ProductTransaction tr join tr.ProductSelected ps
			where tr.transactionStatus = 'pending'
			and ps.productClassParam = 'LadiesNightRSVP'
			and ps.eventStart = '05-16-2014 19:00:00'
		",
		false, 
		{datasource="devcpctproducts"}) />
		
		<!--- and ps.eventStart = '#DateTimeFormat(arguments.eventdate, "yyyy-mm-dd HH:nn")#' --->
		
		<cfreturn qPending />
	</cffunction>
	
	<cffunction name="getLatestEventDate" access="public" returntype="any">
		<cfargument name="eventparam" type="string" />
		<cfdump var="#arguments#" label="led args" />
		<!---<cfquery name="qProductTypes" dbtype="hql" datasource="devcpctproducts">
			SELECT MAX(ps.eventStart) from ProductTransaction tr 
			join tr.ProductSelected ps
			WHERE tr.transactionStatus = 'pending'
			AND ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventparam#">
		</cfquery>--->
		<cfoutput>
			select max(ps.eventStart)<br>
			from #arguments.eventparam#Selected ps<br>
				join ps.ProductTransaction tr<br>
			where tr.transactionStatus = 'pending'<br>
				and ps.productClassParam = '#arguments.eventparam#'<br>
			
		</cfoutput>
		
		<cfset qLatest = ORMExecuteQuery("
			select max(ps.eventStart)
			from #arguments.eventparam#Selected ps
				join ps.ProductTransaction tr
			where tr.transactionStatus = 'pending'
				and ps.productClassParam = '#arguments.eventparam#'
		",[],
		true, 
		{datasource="devcpctproducts"}) />
		
		<cfoutput>qlatest: #CreateDateTime(Year(qLatest), Month(qLatest),Day(qLatest),Hour(qLatest),Minute(qLatest),Second(qLatest))#<br></cfoutput>
		<cfreturn CreateDateTime(Year(qLatest), Month(qLatest),Day(qLatest),Hour(qLatest),Minute(qLatest),Second(qLatest)) />
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
	
	
	<cffunction name="addProductSpecific" access="private" returntype="string">
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