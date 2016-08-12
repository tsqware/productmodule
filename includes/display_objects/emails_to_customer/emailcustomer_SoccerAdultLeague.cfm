<cfset itemObj = tr.getProductSelected() >
<cfif isBeforeEarlyDueDate>
    <cfset balanceDueDate = request.leagueBean.getAdLeagueEarlyDueDate() />
<cfelse>
    <cfset balanceDueDate = request.leagueBean.getAdLeagueRegDueDate() />
</cfif>

<cfoutput>
	<h2 style="font-family: Helvetica, Arial; font-size:20px; font-weight: bold;margin-top:0px;margin-bottom:0px;">Chelsea Piers Connecticut</h2>
		<h2 style="font-family: Helvetica, Arial; font-size:24px; font-weight: bold;margin-top:0px;margin-bottom:10px;">#itemObj.getProductName()#</h2>
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
       <td style="padding: 10px 15px"><p style="font-family:Arial,Helvetica,sans-serif;font-size:24px;"><strong>Thank you for your registration.</strong></p>
         <p style="font-family:Arial,Helvetica,sans-serif;font-size:14px;">Below is a summary of your RSVP information.</p>
         <p style="font-family:Arial,Helvetica,sans-serif;font-size:14px;">If you have any questions regarding your RSVP, please call 203.989.1700 or email <a href="mailto:soccer@chelseapiersct.com">soccer@chelseapiersct.com</a>.</p></td>
     </tr>
     <tr>
       <td style="padding:15px;"><table width="100%" border="0" cellpadding="0" cellspacing="1" style="margin: 0px auto; -moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6); -webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6); border-collapse: separate; border-spacing: 1px; background-color: ##898989;">
         <tr>
           <td><p style="font-size: 18px; font-family: Helvetica, Arial, sans-serif; text-transform: uppercase; font-weight: bold; text-align: center; color: ##FFF; background-color: ##00997C; margin: 0px; padding: 8px 10px;" align="center"><strong>RSVP SUMMARY</strong></p></td>
         </tr>
         <tr>
           <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="50%" valign="top" bgcolor="##898989" style="padding:15px; padding-right:7px;">
                <table width="100%" class="table table-bordered" 
								style="margin-bottom:0px;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
                	<tr>
                		<td bgcolor="##ABEFBE">
							<p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Contact</strong></p></td>
                		<td style="background:##ffffff;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>#tr.getCustomer().getFirstName()# #tr.getCustomer().getLastName()#</strong></td>
                		</tr>
                	<tr>
                		<td bgcolor="##ABEFBE">
							<p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Email</strong>
                			</p></td>
                		<td style="background:##ffffff;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>#tr.getCustomer().getEmail()#</strong></td>
                		</tr>
                	<tr>
                		<td bgcolor="##ABEFBE">
							<p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Comments</strong>
                			</p></td>
                		<td style="background:##ffffff;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>
                			<cfif Len(Trim(itemObj.getComments())) gt 0>
                				#itemObj.getComments()#
                				<cfelse>
                				<em>&lt; none entered &gt;</em>
                				</cfif>
                			</strong></td>
                		</tr>
                	</table>
                <br /></td>
                <td bgcolor="##898989" style="padding:15px; padding-left:7px;"><table width="100%" border="0" cellpadding="0" cellspacing="1" class="table" 
								style="-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);	-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
                	<tr>
						   	    <td style="background:##ffffff;"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Registration Total</strong></td>
						   	    <td style="background:##ffffff;"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px;" align="right">
						        	#NumberFormat(itemObj.getRegTotal(),"$,")#</td>
						 	    </tr>
						     	<cfif not IsNull(tr.getPayment().getPromoCode()) and tr.getPayment().getPromoCode() neq "">
						   	    	<tr>
						   	      	<td style="background:##ffffff;"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left">
						   	      		<strong>Promo Code</strong></td>
						   	      	<td style="background:##ffffff;"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px;" align="right">#tr.getPayment().getPromoCode()#</td>
						 	     	</tr>
						 	    </cfif>
						   	  <tr>
						   	    <td style="background:##ffffff;"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Payment</strong></td>
						   	    <td style="background:##ffffff;"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px;" align="right">#NumberFormat(tr.getPayment().getAmount(),"$,")#</td>
						 	    </tr>
						   	  <tr>
						   	    <td width="70%" bgcolor="##FFFFFF"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Balance (Due by #DateFormat(balanceDueDate, "m/d/yy")#)</strong></td>
						   	    <td width="30%" bgcolor="##FFFFFF"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px; color: ##D10000;;" align="right">#NumberFormat(itemObj.getRegBalanceDue(),"$,")#</td>
						 	    </tr>
				 	  </table>
						
						<cfif itemObj.getRegBalanceDue() gt 0>
								  <cfif isBeforeEarlyDueDate>
										<!---<p style="color:##F0F">Prior to Early Date</p>--->
							            <p style="color: ##000; font-family: Helvetica, Arial, sans-serif; font-size: 12px; text-align: left; font-weight:bold; margin:15px 0px 0px; padding:10px; background-color:##fff;"><strong style="color:##900">NOTE: </strong>If your team is not paid-in-full by due date listed above, your team will not be eligible for the early rate, your team balance will increase to the full league fee, and the card on file will be charged any outstanding balance by <strong style="color: ##900;">#DateFormat(balanceDueDate,"m/d/yy")#</strong>.</p>
							      <cfelse>
							            <!---<p style="color:##F0F">Post Early Date</p>--->
							            <p style="color: ##000; font-family: Helvetica, Arial, sans-serif; font-size: 12px; text-align: left; font-weight:bold; margin:0px; padding:10px; background-color:##fff;"><strong style="color:##900">NOTE: </strong>The card on file will be charged any outstanding balance by <strong style="color: ##900;">#DateFormat(balanceDueDate,"m/d/yy")#</strong>.</p>
								  </cfif>
							  </cfif>
				</td>
              </tr>
            </table></td>
         </tr>
       </table></td>
     </tr>
   </table>
</cfoutput>