<cfscript>
	testSuite = CreateObject("component","mxunit.framework.TestSuite").TestSuite();
	WriteDump(testSuite);
</cfscript>