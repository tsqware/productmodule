<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	
		<div class="row">
			<h1>#rc.title#</h1>
		</div>
		<div class="row">
			<div class="col-md-8" style="padding:0px;">
				<h3 style="font-weight:normal; margin-bottom:20px;">
				Click on the product links below to view and change product settings.</h3>		
				<cfif not ArrayIsEmpty(rc.productTypes)>
					<cfloop array="#rc.productTypes#" index="pt">
						<div class="col-xs-6">
							<div class="panel panel-default">
								<div class="panel-body">
									<h3 style="margin-top:0px;">#pt.name#</h3>
									<cfif not ArrayIsEmpty(pt.products)>
										<ul>					
											<cfloop array="#pt.products#" index="pr">
												<li><a href="#buildURL(action='#LCase(pt.ptclass)#.edit', querystring='prod=#pr.getProductURLParam()#')#">#pr.getProductName()#</a></li>
											</cfloop>
										</ul>
									<cfelse>
										<p>There are no #pt.name# products created.</p>
									</cfif>
									<p><a href="#buildURL(action='#LCase(pt.ptclass)#.create')#">Create new #pt.name#</a></p>
								</div>
							</div>
						</div>
					</cfloop>
				<cfelse>
					<p>There are no product types created.</p>
				</cfif>
			</div>
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-body">
						<a href="#buildURL(action='venuecontact.list')#">Venue Contacts</a>
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
						<a href="#buildURL(action='emailsender.list')#">Email Senders</a>
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
						<a href="#buildURL(action='emailrecipient.list')#">Email Recipients</a>
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
						<a href="#buildURL(action='paymenttype.list')#">Payment Types</a>
					</div>
				</div>
			</div>
					
		
		
		
				<!---
				<cfif IsDefined("rc.memHeader")>
					<h2>#rc.memHeader#</h2>
					<cfif not ArrayIsEmpty(rc.eventRSVPProducts)>
						<ul>
							<cfloop array="#rc.eventRSVPProducts#" index="prod">
								<li>#prod.getProductName()#</li>
							</cfloop>
						</ul>
					<cfelse>
						<p>No #rc.memHeader#s created.<br />Create new #rc.memHeader#</p>
					</cfif>		
				
				</cfif>
				
				<cfif IsDefined("rc.socHeader")>
					<h2>#rc.socHeader#</h2>
					<cfif not ArrayIsEmpty(rc.adultLeagueProducts)>
						<ul>
							<cfloop array="#rc.adultLeagueProducts#" index="prod">
								<li>#prod.getProductName()#</li>
							</cfloop>
						</ul>
					<cfelse>
						<p>No #rc.socHeader#s created.<br />Create new #rc.socHeader#</p>
					</cfif>		
				</cfif>
				--->
		</div>
	
</cfoutput>