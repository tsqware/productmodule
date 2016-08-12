<cfoutput>

<!-- venue nav -->
<nav class="navbar navbar-default">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#buildURL('adminconfig:main')#">Product Module</a>
    </div>
    <div id="navbar" class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
      	<cfif StructKeyExists(rc, "productEditLink")>
      	 <li>
      	 	<a href="#buildURL(argumentcollection='#rc.productEditLink#')#">
      	 		Product: #rc.productName#
      	 	</a></li>
      	 </cfif>
        <li class="active"><a href="##">#rc.title#</a></li>
      </ul>
    </div><!--/.nav-collapse -->
  </div>
</nav>
<!-- end venue nav -->

<h1>#rc.title#</h1>

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
<cfform action="#buildURL(action='adminconfig:sportsseason.doEdit', querystring='sea=#rc.sea#')#" method="post" preservedata="true">
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
						<div style="padding-bottom:20px;">
							<label class="">League Structure:</label>
							<br />
							<cfset leagueStructLeagueChecked = '' />
							<cfset leagueStructDivisionChecked = '' />
							<cfif Len(rc.leagueStructure) gt 0 or rc.hasLeague>
								<cfif rc.leagueStructure eq "League" or rc.hasLeague>
									<cfset leagueStructLeagueChecked = 'checked="checked"' />
								<cfelse>
									<cfset leagueStructDivisionChecked = 'checked="checked"' />
								</cfif>
							</cfif>
							<input name="leagueStructure" type="radio" value="League" #leagueStructLeagueChecked# /> With Leagues<br />
							<input name="leagueStructure" type="radio" value="Division" #leagueStructDivisionChecked# /> With Divisions
						</div>
						
						<fieldset class="withLeague">
							#view('sportsseason/withleague')#
						</fieldset>
						<fieldset class="withDivision">
							#view('sportsseason/withdivision')#
						</fieldset>
					</fieldset>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">	
	
					<fieldset>
							
						<h2 style="margin-top:0px;">Prices</h2>
						<cfif ArrayIsEmpty(rc.prices)>
							<p>There are no Prices created.</p>
						<cfelse>
							<div style="margin-bottom:20px;">
							<cfloop array="#rc.prices#" index="priceItm">
								<cfset priceChecked = "" />
								<cfif rc.hasPrice>
									<cfloop array="#rc.pricesForSeason#" index="priceSelItm">
										<cfif priceSelItm.getPriceID() eq priceItm.getPriceID()>
											<cfset priceChecked = 'checked="checked"' />
										</cfif> 
									</cfloop>
								</cfif>
								<input name="priceID" type="checkbox" value="#priceItm.getPriceID()#" #priceChecked# />
									#priceItm.getPriceName()# - #NumberFormat(priceItm.getPriceAmount(), "$")# - 
									<a href="#buildURL(action='adminconfig:seasonprice.edit', querystring='seaprice=#priceItm.getPriceID()#')#">edit</a><br />
									<cfif priceItm.hasSeason()>
										<p style="font-size:12px;">#priceItm.getSeason().getSeasonName()#</p>
									<cfelse>
										<p style="font-size:12px;">Not associated with a Season</p>
									</cfif>
							</cfloop>
							</div>
						</cfif>
						<div><a href="#buildURL(action='adminconfig:seasonprice.create')#">Create new Price</a></div>
						
						
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
		hideFieldsets();
		leagueStructure = $('input[name="leagueStructure"]');
		leagueStructureChecked = $('input[name="leagueStructure"]:checked');
		
		showFieldset(leagueStructureChecked.val());
		leagueStructure.click(function() {
			showFieldset(this.value);
		});

		initDatePicker();
		initTimePicker();
	});
	function hideFieldsets() {
		$('.withLeague').hide();
		$('.withDivision').hide();
	}
	function showFieldset(whichone) {
		hideFieldsets();
		$('.with' + whichone).show();
	}
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