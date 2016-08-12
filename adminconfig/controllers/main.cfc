
component persistent="false" accessors="true" output="true" {
	property ProductService;
	property ProductTypeService;
	property VenueContactService;
	property Security;

	public function init(fw) {
		variables.fw = fw;
		return this;
	}
	
	// *********************************  PAGES  *******************************************

	public any function default(required rc) {
		var products = [];
		rc.productTypes = [];
		rc.title = "Product Module Setup";
		
		rc.productTypesList = ProductTypeService.list();
		rc.venuecontacts = VenueContactService.list();
		for (pt in rc.productTypesList) {
			var st = {
				name = pt.getProductTypeName(),
				prm = pt.getProductTypeParam(),
				ptclass = pt.getProductTypeClassName()				
			};
			st.products = ProductTypeService.listInProductType(st.prm);
			ArrayAppend(rc.productTypes, st);
		}
		//WriteDump(rc.productTypes);
		//abort;
	}

}