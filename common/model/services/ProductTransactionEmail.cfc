component extends="mura.cfobject" {
	$ = application.serviceFactory.getBean('$');
	public ProductTransactionEmail function init(
		tr, 
		formsettings,
		productClassParam,
		customerEmail
	) {
		this.tr = arguments.tr;
		this.formsettings = arguments.formSettings;
		this.productClassParam = arguments.productClassParam;
		this.customerEmail = arguments.customerEmail;
		this.siteID = session.siteID;
		this.mailerService = new mail();
		//WriteDump(this);
		//WriteDump($);
		//abort;

		return this;
	}
	public function sendToCustomer(
		sendTo = "customer"		
	)
	{
		var mailerService = this.mailerService;
		var formSettings =	getBean('content').loadBy(filename=this.formSettings, siteId=this.siteID);
		var emailTo = this.customerEmail;
		var emailFrom = formSettings.getCustomerEmailSender();
		//var emailFrom = "webmaster@chelseapiersct.com";

		var emailSubject = formSettings.getCustomerEmailSubject();
		var emailBody = getEmailBody(this.tr, arguments.sendTo, this.productClassParam);
		
		if(IsDefined("emailTo"))
	    {
	        if(emailTo is not "" AND emailFrom is not "" AND emailSubject is not "")
	        {
	            /* set mail attributes using implicit setters provided */
	            mailerService.setTo(emailTo);
	            mailerService.setFrom(emailFrom);
	            mailerService.setSubject(emailSubject);
	            mailerService.setType("html");
	            mailerService.setBody(emailBody);
				mailerService.send();
				//WriteDump(var=mailerService, label="sendToCustomer");		
	        }
	        //WriteOutput("sendToCustomer: " & true & "<br>");			
			return true;
	    } 
	    return false;
	}
	public function sendToVenue(
		sendTo = "venue"		
	)
	{
		var mailerService = this.mailerService;
		var formSettings =	getBean('content').loadBy(filename=this.formSettings, siteId=this.siteID);
		var emailTo = Replace(formSettings.getVenueEmailRecipients(),"^", ",","all");
		var emailBCC = "schwas@chelseapiers.com,tysont@chelseapiers.com";
		var emailFrom = this.customerEmail;
		var emailSubject = formSettings.getVenueEmailSubject();
		var emailBody = getEmailBody(this.tr, arguments.sendTo, this.productClassParam);

		if (Left(emailTo, 1) == ",") {
			emailTo = removeChars(emailTo, 1, 1);
		}

		if(IsDefined("emailTo"))
	    {
	        if(emailTo is not "" AND emailFrom is not "" AND emailSubject is not "")
	        {
	            /* set mail attributes using implicit setters provided */
	            mailerService.setTo(emailTo);
	            mailerService.setFrom(emailFrom);
	            mailerService.setBCC(emailBCC);
	            mailerService.setSubject(emailSubject);
	            mailerService.setType("html");
	            mailerService.setBody(emailBody);
	            mailerService.send();
				//WriteDump(var=mailerService, label="sendToVenue");
				//abort;
			}
	        //WriteOutput("sendToVenue: " & true & "<br>");
	    	//abort;
	    	return true;
	    } 
	    return false;
	}
	
	private function getFormSettings() {
		var resultfilename = "";
		resultFileName = this.formsettings;
		return resultfilename;
	}
	private String function getEmailBody(tr, sendto, productClassParam) {
		/*var emailFile = FileOpen("#$.globalConfig('plugindir')#/ProductModule/includes/display_objects/emails_to_#arguments.sendTo#/email#arguments.sendTo#_#this.productParam#.cfm", "read");
		var emailBody = FileRead("#$.globalConfig('plugindir')#/ProductModule/includes/display_objects/emails_to_#arguments.sendTo#/email#arguments.sendTo#_#this.productParam#.cfm", "utf-8");*/
		savecontent variable="emailBody"{ 
			if (IsDefined("request.leagueBean")) {
				isBeforeEarlyDueDate =   not IsNull(request.leagueBean.getAdLeagueEarlyDueDate()) 
                	and IsDate(request.leagueBean.getAdLeagueEarlyDueDate())
                    and DateDiff('d',request.leagueBean.getAdLeagueEarlyDueDate(), now()) lte 0                       
        		;
        	}
			include "/plugins/ProductModule/includes/display_objects/emails_to_#arguments.sendTo#/email#arguments.sendTo#_#this.productClassParam#.cfm";
		}
		return emailBody;
	}
	
}