component accessors="true" {
	property ProductService;
	property EventRSVPService;
	property ProductTypeService;
	property SportsLeagueRegService;
	property ContactFormService;

	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public void function default( rc ) {
		rc.when = now(); // set when for service argument
		// queue up a specific service (formatter.longdate) with named result (today)
		variables.fw.service( 'formatter.longdate', 'today' );
	}

	public void function start(rc) {
		//rc.prodType = 'EventRSVP';
		//rc.prod = 'DateNightRSVP';
		//WriteOutput('#rc.prodType#Service.loadByParam("#rc.prod#")');
		rc.product = evaluate('#rc.prodType#Service.loadByParam("#rc.prod#")');
		//WriteDump(rc.product);
		var requiredFields = rc.product.getFormConfig().getRequiredFields();
		rc.requiredFieldNames = [];
		for(var f in requiredFields) {
			ArrayAppend(rc.requiredFieldNames, f.getFieldParam());
		}
		rc.dispFormFile = 'dsp_#rc.prodType#_#rc.prod#';
		rc.title = rc.product.getProductName() & ' Registration Form';
		
		//WriteOutput(dispFormFile);
		//WriteDump(var=evaluate('#rc.prodType#Service.loadByParam("#rc.prod#")'), label="svc");
		//abort;
	}
	public void function handleForm(rc) {
		WriteDump(rc);
		rc.product = evaluate('#rc.prodType#Service.loadByParam("#rc.prod#")');
		rc.dispFormFile = 'dsp_#rc.prodType#_#rc.prod#_confirm';
		rc.title = rc.product.getProductName() & ' Registration Form Confirmation';
	}
	
}