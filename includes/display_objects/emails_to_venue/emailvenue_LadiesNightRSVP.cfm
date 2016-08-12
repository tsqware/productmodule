<cfset itemObj = tr.getProductSelected() />

<cfoutput>
	<h2 style="font-family: Helvetica, Arial; font-size:20px; font-weight: bold;margin-top:0px;margin-bottom:0px;">Chelsea Piers Connecticut</h2>
	<h2 style="font-family: Helvetica, Arial; font-size:24px; font-weight: bold;margin-top:0px;margin-bottom:10px;">#itemObj.getProductName()#</h2>
	<h3 style="font-family: Helvetica, Arial; font-size:18px; font-weight: bold;margin-top:0px;margin-bottom:10px; color :##990000;">
		#DateFormat(tr.getProductSelected().getEventStart(), "mmmm d, yyyy")# |
    #LCase(TimeFormat(tr.getProductSelected().getEventStart(), "h:mmtt"))# - #LCase(TimeFormat(tr.getProductSelected().getEventEnd(), "h:mmtt"))#<!--- --->
	</h3>

	<table width="620" border="0" cellpadding="0" cellspacing="0" style="margin: 10px auto; border: 1px solid ##999">
		<tr>
			<td>
				<div style="padding:0; width:620px; height:33px; background: ##656565 url(http://chelseapiersct.com/css/images/BtmBlankshadow.png) repeat-x left bottom; display:block; border:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding:0; margin:0;">
						<tr>
							<td style="padding:10px; font-size:9px; line-height:9px; font-family:Arial, Helvetica, sans-serif; vertical-align:top;">
								<a href="http://www.chelseapiersCT.com/" target="_blank">
									<img src="http://www.chelseapiersct.com/css/images/chelsea_piers_txt_wht.png" width="91" height="14" style="display:inline-block; border:none;" /></a>&nbsp;&nbsp;<strong style="color:##fff; display:inline-block; vertical-align:top;">CONNECTICUT</strong>
							</td>
							<td style="padding:10px; font-size:11px; line-height:11px; font-family:Arial, Helvetica, sans-serif; vertical-align:top;">
								<strong style="color:##fff; text-align:right; display:block">ORDER #tr.getConfirmationNum()#</strong>                
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td style="padding:15px;">
				<table width="100%" border="0" cellpadding="0" cellspacing="1" style="margin: 0px auto; -moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6); -webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6); border-collapse: separate; border-spacing: 1px; background-color: ##898989;">
					<tr>
						<td><p style="font-size: 18px; font-family: Helvetica, Arial, sans-serif; text-transform: uppercase; font-weight: bold; text-align: center; color: ##FFF; background-color: ##00997C; margin: 0px; padding: 8px 10px;" align="center"><strong>RSVP SUMMARY</strong></p></td>
					</tr>
					<tr>
						<td>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="50%" valign="top" style="background-color:##898989; padding:15px; padding-right:7px;">
										<table width="100%" border="0" cellpadding="0" cellspacing="1" style="border-collapse: separate; border-spacing: 1px; background-color: ##787878;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);  -webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
											<tr>
												<td style="background-color:##ABEFBE; width:100px;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Name</strong></p></td>
												<td style="background:##ffffff;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>#tr.getCustomer().getFirstName()# #tr.getCustomer().getLastName()#</strong></p></td>
											</tr>
											<tr>
												<td height="34" valign="top" style="background-color:##ABEFBE; width:100px;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong> Email</strong></p></td>
												<td valign="top" style="background-color:##FFFFFF"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>#tr.getCustomer().getEmail()#</strong></p></td>
											</tr>
										</table>
									</td>
									<td style="background-color:##898989; padding:15px; padding-left:7px;">
										<table width="100%" border="0" cellpadding="0" cellspacing="1" class="Table" style="-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6); -webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6); background-color: ##787878;">
											<tr>
												<td style="background-color:##ABEFBE; width:100px;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Guest Name</strong></p></td>
												<td style="background:##ffffff;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>

													<cfset hasGuestFirstName = (not IsNull(itemObj.getGuestFirstName()) and Len(itemObj.getGuestFirstName()) gt 0) />
													<cfset hasGuestLastName = (not IsNull(itemObj.getGuestLastName()) and Len(itemObj.getGuestLastName()) gt 0) />

													<cfif hasGuestFirstName and hasGuestLastName>
														#itemObj.getGuestFirstName()# #itemObj.getGuestLastName()#
													<cfelse>
														<span style="font-style:italic; font-weight:normal;">&lt; none &gt;</span>
													</cfif>
												</strong></p></td>
											</tr>
											<tr>
												<td height="34" valign="top" style="background-color:##ABEFBE; width:100px;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Guest Email</strong></p></td>
												<td valign="top" style="background-color:##FFFFFF"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>

													<cfset hasGuestEmail = (not IsNull(itemObj.getGuestEmail()) and Len(itemObj.getGuestEmail()) gt 0) />

													<cfif hasGuestEmail>
														#itemObj.getGuestEmail()#
													<cfelse>
														<span style="font-style:italic; font-weight:normal;">&lt; none &gt;</span>
													</cfif>

												</strong></p></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>

