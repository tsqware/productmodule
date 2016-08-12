<cfcomponent accessors="true">
	<cfproperty name="ProductTransactionReportManager">
	<cfproperty name="EventRSVPReportManager">
	
	<cffunction name="init" access="public" returntype="LadiesNightRSVPReportManager">
		<cfset setProductTransactionReportManager(new ProductTransactionReportManager())>
		<cfset setEventRSVPReportManager(new EventRSVPReportManager())>
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="loadTransactions" access="public" returntype="any">
		<cfargument name="eventdate" type="any" default="#getLatestEventDate(product)#" />
		
		<cfquery name="qPending">
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
				, it.eventStart
				, it.guestFirstName
				, it.guestLastName
				, it.guestEmail	
			from tr_transactions as t
			left outer join 
				tr_customers as c on c.transactionID = t.transactionID			
			left outer join 
				tr_paymenttypes as p on p.transactionID = t.transactionID			
			left outer join 
				tr_productselected as ps on ps.transactionID = t.transactionID
			left outer join tr_productselected_ladiesnightrsvp as it on ps.productSelectedID = it.productSelectedID
			where ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="LadiesNightRSVP" />
			<cfif IsDefined("arguments.eventdate") and IsDate(arguments.eventdate)>
				and it.eventStart = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.eventdate#" />
			</cfif>
		</cfquery>
		<cfreturn qPending />
	</cffunction>
	
	<cffunction name="addProductSpecific" access="private" returntype="string">
		<cfargument name="product" type="string" />
		<cfset addQuery= "" />
		<cfswitch expression="#arguments.product#">
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
	
	<cffunction name="exportToExcel" access="public" returntype="void">
		<cfargument name="evtdate" >	
		<cfscript>
			
			evdateraw = ListToArray(arguments.evtdate, "-");
			
			evyear = evdateraw[1];
			evmonth = evdateraw[2];
			evday = evdateraw[3];
			evhr = evdateraw[4];
			evmin = evdateraw[5];
			evsec = evdateraw[6];
			
			filetowrite = GetDirectoryFromPath(GetCurrentTemplatePath()) & "../../../includes/assets/spreadsheets/LadiesNightRSVP-" & arguments.evtdate & ".xls";
			filetoopen = "includes/assets/spreadsheets/LadiesNightRSVP-" & arguments.evtdate & ".xls";
			
			evdate = CreateDateTime(evyear, evmonth, evday, evhr, evmin, evsec);
			rc.allTransactions = loadTransactions(evdate);			
			// first we create the spreadsheet object
			spreadsheet = spreadsheetNew("datenightreport");
			// next we add the header row
			spreadsheetAddRow(spreadsheet,"TRANSACTIONID,CONFIRMATIONNUM,TRANSACTIONDATE,TRANSACTIONSTATUS,FIRSTNAME,LASTNAME,EMAIL,PRIPHONE,AMOUNT,PRODUCTNAME,EVENTSTART,GUESTFIRSTNAME,GUESTLASTNAME,GUESTEMAIL");
			// I want to format my headers so that they're bold and centered
			spreadsheetFormatRow(spreadsheet,{bold=true,alignment="center"},1);
			// Ah, CFML how I love you. Just use the spreadsheetAddRows method to add your entire query to the spreadsheet
			spreadsheetAddRows(spreadsheet,rc.allTransactions);
			// finally, write the file to the server/file system
			spreadsheetWrite(spreadsheet,filetowrite,"yes");
			
			location(url=filetoopen, addtoken="no");
		</cfscript>
	</cffunction>
</cfcomponent>