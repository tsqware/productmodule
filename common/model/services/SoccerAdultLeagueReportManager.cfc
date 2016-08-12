<cfcomponent accessors="true">
	<cfproperty name="ProductTransactionReportManager">
	<cfproperty name="AdultLeagueProductReportManager">
	
	<cffunction name="init" access="public" returntype="SoccerAdultLeagueReportManager">
		<cfset setProductTransactionReportManager(new ProductTransactionReportManager())>
		<cfset setAdultLeagueProductReportManager(new AdultLeagueProductReportManager())>
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="loadTransactions" access="public" returntype="any">
		<cfargument name="startdate" type="date" />
		<cfargument name="enddate" type="date" />
		<cfargument name="trstatus" default="pending" />
		
		<cfset theEndDate = CreateDateTime(
			Year(arguments.enddate),
			Month(arguments.enddate),
			Day(arguments.enddate),
			23,
			59,
			59
		) />
		
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
				, it.leagueName
				, it.leagueSeason
				, it.leagueStartDate
			from tr_transactions as t
			left outer join 
				tr_customers as c on c.transactionID = t.transactionID			
			left outer join 
				tr_paymenttypes as p on p.transactionID = t.transactionID			
			left outer join 
				tr_productselected as ps on ps.transactionID = t.transactionID
			left outer join tr_productselected_socceradultleague as it on ps.productSelectedID = it.productSelectedID
			where  t.transactionStatus in (
				<cfloop index="idx" from="1" to="#ListLen(arguments.trstatus)#">
					'#ListGetAt(arguments.trstatus, idx)#'<cfif idx neq Listlen(arguments.trstatus)>,</cfif>
				</cfloop>
			)
			and ps.productClassParam = <cfqueryparam cfsqltype="cf_sql_varchar" value="SoccerAdultLeague" />
			<cfif IsDefined("arguments.startdate") and IsDefined("arguments.enddate")>
				and t.transactionDate >= '#DateTimeFormat(arguments.startdate, "yyyy-mm-dd HH:mm:ss")#'
				and t.transactionDate <= '#DateTimeFormat(theEndDate, "yyyy-mm-dd HH:mm:ss")#'
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
		<cfargument name="datestart" >	
		<cfargument name="dateend" >
		<cfargument name="trstatus" />
		
		<cfscript>
			
			datestartraw = ListToArray(arguments.datestart, "-");
			
			dsyear = datestartraw[1];
			dsmonth = datestartraw[2];
			dsday = datestartraw[3];
			dshr = datestartraw[4];
			dsmin = datestartraw[5];
			dssec = datestartraw[6];
			
			dateendraw = ListToArray(arguments.dateend, "-");
			
			deyear = dateendraw[1];
			demonth = dateendraw[2];
			deday = dateendraw[3];
			dehr = dateendraw[4];
			demin = dateendraw[5];
			desec = dateendraw[6];
			
			filetowrite = GetDirectoryFromPath(GetCurrentTemplatePath()) & "../../../includes/assets/spreadsheets/SoccerAdultLeague-" & arguments.datestart & "_" & arguments.dateend & ".xls";
			filetoopen = "includes/assets/spreadsheets/SoccerAdultLeague-" & arguments.datestart & "_" & arguments.dateend & ".xls";
			
			datestart = CreateDateTime(dsyear, dsmonth, dsday, dshr, dsmin, dssec);
			dateend = CreateDateTime(deyear, demonth, deday, dehr, demin, desec);
			rc.allTransactions = loadTransactions(datestart, dateend, "pending,approved,declined");
				
			// first we create the spreadsheet object
			spreadsheet = spreadsheetNew("transactionreport");
			// next we add the header row
			spreadsheetAddRow(spreadsheet,"TRANSACTIONID,CONFIRMATIONNUM,TRANSACTIONDATE,TRANSACTIONSTATUS,FIRSTNAME,LASTNAME,EMAIL,PRIPHONE,AMOUNT,PRODUCTNAME,LEAGUENAME,LEAGUESEASON,LEAGUESTARTDATE");
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