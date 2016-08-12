component extends="Payment" persistent="true" table="tr_paymenttypes_creditcard" joincolumn="paymentTypeID" discriminatorvalue="Credit Card"  datasource="devcpctproducts"
{
	/**
	 * @required true
	 * @InList "MasterCard,American Express,Discover,Visa,JCB"
	 **/
	property name="creditCardType" type="string" ;
	
	/**
	 * @displayname Credit Card Number
	 * @required true
	 * @method isCreditCardValid
	 **/
	property name="creditCardNum" type="string";
	
	/**
	 * @displayname Credit Card Expiration Date
	 * @required true
	 * @method isFutureDate
	 **/
	property name="creditCardExp" type="date";
	
	/**
	 * @required true
	 * @size "5..100"
	 **/
	property name="creditCardHolder" type="string";  
  	property name="cryptKey" type="string" ;
  	
  	/*this.constraints1 = super.getConstraints();
  	
  	this.constraints = {
  		creditCardType = { required=true, InList="MasterCard,American Express,Discover,Visa,JCB" },
  		creditCardNum = { required=true, method=isCreditCardValid() }, // validator for isCreditCardValid
  		creditCardExp = { required=true, method=isFutureDate() },
  		creditCardHolder = { required=true, size="5..100" }
  	};*/
  	
  	boolean function isCreditCardValid() {
  		var valid = true;
  		var ccnum = getCreditCardNum();
  		if (!IsDefined("ccnum")) return true;
  		var cctype = getCreditCardType();
  		var firstDigit = Left(ccnum, 1);
  		
  		
  		switch (cctype) {
			case "MasterCard":
				if (Len(ccnum) neq 16 or firstDigit neq "5") {
					valid = false;
				}
				break;			
			case "American Express":
				if (Len(ccnum) neq 15 or firstDigit neq "3") {
					error="Please enter correct credit card number, no spaces or dashes.";
					valid = false;
				}
				break;
				
			case "Discover":
				if (Len(ccnum) neq 16 or firstDigit neq "6") {
					
					valid = false;
				}
				break;
			case "Visa":
				if (Len(ccnum) neq 16 or firstDigit neq "4") {
					valid = false;
				}
				break;
			default:
				if (Len(ccnum) neq 16) {
					valid = false;
				}
		}
  		return valid;
  	}
  	boolean function isFutureDate() {
  		if (IsNull(this.getCreditCardExp())) return true;
  		return DateDiff('d', now(), this.getCreditCardExp()) > 0;
  	}
  	boolean function isPastDate() {
  		if (IsNull(this.getCreditCardExp())) return true;
  		return DateDiff('d', now(), this.getCreditCardExp()) < 0;
  	}
  	
  	public function encryptCreditCard(ccnum, theKey) {		
		var encrypted = encrypt(ccnum, theKey, "AES", "Base64");
		return encrypted;
	}
	
	public function decryptCreditCard(ccnum, theKey) {
		var decrypted = decrypt(ccnum, theKey,  "AES", "Base64");
		return decrypted;
	}
	public function chopDecrypted(ccnum) {
		var chopdecrypted = Right(ccnum,4);
		return chopdecrypted;
	}
}
