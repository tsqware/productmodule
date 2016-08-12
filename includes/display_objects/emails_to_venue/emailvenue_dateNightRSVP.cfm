<cfoutput>
	<h2 style="font-family: Helvetica, Arial; font-size:24px; font-weight: bold;margin-top:0px;margin-bottom:10px;">#tr.getProductSelected().getProductName()#</h2>
	<table width="620" border="0" cellpadding="0" cellspacing="0" style="margin: 10px auto; ">
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
      <td><table width="620" border="0" cellpadding="0" cellspacing="1" style="margin: 0px auto; -moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6); -webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6); border-collapse: separate; border-spacing: 1px; background-color: ##898989;">
        <tr>
          <td><p style="font-size: 18px; font-family: Helvetica, Arial, sans-serif; text-transform: uppercase; font-weight: bold; text-align: center; color: ##FFF; background-color: ##00997C; margin: 0px; padding: 8px 10px;" align="center"><strong>RSVP SUMMARY</strong></p></td>
        </tr>
        <tr>
        	<td>
          	<table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="50%" valign="top" bgcolor="##898989" style="padding:15px; padding-right:7px;">
                <table width="100%" border="0" cellpadding="0" cellspacing="1" style="border-collapse: separate; border-spacing: 1px; background-color: ##787878;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);	-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">
                  <tr>
                    <td bgcolor="##ABEFBE"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>Name</strong></p></td>
                    <td style="background:##ffffff;"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>#tr.getCustomer().getFirstName()# #tr.getCustomer().getLastName()#</strong></p></td>
                  </tr>
                  <tr>
                    <td height="34" valign="top" bgcolor="##ABEFBE"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong> Email</strong></p></td>
                    <td valign="top" bgcolor="##FFFFFF"><p style="text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong>#tr.getCustomer().getEmail()#</strong></p></td>
                  </tr>
                  </table></td>
                <td bgcolor="##898989" style="padding:15px; padding-left:7px;"><table width="100%" border="0" cellpadding="0" cellspacing="1" class="Table" style="-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);	-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6); background-color: ##787878;">
                  <tr>
                    <td style="background:##ffffff;"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong> Total Children Over 5</strong></p></td>
                    <td style="background:##ffffff;"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px;" align="right">#itemObj.getNumberOfChildrenOver5()#</p></td>
                  </tr>
                  <tr>
                    <td style="background:##ffffff;"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong> Total Children Under 5</strong></p></td>
                    <td style="background:##ffffff;"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px;" align="right">#itemObj.getNumberOfChildrenUnder5()#</p></td>
                  </tr>
                  <tr>
                    <td width="70%" bgcolor="##FFFFFF"><p style="font-size: 14px; text-align: left; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:13px;" align="left"><strong> Total Charged to Account</strong></p></td>
                    <td width="30%" bgcolor="##FFFFFF"><p style="font-size: 16px; text-align: right; font-weight: bold; margin: 0px; padding: 8px 10px; font-family: Helvetica, Arial, sans-serif; font-size:16px; color: ##D10000;;" align="right">#NumberFormat(tr.getPayment().getAmount(),"$,")#</p></td>
                  </tr>
                </table></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td bgcolor="##898989"><div style="margin: 15px; background-color: ##FFC; padding:10px;">
            <p style="font-weight:bold;font-family: Helvetica, Arial, sans-serif; font-size:14px;margin:0px; text-align:center;"> <a href="https://www.chelseapiersct.com/cpsite/adm/DateNightRSVPMgr" target="_blank" style="color: ##900;">Click here</a> for the Date Night RSVP Manager. </p>
          </div></td>
        </tr>
      </table></td>
    </tr>
  </table>
</cfoutput>