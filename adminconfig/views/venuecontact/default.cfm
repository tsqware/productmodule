<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfdump var="#rc.products#" />
<cfoutput>
	<h1>Product Config Dashboard</h1>
	
	<cfif IsDefined("rc.memHeader")>
	<h2>#rc.memHeader#</h2>
	
	</cfif>
	
	<cfif IsDefined("rc.socHeader")>
	<h2>#rc.socHeader#</h2>
	</cfif>
	
</cfoutput>