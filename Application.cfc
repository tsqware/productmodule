component extends="org.corfield.framework" {

	this.name = "ProductModule";
	this.sessionmanagement= true;
    this.sessiontimeout= CreateTimeSpan(0,0,45,0);
	this.ormenabled = true;
	this.datasource = "devcpctproducts";
	this.ormsettings.cfclocation = "/productmodule/adminconfig/model/ent";
	this.ormsettings.flushatrequestend = false;
		

	/// FW1 Configuration
	variables.framework = {};

	// !important: enter the plugin packageName here. must be the same as found in '{context}/plugin/config.xml.cfm'
	variables.framework.package = 'ProductModule';
	variables.framework.packageVersion = '1.0.0';

	// If true, then additional information is returned by the Application.onError() method
	// and FW1 will 'reloadApplicationOnEveryRequest' (unless explicitly set otherwise below).
	variables.framework.debugMode = true;
	
	// change to TRUE if you're developing the plugin so you can see changes in your controllers, etc.
	variables.framework.reloadApplicationOnEveryRequest = variables.framework.debugMode ? true : false;

	// the 'action' defaults to your packageNameAction, (e.g., 'MuraFW1action') you may want to update this to something else.
	// please try to avoid using simply 'action' so as not to conflict with other FW1 plugins
	variables.framework.action = variables.framework.package & 'action';

	// less commonly modified
	variables.framework.defaultSection = 'main';
	variables.framework.defaultItem = 'default';
	variables.framework.usingSubsystems = true;
	variables.framework.defaultSubsystem = 'adminconfig';

	// by default, fw1 uses 'fw1pk' ... however, to allow for plugin-specific keys, this plugin will use your packageName + 'pk'
	variables.framework.preserveKeyURLKey = variables.framework.package & 'pk';

	// reload application keys
	variables.framework.reload = 'reload';
	variables.framework.password = 'appreload'; // IF you're NOT using the default reload key of 'appreload', then you'll need to update this to match the setting found in /config/settings.ini.cfm!

	// ***** rarely modified *****
	variables.framework.applicationKey = variables.framework.package;
	variables.framework.base = '/' & variables.framework.package;
	variables.framework.generateSES = false;
	variables.framework.SESOmitIndex = true;
	variables.framework.baseURL = 'useRequestURI';
	variables.framework.suppressImplicitService = false; //true to suppress fw/1 from storing service calls results in rc.data
	variables.framework.unhandledExtensions = 'cfc';
	variables.framework.unhandledPaths = '/flex2gateway';
	variables.framework.maxNumContextsPreserved = 10;
	variables.framework.cacheFileExists = false;

	if ( variables.framework.usingSubSystems ) {
		variables.framework.subsystemDelimiter = ':';
		variables.framework.siteWideLayoutSubsystem = 'common';
		variables.framework.home = variables.framework.defaultSubsystem & variables.framework.subsystemDelimiter & variables.framework.defaultSection & '.' & variables.framework.defaultItem;
		variables.framework.error = variables.framework.defaultSubsystem & variables.framework.subsystemDelimiter & variables.framework.defaultSection & '.error';
	} else {
		variables.framework.home = variables.framework.defaultSection & '.' & variables.framework.defaultItem;
		variables.framework.error = variables.framework.defaultSection & '.error';
	};

	// add routes 
	variables.framework.routes = [
		{"$GET/displayform/:id/:id/$" = "/public:displayform/start/prodtype/:id/prod/:id" } // route for form
	];

	function setupRequest() {
		// use setupRequest to do initialization per request
		request.context.startTime = getTickCount();
	}

	public any function setupApplication() {
		var local = {};
		
		// Bean Factory Options

		// 1) Use DI/1
		// just be sure to pass in your comma-separated list of folders to scan for CFCs
		//WriteDump("/#variables.framework.package#/adminconfig/model");
		local.beanFactory = new factory.ioc(
			'/#variables.framework.package#/adminconfig/model'
		);
		local.beanFactory.addBean( "prdao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.ProductDAO()") );
		local.beanFactory.addBean( "ptdao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.ProductTypeDAO()") );
		local.beanFactory.addBean( "vcdao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.VenueContactDAO()") );
		local.beanFactory.addBean( "rfdao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.RequiredFieldDAO()") );
		local.beanFactory.addBean( "paytypedao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.PaymentTypeDAO()") );
		local.beanFactory.addBean( "pricetypedao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.PriceTypeDAO()") );
		local.beanFactory.addBean( "pricedao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.PriceDAO()") );
		
		local.beanFactory.addBean( "fcdao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.FormConfigDAO()") );
		local.beanFactory.addBean( "emnotifdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.EmailNotificationDAO()") );
		local.beanFactory.addBean( "emsenddao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.EmailSenderDAO()") );
		local.beanFactory.addBean( "emrecdao", 		evaluate("new #variables.framework.package#.adminconfig.model.dao.EmailRecipientDAO()") );
		local.beanFactory.addBean( "eventrsvpdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.EventRSVPDAO()") );
		local.beanFactory.addBean( "prodpricedao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.ProductPriceDAO()") );
		
		local.beanFactory.addBean( "dropindao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.DropInProgramDAO()") );
		local.beanFactory.addBean( "dropinschdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.DropInProgramScheduleItemDAO()") );
		
		local.beanFactory.addBean( "leagueregdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsLeagueRegDAO()") );
		local.beanFactory.addBean( "seasondao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsSeasonDAO()") );
		local.beanFactory.addBean( "seasonwithlgdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsSeasonWithLeaguesDAO()") );
		local.beanFactory.addBean( "seasonwithdivdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsSeasonWithDivisionsDAO()") );
		local.beanFactory.addBean( "sportsleaguedao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsLeagueDAO()") );
		local.beanFactory.addBean( "sportsleaguedivdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsLeagueDivisionDAO()") );
		local.beanFactory.addBean( "sportsseasondivdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SportsSeasonDivisionDAO()") );
		local.beanFactory.addBean( "seapricedao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.SeasonPriceDAO()") );
		
		local.beanFactory.addBean( "ctformdao", 	evaluate("new #variables.framework.package#.adminconfig.model.dao.ContactFormDAO()") );
		
		
		
		setBeanFactory( local.beanFactory );

		// OR

		// 2) Use Mura's
		// local.pc = application[variables.framework.applicationKey].pluginConfig;
		// setBeanFactory(local.pc.getApplication(purge=false));
	}

	
}