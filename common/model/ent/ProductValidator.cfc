﻿component 
{
	public ProductValidator function init() {
		WriteDump($);
		return this;
	}
	public boolean function validateForIllegalChars() {
		var valid = true;
		WriteDump(var=arguments,label="validateillegalChars");
		abort;

		if(isSimpleValue(fieldvalue)) {
			// if the argument is false we don't want to strip whitespace, else strip it
			
			if(len(trim(fieldvalue))){
				var found = false;
				var pattern = "[\@\(\)\<\>\;\:\\\[\]\~\!\$\%\^\&\*\+\=\{\}\|]";
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
		WriteOutput("isvalid: #isvalid#");
		
		return isvalid;
	}
}