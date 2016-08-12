<cfscript>
	if(IsDefined("form.lg") && Len(form.lg) > 0)
	{
		request.leagueBean = $.getBean('content').loadBy(filename='product-module/adult-basketball-leagues/#form.lg#');
	}
	leagueExists = IsDefined("request.leagueBean") and Len(Trim(request.leagueBean.getTitle())) gt 0;
	if(leagueExists)
	{
		//abort;
		//ormreload();
		tMgr = new pmservices.ProductTransactionManager();
		//WriteDump(tMgr);
		
		tMgr.load();
		fileName = form.formSettingsFile;
		formSettings = $.getBean('content').loadBy(filename=fileName, siteId=session.siteID);
		requiredFields = ListToArray(formSettings.getRequiredFields());
		paymentTypes = ListToArray(formSettings.getPaymentTypes());
		tMgr.beginTransaction(requiredFields, paymentTypes);
	}
	isBeforeEarlyDueDate = not IsNull(request.leagueBean.getAdLeagueEarlyDueDate()) and IsDate(request.leagueBean.getAdLeagueEarlyDueDate()) 
	                       and DateDiff('d', request.leagueBean.getAdLeagueEarlyDueDate(), now()) lte 0;
</cfscript>

<!---<cfdump var="#request#" /><cfabort />--->
<cfoutput>
	<cfif not leagueExists>
		<div class="error alert alert-danger">
			<h4>
				The form cannot be found.
			</h4>
			<ul>
			</ul>
		</div>
	<cfelseif IsDefined("request.status.message")>
		<div class="alert #request.status.messagestyle#">
			<h4>
				#request.status.message#
			</h4>
			<cfif request.status.messagetype eq "validationerror" and IsArray(request.status.errors) and not ArrayIsEmpty(request.status.errors)>
				<ul style="margin-top:10px;">
				
					<cfloop array="#request.status.errors#" index="errorItm">
						<li>
							#errorItm#
						</li>
					</cfloop>
				</ul>
			</cfif>
		</div>
	</cfif>
	<cfif request.status.messagetype eq "success">
		<table width="100%" style="margin-bottom:15px;	padding:0px; background:##999">
			<tr>
				<td>
					<p class="center PMS334" 
					   style="font-size: 18px; text-transform: uppercase; font-weight: bold; margin:5px 0px;">
						<strong>
							REGISTRATION SUMMARY
						</strong>
					</p>
				</td>
			</tr>
			<tr>
				<td style="background:##e6e6e6">
					<table width="100%" class="table" style="margin-bottom:0px;">
						<tr>
							<!--Start Left Column-->
							<td width="50%" valign="top" style="border:0px; padding:15px; padding-right:7px;">
								<table width="100%" class="table table-bordered" 
								       style="margin-bottom:0px;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
									<tr>
										<td width="100" style="background:##ABEFBE">
											<strong>
												Order ##
											</strong>
										</td>
										<td style="background:##ffffff;color:##900">
											<strong>
												#request.tr.getConfirmationNum()#
											</strong>
										</td>
									</tr>
									<tr>
										<td width="100" style="background:##ABEFBE">
											<strong>
												Contact
											</strong>
										</td>
										<td style="background:##ffffff;">
											<strong>
												#request.tr.getCustomer().getFirstName()# 
												#request.tr.getCustomer().getLastName()#
											</strong>
										</td>
									</tr>
									
									<tr>
										<td width="100" style="background:##ABEFBE">
											<strong>
												Email
											</strong>
										</td>
										<td style="background:##ffffff;">
											<strong>
												#request.tr.getCustomer().getEmail()#
											</strong>
										</td>
									</tr>
									<tr>
										<td width="100" style="background:##ABEFBE">
											<strong>
												Comments
											</strong>
										</td>
										<td style="background:##ffffff;">
											<strong>
												<cfif Len(Trim(request.tr.getProductSelected().getComments())) gt 0>
													#request.tr.getProductSelected().getComments()#
												<cfelse>
													<em>
														&lt; none entered &gt;
													</em>
												</cfif>
											</strong>
										</td>
									</tr>
								</table>
								
								<table width="100%" class="table table-bordered" 
								       style="margin-top:15px; margin-bottom:0px;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);	-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
									<tr>
										<td width="100" style="background:##ABEFBE">
											<strong>
												League
											</strong>
										</td>
										<td style="background:##FFFFFF; font-weight:bold;">
											#request.tr.getProductSelected().getLeagueName()#
											<br/>
											#request.tr.getProductSelected().getLeagueSeason()#
										</td>
									</tr>
									<tr>
										<td width="100" style="background:##ABEFBE">
											<strong>
												Dates
											</strong>
										</td>
										<td style="background:##FFFFFF">
										
											<cfif Year(request.tr.getProductSelected().getLeagueStartDate()) eq Year(request.tr.getProductSelected().getLeagueEndDate())>
												#DateFormat(request.tr.getProductSelected().getLeagueStartDate(), "mmmm d")#
											<cfelse>
												#DateFormat(request.tr.getProductSelected().getLeagueStartDate(), "mmmm d, yyyy")#
											</cfif>
											- 
											#DateFormat(request.tr.getProductSelected().getLeagueEndDate(), "mmmm d, yyyy")#
										</td>
									</tr>
								</table>
							</td>
							<!--End Left Column-->
							<!--Start Right Column-->
							<td width="50%" valign="top" style="border:0px;padding:15px; padding-left:7px;">
								<cfif isBeforeEarlyDueDate>
									<cfset balanceDueDate = request.leagueBean.getAdLeagueEarlyDueDate()/>
								<cfelse>
									<cfset balanceDueDate = request.leagueBean.getAdLeagueRegDueDate()/>
								</cfif>
								<table width="100%" border="0" cellpadding="0" cellspacing="1"
								       class="table" 
								       style="-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);	-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
									<tr>
										<td width="70%" style="background:##FFFFFF; font-size:14px">
											<strong>
												Registration Total
											</strong>
										</td>
										<td width="30%" 
										    style="background:##FFFFFF; text-align:right; font-size:16px; font-weight:bold;">
											#NumberFormat(request.tr.getProductSelected().getRegTotal(), "$,")#
										</td>
									</tr>
									<cfif not IsNull(request.tr.getPayment().getPromoCode()) and request.tr.getPayment().getPromoCode() 
									      neq "">
										<tr>
											<td width="70%" style="background:##FFFFFF; font-size: 14px; text-align: left;">
												<strong>
													Promo Code
												</strong>
											</td>
											<td width="30%" 
											    style="background:##FFFFFF; font-size: 14px; text-align: right; font-weight: bold;">
												#request.tr.getPayment().getPromoCode()#
											</td>
										</tr>
									</cfif>
									<tr>
										<td width="70%" style="background:##FFFFFF">
											<strong>
												Payment
											</strong>
										</td>
										<td width="30%" 
										    style="background:##FFFFFF; font-size:16px; text-align:right; font-weight:bold;">
											#NumberFormat(request.tr.getPayment().getAmount(), "$,")#
										</td>
									</tr>
									<tr>
										<td width="70%" style="background:##FFFFFF; color:##900; font-size:14px">
											<strong>
												Balance (Due by 
												#DateFormat(balanceDueDate, "m/d/yy")#
												)
											</strong>
										</td>
										<td width="30%" 
										    style="background:##FFFFFF; color:##900; font-size:16px; text-align:right; font-weight:bold;">
											#NumberFormat(request.tr.getProductSelected().getRegBalanceDue(), "$,")#
										</td>
									</tr>
								</table>
								
								<cfif request.tr.getProductSelected().getRegBalanceDue() gt 0>
									<cfif isBeforeEarlyDueDate>
										<!---<p style="color:##F0F">Prior to Early Date</p>--->
										<p style="color: ##000; font-family: Helvetica, Arial, sans-serif; font-size: 12px; text-align: left; font-weight:bold; margin:0 15px 15px ">
											<strong style="color:##900">
												NOTE: 
											</strong>
											If your team is not paid-in-full by due date listed above, your team will not be eligible 
											for the early rate, your team balance will increase to the full league fee, and the card 
											on file will be charged any outstanding balance by 
											<strong style="color: ##900;">
												#DateFormat(balanceDueDate, "m/d/yy")#
											</strong>
											.
										</p>
									<cfelse>
										<!---<p style="color:##F0F">Post Early Date</p>--->
										<p style="color: ##000; font-family: Helvetica, Arial, sans-serif; font-size: 12px; text-align: left; font-weight:bold; margin:0 15px 15px ">
											<strong style="color:##900">
												NOTE: 
											</strong>
											The card on file will be charged any outstanding balance by 
											<strong style="color: ##900;">
												#DateFormat(balanceDueDate, "m/d/yy")#
											</strong>
											.
										</p>
									</cfif>
								</cfif>
							</td>
							<!--End Right Column-->
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<cfelseif request.status.messagetype eq "generror">
	</cfif>

</cfoutput>