component accessors="true" {

	property transactionDAO;
	property customerDAO;
	property paymentDAO;
	property productSelectedDAO;
	
	public ProductTransactionManager function init() {
		return this;
	}
	
	public void function load() {
		//WriteDump(form.productClassParam);
		setTransactionDAO( new pmdao.ProductTransactionDAO()) ;		
		setCustomerDAO(new pmdao.CustomerDAO());		
		setPaymentDAO( getPaymentMethodObj(form.paymentMethod) );
		if (IsDefined("form.productClassParam")) 
			setProductSelectedDAO( evaluate( "new pmdao.#form.productClassParam#SelectedDAO()") );
	}

	private function getPaymentMethodObj(obname) {
		if (obname == "Credit Card") {
			return new pmdao.CreditCardPaymentDAO();
		}
		else {
			return new pmdao.PaymentDAO();
		}
	}

	public void function beginTransaction(rf, pt) {
		//ormreload();
		var request.status = {};
		var issaved = false;
		
		var requiredfields = arguments.rf;
		var paymentTypes = arguments.pt;
		
		var tr = newTransaction();		
		var cust = newCustomer();
		var payment = newPayment();
		var prodselected = newProductSelected();
		
		tr = populateTransaction(tr, cust, payment, prodselected);
		
		//WriteDump(var=tr, label="tr");
		
		var validationErrors = validateTransaction(tr, tr.getCustomer(), tr.getPayment(), tr.getProductSelected());
		
		if (!ArrayIsEmpty(validationErrors)) {
			request.status.message = "The form could not be completed:";
			request.status.messagetype = "validationerror";
			request.status.messagestyle = "alert-danger";
			request.status.errors = validationErrors;			
		}
		else {
			if (tr.hasPayment() && payment.getPaymentTypeName() == "Credit Card") {
				var theKey =generateSecretKey("AES");
				var encrypted = payment.encryptCreditCard( payment.getCreditCardNum(), theKey );
				payment.setCreditCardNum(encrypted);
				payment.setCryptKey(theKey);
			}
			
			// save
			txn = ORMGetSession("devcpctproducts").beginTransaction();
			try {
				saveTransaction(tr, cust, payment, prodselected);
				//TransactionCommit();
				txn.commit();
				issaved = true;
			}
			catch(any e) {
				TransactionRollback();
				throw e;
			}
			//if (issaved) {
			if (txn.wasCommitted()) {
				request.status.messagetype = "success";
				request.status.messagestyle = "alert-success";
			}
			var email = new pmservices.ProductTransactionEmail(
				tr = tr, 
				formsettings = form.formSettingsFile,
				productURLParam = tr.getProductSelected().getProductURLParam(),
				productClassParam = tr.getProductSelected().getProductClassParam(),
				customerEmail = tr.getCustomer().getEmail()
			);
			if (request.status.messagetype eq "success" && cgi.SERVER_PORT != "8877") {
				email.sendToCustomer();
				email.sendToVenue();
			}
		}
		request.tr = tr;
	}

	public any function populateTransaction(tr, cust, payment, prodselected) {	
		var popCust = populateCustomer(cust);
		popCust.setProductTransaction(tr);
		tr.setCustomer(popCust);
				
		var popPayment = populatePayment(payment);
		popPayment.setProductTransaction(tr);
		tr.setPayment(popPayment);
		
		var popProductSelected = getProductSelectedDAO().populate(prodselected);
		popProductSelected.setProductTransaction(tr);
		tr.setProductSelected(popProductSelected);
		
		return getTransactionDAO().populate(tr, popCust, popPayment, popProductSelected);
	}

	public any function validateTransaction(tr, cust, payment, prodselected) {
		var hyrule =  new hyrule.system.core.hyrule();
		var result = hyrule.validate(tr);
		var resultcust = hyrule.validate(cust);
		var resultpayment = hyrule.validate(payment);
		var resultprodselected = hyrule.validate(prodselected);
		
		var resultall = result.getErrorMessages();
		
		
		if (!ArrayIsEmpty(resultcust.getErrorMessages())) {
			for (e in resultcust.getErrorMessages()) {
				ArrayAppend(resultall, e);
			}
		}
		
		if (IsDefined("arguments.payment") && !ArrayIsEmpty(resultpayment.getErrorMessages())) {
			for (e in resultpayment.getErrorMessages()) {
				ArrayAppend(resultall, e);
			}
		}
		
		if (IsDefined("arguments.prodselected") && !ArrayIsEmpty(resultprodselected.getErrorMessages())) {
			for (e in resultprodselected.getErrorMessages()) {
				ArrayAppend(resultall, e);
			}
		}
		
		return resultall;
	}

	public void function saveTransaction(tr, cust, payment, prodselected) {		
		getCustomerDAO().save(cust);
		getPaymentDAO().save(payment);			
		getProductSelectedDAO().save(prodselected);			
		getTransactionDAO().save(tr);
	}
	
	public any function newTransaction() {
		return getTransactionDAO().new();
	}
	public any function newCustomer() {																																																										
		return getCustomerDAO().new();
	}
	public any function newPayment() {
		//WriteDump(getPaymentDAO());
		//abort;
		return getPaymentDAO().new();
	}
	public any function newProductSelected() {
		return getProductSelectedDAO().new();
	}
	
	public any function getRequiredFields(filename, siteID=session.siteID) {
		var formSettings = getBean('content').loadBy(filename=arguments.filename, siteId=arguments.siteID);
		var requiredFields = ListToArray(formSettings.getRequiredFields());
		return requiredFields;
	}
	public any function getPaymentTypes(filename, siteID=session.siteID) {
		var formSettings = getBean('content').loadBy(filename=arguments.filename, siteId=arguments.siteID);
		var paymentTypes = ListToArray(formSettings.getPaymentTypes());
		return paymentTypes;
	}
	
	public any function populateCustomer(cust) {
		return getCustomerDAO().populate(cust);
	}
	
	public any function populatePayment(paymenttype) {
		return getPaymentDAO().populate(paymenttype);
	}
	
	public any function populateProductSelected(prod) {
		return getProductSelectedDAO().populate(prod);
	}
	
	
	
	// use queries for reporting - easy convert to excel
	public any function loadPendingTransactions(product) {
		result = ORMExecuteQuery("
			SELECT tr from ProductTransaction tr 
			JOIN tr.ProductSelected ps
			WHERE tr.transactionStatus = 'pending'
			AND ps.productName = '#product#' 
		");
		return result;
	}
	public any function loadProductTypes() {
		var result = "";
		result = ORMExecuteQuery("SELECT DISTINCT ps.productTypeName from ProductTransaction tr JOIN tr.ProductSelected ps");
		return result;
	}
	public any function loadProducts(producttype) {
		var result = "";
		result = ORMExecuteQuery("SELECT DISTINCT ps.productName from ProductTransaction tr JOIN tr.ProductSelected ps 	WHERE ps.productTypeName='#arguments.producttype#'");
		return result;
	}
	
	public any function getMostRecentEventDate(eventname) {
		result = ORMExecuteQuery("
			SELECT MAX(ps.eventDate) from ProductTransaction tr 
			JOIN tr.ProductSelected ps 
			WHERE ps.productName = '#eventname#'");		
	}
	
}