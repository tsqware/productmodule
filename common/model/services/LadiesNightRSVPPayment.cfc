
component extends="mura.plugin.pluginGenericEventHandler" {
	$ = application.serviceFactory.getBean('$');
	public LadiesNightRSVPPayment function init() 
	{
		return this;	
	}
	
	public function getPrice() {
		var price = 0;
		return price;
	}	
}