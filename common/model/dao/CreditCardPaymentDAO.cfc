<cfcomponent extends="PaymentDAO">
	
	<cffunction name="init" access="public" returntype="CreditCardPaymentDAO">
		<cfset super.init() />
		<cfreturn this />
	</cffunction>
	
	<cfscript>
	
	
	public any function listInProductType(required String producttype) {
			
			//var test = this.new();
			//WriteDump(test);
			//abort;
		
			var rows = ORMExecuteQuery(
				"
					SELECT p 
					FROM Product p join p.ProductType pt where pt.prodtypeParam = '#producttype#'
				"
			);
			//WriteDump(var=rows, label="rows");
			//abort;
		
		//if (arguments.asquery) {
		//	return EntityToQuery(rows);
		//}
		
		return rows;
	}
	
	/**
	**
	** @hint I will save an object
	**
	***/
	public void function save(p) {
		EntitySave(p);		
	}
	
	public String function _save(obj) {
		/* populate entity */
		
		//WriteDump(arguments);
		
		var txn = ormGetSession().beginTransaction();
		
		try {
			
			// populate
			populatedObj = populate(obj);
			
			//WriteDump(populatedObj);
			
			// validate
			request.errors = validate(populatedObj);
			//WriteDump(request.errors);
			
			
			
			if (!ArrayIsEmpty(request.errors)) {
				// message - fail
				// show errors
				message = "The form could not be completed - validation errors.";
			}
			else {
				// this program
				//request.programname = populatedObj.getProgram().getProgramName();
				//request.programparam = populatedObj.getProgram().getProgramParam();
				
				// save the entity using the appropriate strategy
				if (IsNull(obj.getProductID())) {
					EntitySave(populatedObj);
					message = "The new Product '#populatedObj.getProductName()#' is now saved.";
				}
				else {message = "The existing Product '#populatedObj.getProductName()#' is now saved.";}
			}
		}
		catch(any e) {
			txn.rollback();
			
			message = "There was a problem saving the Product Group.";
			WriteDump(e);
			throw e;
		}
		txn.rollback();
		return message;
		
	}
	
	/* public void saveTransaction > populate, validate, save */
	
	/**
	**
	** @hint I will delete an object
	**
	***/
	
	
	public numeric function count() {
		return ArrayLen(EntityLoad(getEntity()));
	}
	
	
	
	private string function getEntity() {
		var meta = getMetadata(this);
		var entity = "";
		
		//WriteDump(meta);
		if (StructKeyExists(meta,"entity")) {
			//get metadata for entity name
			entity = meta.entity;
		}
		else {
			// read the service name and extract the first part as the entity name
			if (StructKeyExists(meta,"fullname")) {
				var service = listLast(meta.fullname,".");
				entity = replaceNoCase(service,"dao","");
			}	
		}
		
		return entity;
	}
	
	public any function populate(required payment) {
		if (IsDefined("form.pricetype")) {
			var pricetype = form.pricetype;
			var product = form.productURLParam;
			var price = getSportsLeaguePayment().getPrice(pricetype, product);
			payment.setPriceType(pricetype);
			if (Len(price) > 0) payment.setAmount(price);
		}
		payment.setPaymentTypeName("Credit Card");
		if (IsDefined("form.creditcardtype")) {
			payment.setCreditCardType(form.creditcardtype);
		}
		if (IsDefined("form.creditcardnum") && Len(form.creditcardnum) > 0) {
			payment.setCreditCardNum(form.creditcardnum);
		}
		if (
			(IsDefined("form.creditcardexp_month") && Len(form.creditcardexp_month) > 0)
			&& (IsDefined("form.creditcardexp_year") && Len(form.creditcardexp_year) > 0)
		) {
			var exp = CreateDate(
				form.creditcardexp_year, 
				form.creditcardexp_month, 
				DaysInMonth(
					CreateDate(form.creditcardexp_year, form.creditcardexp_month, 1)
				)
			);
			payment.setCreditCardExp(exp);
		}
		
		payment.setCreditCardHolder(form.creditcardholder);

		if (IsDefined("form.promocode")) {
			payment.setPromoCode(form.promocode);
		}
			
		return payment;
	}
	
	public array function validate(ent) {
		result = [];
		hyrule =  new hyrule.system.core.hyrule();
		//WriteDump(var=hyrule,label="hyrule");
		
		result = hyrule.validate(ent);		
		return result.getErrors();
	}

		
		
	</cfscript>
	
	<!---
	<cffunction name="getByAttributesQuery" access="public" output="false" returntype="query">
		<cfargument name="productid" type="Numeric" required="false" />
		<cfargument name="productname" type="String" required="false" />
		<cfargument name="productparam" type="String" required="false" />
		<cfargument name="formname" type="String" required="false" />
		<cfargument name="issoldout" type="Boolean" required="false" />
		<cfargument name="productconfigid" type="Numeric" required="false" />
		<cfargument name="producttypeid" type="Numeric" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.dsn#">
			SELECT
				productid,
				productname,
				productparam,
				formname,
				issoldout,
				productconfigid,
				producttypeid
			FROM	products
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"productid") and len(arguments.productid)>
			AND	productid = <cfqueryparam value="#arguments.productid#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments,"productname") and len(arguments.productname)>
			AND	productname = <cfqueryparam value="#arguments.productname#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"productparam") and len(arguments.productparam)>
			AND	productparam = <cfqueryparam value="#arguments.productparam#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"formname") and len(arguments.formname)>
			AND	formname = <cfqueryparam value="#arguments.formname#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"issoldout") and len(arguments.issoldout)>
			AND	issoldout = <cfqueryparam value="#arguments.issoldout#" CFSQLType="cf_sql_bit" />
		</cfif>
		<cfif structKeyExists(arguments,"productconfigid") and len(arguments.productconfigid)>
			AND	productconfigid = <cfqueryparam value="#arguments.productconfigid#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments,"producttypeid") and len(arguments.producttypeid)>
			AND	producttypeid = <cfqueryparam value="#arguments.producttypeid#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="getByAttributes" access="public" output="false" returntype="array">
		<cfargument name="productid" type="Numeric" required="false" />
		<cfargument name="productname" type="String" required="false" />
		<cfargument name="productparam" type="String" required="false" />
		<cfargument name="formname" type="String" required="false" />
		<cfargument name="issoldout" type="Boolean" required="false" />
		<cfargument name="productconfigid" type="Numeric" required="false" />
		<cfargument name="producttypeid" type="Numeric" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = getByAttributesQuery(argumentCollection=arguments) />		
		<cfset var arrObjects = arrayNew(1) />
		<cfset var tmpObj = "" />
		<cfset var i = 0 />
		<cfloop from="1" to="#qList.recordCount#" index="i">
			<cfset tmpObj = createObject("component","").init(argumentCollection=queryRowToStruct(qList,i)) />
			<cfset arrayAppend(arrObjects,tmpObj) />
		</cfloop>
				
		<cfreturn arrObjects />
	</cffunction>

	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>
	--->
</cfcomponent>