component 
{
	public ProductValidator function init() {
		WriteDump($);
		return this;
	}
	public boolean function validateForIllegalChars(fieldvalue) {
		var valid = true;
		
		if(isSimpleValue(fieldvalue)) {
			// if the argument is false we don't want to strip whitespace, else strip it
			
			if(len(trim(fieldvalue))){
				var found = false;
				var pattern = "[\@\(\)\<\>\;\:\\\[\]\~\!\$\%\^\*\+\=\{\}\|]";
				var x = ReFind(pattern, fieldvalue);
				//WriteDump(x);
				if (x > 0) {found = true;}
				valid = !found;
			}
		}
		
		return valid;
	}
	public boolean function testValid(firstname) {
		WriteDump(arguments);
		return false;
	}
	
	public any function IsCustomerFieldRequired(fieldname, siteID=session.siteID) {
		//WriteDump(var=arguments, label="args");
		var required = false;
		var filename = form.formSettingsFile;
		var content = getBean('content').loadBy(filename=filename, siteId=arguments.siteID);
		var requiredFields = ListToArray(content.getRequiredFields());
		WriteDump(var=requiredFields, label="requiredFields");
		
		
		for(n in requiredFields) {
			//WriteOutput("fieldname? " & arguments.fieldname & "; ");
			//WriteOutput("fieldname? " & n & "; ");
			//WriteOutput("is required? " & (arguments.fieldname eq n) & "<br>");
			if(arguments.fieldname eq n) {
				required = true;
				break;
			}
		}
		return required;
	}
	
	public boolean function FutureDate(dateval) {
		var isvalid = false;
		if(IsDate(dateval)) {
			isvalid = DateDiff('d', now(), dateval) > 0;			
		}
		
		return isvalid;
	}

	public boolean function isStartBeforeEndDate(fieldvalue, rc=request) {
		if(IsDefined("request.EventStartDateTime") && IsDefined("request.EventEndDateTime")) {
			return DateDiff("n", rc.EventStartDateTime, rc.EventEndDateTime) > 0;
		}
		return true;
	}
	public boolean function isRegDeadlineBeforeStart(fieldvalue, rc=request) {
		if(IsDefined("request.RegistrationEndDateTime") && IsDefined("request.EventStartDateTime")) {
			return DateDiff("n", rc.RegistrationEndDateTime, rc.EventStartDateTime) > 0;
		}
		return true;
	}
	
	public boolean function isRepeatInterval(repeatVal, dateVal) {
		return repeatVal == "interval" && Len(dateVal) == 0;
	}
	
	public boolean function isThisAnArray(fieldval) {
		WriteDump(fieldval);
		WriteDump(IsArray(fieldval));
		WriteDump(!ArrayIsEmpty(fieldval));
		//abort;
		return IsArray(fieldval) && !ArrayIsEmpty(fieldval);
	}
}