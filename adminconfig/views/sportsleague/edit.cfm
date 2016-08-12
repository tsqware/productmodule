
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
	<cfif StructKeyExists(rc, "seasonLink")>
		<li>
			<a href="#buildURL(argumentcollection='#rc.seasonLink#')#">
				#rc.seasonName#
			</a>
		</li>
	</cfif>	
	<li class="active">#rc.title#</li>
</ol>
<!-- end venue nav -->

<h1>#rc.title#</h1>
<cfif StructKeyExists(rc, "productName")>
	<h3 style="margin:0px;">#rc.productName#</h3>
</cfif>
<cfif StructKeyExists(rc, "seasonName")>
	<h3 style="margin-top:0px;margin-bottom:20px;">#rc.seasonName#</h3>
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

<form action="#buildURL(action='adminconfig:sportsleague.doEdit',querystring='lg=#rc.lg#')#" method="post">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>League Name</label>
							<input type="text" name="leagueName" placeholder="Name of League" maxlength="100" class="form-control" value="#rc.leagueName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>League Param</label>
							<input type="text" name="leagueParam" maxlength="100" class="form-control" value="#rc.leagueParam#" placeholder="Machine Name, used for programming">
						</div>
						<div style="padding-bottom:20px;">
							<label>Sold Out</label>
							<input type="radio" name="isSoldOut" value="1" <cfif IsBoolean(rc.isSoldOut) and rc.isSoldOut eq true> checked="checked"</cfif>> Yes
							<input type="radio" name="isSoldOut" value="0" <cfif IsBoolean(rc.isSoldOut) and rc.isSoldOut eq false> checked="checked"</cfif>> No
						</div>
						
					</fieldset>

				</div>
			</div>
		</div>
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Divisions</label>
							<cfif IsDefined("rc.divisionsForLeague") and not ArrayIsEmpty(rc.divisionsForLeague)>
								<ul>
								<cfloop array="#rc.divisionsForLeague#" index="division">
									<li>
										#division.getDivisionName()# - <a href="#buildURL(action='adminconfig:sportsleaguedivision.edit', querystring='div=#division.getDivisionID()#')#">edit</a>
									</li>
								</cfloop>
								</ul>
							<cfelse>
								<p>There are no Divisions created.</p>						
							</cfif>
							<div><a href="#buildURL(action='adminconfig:sportsleaguedivision.create', querystring='lg=#rc.lg#')#">Create new Division</a></div>	
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div style="text-align:center">
			<button type="submit" class="btn">Save</button>
		</div>
	</div>






	
	</form>

</cfoutput>