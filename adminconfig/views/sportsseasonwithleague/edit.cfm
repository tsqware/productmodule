<cfoutput>

<!-- venue nav -->
<ol class="breadcrumb">
	<li> <a href="#buildURL('adminconfig:main')#">Product Module</a></li>
	<cfif StructKeyExists(rc, "productEditLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.productEditLink#')#">
				Product: #rc.productName#
			</a>
		</li>
	</cfif>
	<li class="active">#rc.title#</li>
</ol>
<!-- end venue nav -->

<h1>#rc.title#</h1>
<cfif StructKeyExists(rc, "productName")>
	<h3>League: #rc.productName#</h3>
</cfif>

<cfif StructKeyExists(rc, "message")>
	<div>
		<h3>#rc.message#</h3>
		<cfif not ArrayIsEmpty(rc.valerrors)>
			<ul>
				<cfloop array="#rc.valerrors#" index="er">
					<li>#er.getMessage()#</li>
				</cfloop>
			</ul>
		</cfif>
	</div>
</cfif>

<cfif rc.messagestatus neq "notfound">
<cfform action="#buildURL(action='adminconfig:sportsseasonwithleague.doEdit', querystring='sea=#rc.sea#')#" method="post" preservedata="true">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Season Name</label>
							<input type="text" name="seasonname" placeholder="Season Name" maxlength="100" class="form-control" value="#rc.seasonName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Season Param</label>
							<input type="text" name="seasonParam" maxlength="100" class="form-control" value="#rc.seasonParam#" placeholder="Machine Name, dashes allowed, no spaces">
						</div>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body" style="margin:0px; padding:20px 0px 0px;">
	
					<fieldset>
						<div class="col-xs-6">	
							<div style="padding-bottom:20px;">
								<label class="eventDate">Season Start Date:</label>
								<input name="startDate" type="text" maxlength="50" class="form-control datepicker" value="#DateFormat(rc.startDate, 'mm/dd/yyyy')#" />
							</div>
							<div style="padding-bottom:20px;">
								<label class="fortextfield">Season End Date:</label><input name="endDate" type="text" class="form-control datepicker" maxlength="50" value="#DateFormat(rc.endDate, 'mm/dd/yyy')#" />
							</div>
						</div>
						<div class="col-xs-6">	
							<div style="padding-bottom:20px;">
								<label class="eventDate">Early Registration Due Date:</label>
								<input name="earlyregduedate" type="text" class="form-control datepicker" value="#DateFormat(rc.earlyRegDueDate, 'mm/dd/yyyy')#" />
							</div>
							<div style="padding-bottom:20px;">
								<label class="fortextfield">Registration Due Date:</label><input name="regduedate" type="text" class="form-control datepicker" maxlength="50" value="#DateFormat(rc.regDueDate, 'mm/dd/yyyy')#" />
							</div>
						</div>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">	
					<fieldset>
						<h2 style="margin-top:0px;">League Structure</h2>
						<fieldset class="withLeague">
							#view('sportsseason/withleague')#
						</fieldset>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">	
		
					<fieldset>
							
						<h2 style="margin-top:0px;">Prices</h2>
						<cfif rc.hasPrice>
							<div style="margin-bottom:20px;">
							<cfloop array="#rc.pricesForSeason#" index="priceSelItm">
								#priceSelItm.getPriceName()# - #NumberFormat(priceSelItm.getPriceAmount(), "$")# - 
								<a href="#buildURL(action='adminconfig:seasonprice.edit', querystring='seaprice=#priceSelItm.getPriceID()#')#">edit</a><br />
							</cfloop>
								
							</div>
						<cfelse>							
							<p>There are no Prices created for this Product.</p>
						</cfif>
						<div><a href="#buildURL(action='adminconfig:seasonprice.create', querystring='sea=#rc.sea#')#">Create new Price</a></div>
						
						
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<div class="row" style="text-align: center;">	
		<input type="hidden" name="sea" value="#rc.sea#" />
		<button type="submit" class="btn">Save</button>
	</div>
</cfform>


<script language="javascript" type="text/javascript">
	$(document).ready(function() {
		initDatePicker();
		initTimePicker();
	});
	function initDatePicker() {
		$(".datepicker").datepicker({ 		
		
		});
	}
	function initTimePicker() {
		$('.timepicker').timepicker({ 
			step     		  : 15			// SETS default gap to 15 min
		});
	}
</script>
</cfif>
</cfoutput>