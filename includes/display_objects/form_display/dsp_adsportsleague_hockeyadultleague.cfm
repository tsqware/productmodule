<cfset pluginConfig.addToHTMLFootQueue("includes/assets/htmlhead/jquery.validate.cfm")>
<cfset pluginConfig.addToHTMLFootQueue("includes/assets/htmlfoot/jsfoot_hockeyadult.cfm")>



<cfset sal = $.content()>

<cfset leagueExists = IsDefined("request.leagueBean") and Len(Trim(request.leagueBean.getTitle())) gt 0>

<cfif leagueExists>

	<cfset requestbean = request.leagueBean>

	<cfset hasEarlyRegistration = Len(request.leagueBean.getAdLeagueEarlyDueDate()) gt 0>

	<cfset isEarlyRegistration = hasEarlyRegistration and DateDiff('d', now(), request.leagueBean.getAdLeagueEarlyDueDate()) gte 0>

	<cfset hasEarlyPrice = request.leagueBean.getAdLeagueTeamEarlyPrice() gt 0>

	<cfset hasTeamDeposit = request.leagueBean.getAdLeagueTeamDeposit() gt 0>
	
	<!---<cfdump var="#request.leagueBean#" />

	<cfdump var="#request#" />--->

</cfif>

<cfset pricetypes = []><!--- deposit or pay in full --->

<!---

<cfset svc = CreateObject("component", "#$.siteConfig('pluginDir')#/plugins/MuraFW1/common.model.services.HockeyAdultLeagueService").init()>

<cfset x = svc.getPaymentInfo("deposit", "request.leagueBean")>

--->

<!---

<cfset pluginConfig.addToHTMLHeadQueue("extensions/assets/htmlhead/jquery.validate.cfm")>

--->

<cfhtmlhead text='

	<script language="javascript">var requestLeague = "#request.league#";</script>
'>

<cfoutput>

<style type="text/css">

form fieldset p.error label { color: red; }

##adsportsleague_hockeyadult label.error {

	display: block;

	width: auto;

	padding:0px;

	font-weight:normal;

}



##adsportsleague_hockeyadult div.error {

	margin:0px 0px 15px;

	display:none;

	padding:15px;

}

##adsportsleague_hockeyadult div.error li {

	list-style:disc;

	padding: 0px;

	margin:0px;

}

##adsportsleague_hockeyadult div.error ul {

	list-style:disc;

	padding: 0px;

	margin:0px 0px 0px 20px;

}

##paycontainer {

	display:none;

	font-size: 16px;

	font-weight: bold;

	margin: 15px 0px;

}

##pricetable {

	margin:0px;

	width:100%;

}

##pricetable tbody { width:100%;  }

##pricetable td {

	padding:3px 5px;	

}



</style>



<cfif not leagueExists or not IsDefined("sal")>

	<div class="error alert alert-danger"><h4>The form cannot be found.</h4><ul></ul></div>

<cfelse>

	<!---<cfdump var="#request.leagueBean.getAllValues()#">--->

	<form id="adsportsleague_hockeyadult" class="form-horizontal" method="post"

		action="#application.configBean.getContext()#/ice-hockey/adult/league-registration-confirmation/">

	 	<div class="error alert alert-danger">

	 		<h4>The form could not be completed:</h4><ul></ul>

	 	</div>

		<div class="container-fluid">

			<div class="row" style="padding:20px 0px; margin-bottom:20px;">

				<div class="col-md-4">

					<table class="table">

						<tr>

							<td><strong>Product:</strong></td><td>#sal.getAdLeagueProductName()#</td>

						</tr>

						<tr>

							<td><strong>League:</strong></td><td>#request.leagueBean.getAdLeagueName()#</td>

						</tr>

						<tr>

							<td><strong>Season:</strong></td><td>#request.leagueBean.getAdLeagueSeason()#</td>

						</tr>

						<tr>

							<td><strong>Starts:</strong></td><td>#DateFormat(request.leagueBean.getAdLeagueStartDate(), "m/d/yyyy")#</td>

						</tr>

						<tr>

							<td><strong>Ends:</strong></td><td>#DateFormat(request.leagueBean.getAdLeagueEndDate(), "m/d/yyyy")#</td>

						</tr>

						<cfif isEarlyRegistration and hasEarlyPrice>

							<tr>

								<td><strong>Early Register By:</strong></td><td>#DateFormat(request.leagueBean.getAdLeagueEarlyDueDate(), "m/d/yyyy")#</td>

							</tr>

						</cfif>

						<tr>

							<td><strong>Register By:</strong></td><td>#DateFormat(request.leagueBean.getAdLeagueRegDueDate(), "m/d/yyyy")#</td>

						</tr>

						<tr>

							<td valign="top"><strong>Prices:</strong></td>

							<td valign="top">

								Team: $#request.leagueBean.getAdLeagueTeamPrice()#<br>

								<cfif isEarlyRegistration and hasEarlyPrice>

									Early Price: $#request.leagueBean.getAdLeagueTeamEarlyPrice()#<br>

								</cfif>

								Team Deposit: $#request.leagueBean.getAdLeagueTeamDeposit()#

							</td>

						</tr>
						
						<tr>
							<td><strong>Division:</strong></td>
							<td>
								<select name="divisionName">
									<option value="">--- Choose a Division ---</option>
									<cfloop from="1" to="#ListLen($.getAdultLeagueDivisionOptionList(), '^')#" index="dIdx" >										
										<option value="#ListGetAt($.getAdultLeagueDivisionList(), dIdx, '^')#">#ListGetAt($.getAdultLeagueDivisionOptionList(),dIdx,'^')#</option>
									</cfloop>
								</select>
							</td>
						</tr>

					</table>

				</div>

				<div class="col-md-4" style="background:##e6e6e6;">

					<fieldset id="set-primarymemberinfo">

						<legend>Team Contact Info</legend>		

						<div class="mura-form-textfield req" style="margin-bottom:10px;">		

							<label for="firstname">First Name <ins>Required</ins></label>

							<input type="text" name="firstname" class="form-control"  />		

						</div>		

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="lastname">Last Name <ins>Required</ins></label>

							<input type="text" name="lastname" class="form-control"  />		

						</div>

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="email">Email <ins>Required</ins></label>

							<input type="text" name="email" class="form-control"  />		

						</div>

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="haddress">Address <ins>Required</ins></label>

							<input type="text" name="haddress" class="form-control" style="margin-bottom:6px;"  />	

							<input type="text" name="haddress2" class="form-control"  />		

						</div>

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="hcity">City <ins>Required</ins></label>

							<input type="text" name="hcity" class="form-control"  />		

						</div>

						<div class="mura-form-textfield col-md-6 req " style="padding-left:0px;margin-bottom:10px;">		

							<label for="hstate">State <ins>Required</ins></label><br />

							#$.dspObject('component','[Forms] State Dropdown List')#

						</div>

						<div class="mura-form-textfield col-md-6 req " style="margin-bottom:10px;">		

							<label for="hzip">Zip <ins>Required</ins></label>

							<input type="text" name="hzip" class="form-control"  />		

						</div>

					</fieldset>

				</div>

				<div class="col-md-4" style="background:##e6e6e6;">

					<fieldset id="set-primarymemberinfo">

						<legend>Checkout</legend>		

						<div class="mura-form-textfield req" style="margin-bottom:10px;">		

							<label for="pricetype">Amount to be charged now: <ins>Required</ins></label><br>

							<!--- 

								always include pay in full

								if this league allows deposit, create radio boxes for deposit and pay in full

								if not, show pay in full price

							--->

							<cfif hasTeamDeposit>

								<input type="radio" value="deposit" name="pricetype" style="margin-right:10px;"><span>Deposit</span>

								<input type="radio" value="payinfull" name="pricetype" style="margin-right:10px;"><span>Pay in Full</span>

							</cfif>

							<div id="paycontainer" style="">

								<table id="pricetable" cellpadding="10" cellspacing="0" class="alert alert-danger" style="display:table;width:80%;margin: 0px auto;">

									<tr>

										<td>Amount Paid:</td><td id="regAmount" style="text-align: right;"></td>

									</tr>

									<tr>

										<td>Balance:</td><td id="regBalance" style="text-align: right;"></td>

									<tr>

										<td>Due Date</td><td id="regDueDate" style="text-align: right;"></td>

									</tr>

								</table>

							</div>

							<div style="clear:right"></div>

						</div>		

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="creditcardtype">Card Type <ins>Required</ins></label>

							<cfset creditcardlist="MasterCard,American Express,Discover,Visa,JCB">

							<select name="creditcardtype" id="creditcardtype" style="padding:7px 5px;">

								<cfloop index="ccCounter" list="#creditcardlist#">

									<cfoutput><option value="#ccCounter#">#ccCounter#</option></cfoutput>

								</cfloop>

							</select>

						</div>

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="creditcardnum">Card Number <ins>Required</ins></label>

							<input type="text" name="creditcardnum" class="form-control"  />		

						</div>

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="haddress">Expiration <ins>Required</ins></label>

							<select name="creditcardexp_month" id="creditcardexp_month" style="padding:7px 5px;">

								<cfloop index="loopcount" from="1" to="12">

									<option value="#loopcount#">#NumberFormat(loopcount, "09")#</option>

								</cfloop>

							</select>

							/

							<select name="creditcardexp_year" id="creditcardexp_year" style="padding:7px 5px;">

								<cfloop index="loopcount" from="#Year(now())#" to="#Evaluate(Year(now()) + 10)#">

									<option value="#loopcount#">#loopcount#</option>

								</cfloop>

							</select>		

						</div>

						<div class="mura-form-textfield req " style="margin-bottom:10px;">		

							<label for="creditcardholder">Name as it appears on the card: <ins>Required</ins></label>

							<input type="text" name="creditcardholder" class="form-control"  />		

						</div>

						<div class="mura-form-textfield" style="margin-bottom:10px;">		

							<label for="promocode">Promo Code: </label>

							<input type="text" name="promocode" class="form-control"  />		

						</div>

						<div class="mura-form-textarea" style="margin-bottom:10px;">		

							<label for="comments">Comments </label>

							<textarea name="comments" class="form-control"></textarea>		

						</div>

					</fieldset>

				</div>

			</div>

			

			<div class="row">

				<input id="paymentMethod" type="hidden" name="paymentMethod" value="Credit Card" />

				<input type="hidden" name="productType" value="#sal.getSubType()#" />

				<input type="hidden" name="productName" value="#sal.getAdLeagueProductName()#" />

				<input type="hidden" name="productURLParam" value="#sal.getAdLeagueProductURLParam()#" />

				<input type="hidden" name="productClassParam" value="#sal.getAdLeagueProductClassParam()#" />

				<input type="hidden" name="lg" value="#request.league#" />

				<input type="hidden" name="formSettingsFile" value="product-module/form-settings/hockey-adult-league-form-settings" />

				<!--- <input type="hidden" name="leagueName" value="#request.leagueBean.getAdLeagueName()#" />

				<input type="hidden" name="leagueSeason" value="#request.leagueBean.getAdLeagueSeason()#" />

				<input type="hidden" name="leagueStartDate" value="#request.leagueBean.getAdLeagueStartDate()#" />

				<input type="hidden" name="leagueEndDate" value="#request.leagueBean.getAdLeagueEndDate()#" />

				

				<input type="hidden" name="productFile" value="#sal.getFileName()#" />

				--->

				

				<div style="text-align:center; padding:20px 0px;"><input type="submit" class="btn btn-default" value="Submit"></div>

			</div>

		</div>

	</form>

</cfif>

</cfoutput>