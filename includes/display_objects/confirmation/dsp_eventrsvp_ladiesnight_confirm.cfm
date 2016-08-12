﻿<cfscript>	tMgr = new pmservices.ProductTransactionManager();	tMgr.load();	WriteDump(tMgr);	fileName = form.formSettingsFile;	formSettings = $.getBean('content').loadBy(filename=fileName, siteId=session.siteID);	requiredFields = ListToArray(formSettings.getRequiredFields());	paymentTypes = ListToArray(formSettings.getPaymentTypes());	tMgr.beginTransaction(requiredFields, paymentTypes);</cfscript><!---<cfdump var="#request#" /><cfabort />---><cfoutput>	<cfif IsDefined("request.status.message")>		<div class="alert #request.status.messagestyle#">			<h4>				#request.status.message#			</h4>			<cfif request.status.messagetype eq "validationerror" and IsArray(request.status.errors) and not ArrayIsEmpty(request.status.errors)>				<ul style="margin-top:10px;">									<cfloop array="#request.status.errors#" index="errorItm">						<li>							#errorItm#						</li>					</cfloop>				</ul>			</cfif>		</div>	</cfif>	<cfif request.status.messagetype eq "success">		<table width="100%" style="margin-bottom:15px;	padding:0px; background:##999">			<tr>				<td>					<p class="center PMS334" 					   style="font-size: 18px; text-transform: uppercase; font-weight: bold; margin:5px 0px;">						<strong>							RSVP						</strong>						SUMMARY					</p>				</td>			</tr>			<tr>				<td style="background:##e6e6e6">					<table width="100%" class="table" style="margin-bottom:0px;">						<tr>							<!--Start Left Column-->							<td width="50%" valign="top" style="border:0px; padding:15px; padding-right:7px;">								<table width="100%" class="table table-bordered" 								       style="margin-bottom:0px;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">									<tr>										<td width="85" style="background:##ABEFBE">											<p>												<strong>													Order ##												</strong>											</p>										</td>										<td style="background:##ffffff;">											<p style="color:##900">												<strong>													#request.tr.getConfirmationNum()#												</strong>											</p>										</td>									</tr>									<tr>										<td width="85" style="background:##ABEFBE">											<p>												<strong>													Name												</strong>											</p>										</td>										<td style="background:##ffffff;">											<p>												<strong>													#request.tr.getCustomer().getFirstName()# 													#request.tr.getCustomer().getLastName()#												</strong>											</p>										</td>									</tr>																		<tr>										<td width="85" style="background:##ABEFBE">											<p>												<strong>													Email												</strong>											</p>										</td>										<td style="background:##ffffff;">											<p>												<strong>													#request.tr.getCustomer().getEmail()#												</strong>											</p>										</td>									</tr>								</table>							</td>							<!--End Left Column-->							<!--Start Right Column-->							<td width="50%" valign="top" style="border:0px;padding:15px; padding-left:7px;">								<table width="100%" class="table table-bordered" 								       style="margin-bottom:0px;-moz-box-shadow: 0 2px 3px rgba(0,0,0,0.6);	-webkit-box-shadow: 0 2px 3px rgba(0,0,0,0.6);">									<tr>										<td width="100" style="background:##ABEFBE">											<p style="font-size:14px">												<strong>													Guest												</strong>											</p>										</td>										<td style="background:##FFFFFF">											<p style="font-size:16px; text-align:right; font-weight:bold;" id="dspRegTotal">												#request.tr.getProductSelected().getGuestFirstName()# 												#request.tr.getProductSelected().getGuestLastName()#											</p>										</td>									</tr>									<tr>										<td width="100" style="background:##ABEFBE">											<p style="font-size:14px">												<strong>													Guest Email												</strong>											</p>										</td>										<td style="background:##FFFFFF">											<p style="font-size:16px; text-align:right; font-weight:bold;" id="dspRegTotal">												#request.tr.getProductSelected().getGuestEmail()#											</p>										</td>									</tr>								</table>							</td>							<!--End Right Column-->						</tr>					</table>				</td>			</tr>		</table>	<cfelseif request.status.messagetype eq "generror">	</cfif></cfoutput>