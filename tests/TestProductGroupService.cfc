component extends="mxunit.framework.TestCase"
{
	public void function beforeTests() hint="put things here that you want to run before all tests" {
		//ormreload();
		mockBox = createObject("component","mockbox.system.testing.MockBox").init();
		//dao = CreateObject("component","ProductModule.adminconfig.model.dao.ProductTypeDAO").init();
		//productTypeService = mockBox.prepareMock( createObject("component","ProductModule.adminconfig.model.services.ProductTypeService") );
		productTypeService = mockBox.createMock('ProductModule.adminconfig.model.services.ProductTypeService');
		mockDAO = mockBox.createEmptyMock("ProductModule.adminconfig.model.dao.ProductTypeDAO");
		mockDAO.$("new", 
			EntityNew("ProductType")
		);
		mockDAO.$("list",
			   	[
			 	   	EntityNew("ProductType", {
						productTypeID=1,
						productTypeName="Event RSVP",
						productTypeParam="event-rsvp",
						productTypeClassName="EventRSVP"
					}),
					EntityNew("ProductType", {
						productTypeID=2,
						productTypeName="Sports League Reg",
						productTypeParam="sports-league-reg",
						productTypeClassName="SportsLeagueReg"
					})
				]
		);

		mockDAO.$("load", 			
			EntityNew("ProductType", {
				productTypeID=4,
				productTypeName="Standalone",
				productTypeParam="standalone",
				productTypeClassName="Standalone"
			})
		);
		
		
		productTypeService.init(mockDAO);
		
		
	}
	
	/*public void function ProductTypeListShouldReturnArrayIfUniqueParamNotPassed()  {
		var filterProductType = productTypeService.list(filter={productTypeID=1});
		
		debug("ProductTypes should return an array if unique=FALSE.");
		assertTrue(IsArray(filterProductType), "ProductTypes should return an array if unique=FALSE.");
	}*/
	public void function ProductTypeListShouldReturnNonEmptyArrayIfUniqueParamNotPassed()  {
		plist = productTypeService.list();
		assertFalse(ArrayIsEmpty(plist), "ProductTypes should not be empty.");
	}
	/*public void function ProductTypeListShouldNotReturnArrayIfUniqueParamPassed()  {
		
		var producttype = productTypeService.list(filter={productTypeID=1}, unique="true");
		//var producttypename = producttype.getProductTypeName();
		
		debug("ProductTypes should not be an array if unique=TRUE.");
		assertFalse(IsArray(producttype), "ProductTypes should not be an array if unique=TRUE.");
	}*/
	public void function ProductTypeLoadShouldReturnEntityIfUniqueParamPassed()  {
		
		var producttype = productTypeService.load(1);
		//var producttypename = producttype.getProductTypeName();
		
		debug("ProductTypes must return a ProductType entity if unique=TRUE.");
		assertEquals(
	    	true, 
	    	IsInstanceOf(producttype, "ProductModule.adminconfig.model.ent.ProductType"),
	    	"ProductTypes must return a ProductType entity if unique=TRUE."
	    );
	}
	public void function ProductTypeLoadOneShouldEqualStandalone()  {
		
		var producttype = productTypeService.load(1);
		var producttypename = producttype.getProductTypeName();
		
		debug("The first element of ProductTypeName should be Standalone");
	    //assertEquals("Standalone", producttypename, "ProductTypeName should be Standalone");
	}
	
	public void function loadByParamShouldReturnEmptyArrayIfNoParamPassed() {
		debug("loadByParam() must return NULL because no param was passed.");
		var producttypes = productTypeService.loadByParam();
		assertTrue(ArrayIsEmpty(producttypes), "loadByParam() must return empty array because no param was passed.");
	}
	
	public void function loadByParamShouldReturnNonNullIfNoParamPassed() {
		debug("loadByParam() must return NONNULL because a valid param was passed");
		producttype = productTypeService.loadByParam( "event-rsvp" );
		assertFalse(IsNull(producttype), "loadByParam() must return NONNULL because a valid param was passed");
	}
	
	public void function loadByParamShouldReturnProductTypeEntityIfParamPassed() {
		var producttype = productTypeService.loadByParam( "event-rsvp" );
		//assertEquals("standalone", producttype.getProductTypeParam());
		assertTrue( IsInstanceOf(
			producttype, 
			"cpctroot.ProductModule.adminconfig.model.ent.ProductType"), 
			"loadByParam() must return a ProductType entity because a valid param was passed");
	}
	
	public void function newShouldContainAllEmptyValues() {
		var producttype = productTypeService.new();
		
		debug("New ProductTypeID must be null");
		assertTrue(IsNull(producttype.getProductTypeID()), "New ProductTypeID must be null");
		
		debug("New ProductTypeName must be null");
		assertTrue(IsNull(producttype.getProductTypeName()), "New ProductTypeName must be null");
		
		debug("New ProductTypeParam must be null");
		assertTrue(IsNull(producttype.getProductTypeParam()), "New ProductTypeParam must be null");
	}
	
	public void function newShouldBeAProductTypeEntity() {
		var producttype = productTypeService.new();
		
		debug("New ProductType must be a ProductType");
		assertIsTypeOf(
			producttype, "cpctroot.ProductModule.adminconfig.model.ent.ProductType",
			"New ProductType must be a ProductType"
		);
	}
	
	/*public void function saveNewProductTypeShouldReturnString() {
		var rc = {};
		rc.productTypeName = "Events";
		rc.productTypeParam = "events";
		var newProductType = productTypeService.new();
		var msg = productTypeService._save(newProductType);
		assertEquals(msg, "The Product Type '#form.productTypeName#' is now saved.");
		debug(msg);
		
	}
	
	public void function updateProductTypeShouldReturnString() {
		thisProductType = productTypeService.load(1);
		form.productTypeName = "Standoff";
		form.productTypeParam = "standoff";
		
		var msg = productTypeService._save(thisProductType);
		assertEquals(msg, "The Product Type '#form.productTypeName#' is now saved.");
		debug(msg);
		
	}
	public void function deleteProductTypeShouldReturnString() {
		thisProductType = productTypeService.load(3);
		
		var msg = productTypeService._delete(thisProductType);
		assertEquals(msg, "The Product Type '#form.productTypeName#' is now deleted.");
		debug(msg);
		
	}*/
	
	private void function createListForDAO() {
		// create 1st mock FHCalendarEvent entity
		productType = mockBox.createMock("ProductModule.adminconfig.model.ent.ProductType");
		productType.setProductTypeID(1);
		productType.setProductTypeName("Test Product Type");
		productType.setProductTypeParam("test-product-type1");
		
		// create 2nd mock FHCalendarEvent entity
		productType2 = mockBox.createMock("ProductModule.adminconfig.model.ent.ProductType");
		productType2.setProductTypeID(2);
		productType2 = mockBox.createMock("ProductModule.adminconfig.model.ent.ProductType");
		productType2.setProductTypeName("Test Product Type 2");
		productType2.setProductTypeParam("test-product-type2");
		
		// mock data for dao list()
		productTypes = [productType, productType2];
	}
	
	
}