<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
    	<meta name="description" content="">
    	<meta name="author" content="">
    	<link rel="icon" href="../../favicon.ico">
    	
		<!--- title set by a view - there is no default --->
		<title>Form - <cfoutput>#rc.title#</cfoutput></title>
		
		<!-- Bootstrap core CSS -->
	    <link href="/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	
		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    	<!--[if lt IE 9]>
     	 <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
     	 <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    	<![endif]-->
    	
    	<!-- include styles for jquery and fullcalendar -->
		<link rel="stylesheet" type="text/css" href="/css/jquery-ui-1.10.4.min.css" />
		<link rel="stylesheet" type="text/css" href="/css/jquery.timepicker.css" />
		<cfif StructKeyExists(rc, "showCalendar")>
			<link href='/jslib/fullcalendar.css' rel='stylesheet' />
			<link href='/jslib/fullcalendar.print.css' rel='stylesheet' media='print' />
		</cfif>
		<link href='/jslib/jquery.qtip.min.css' rel='stylesheet' />

		
		<!-- ********* add javascript ******** -->
		<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
		<script src='/jslib/moment.min.js'></script>
		<script src="/jslib/jquery.min.js"> </script>
		<script src="/jslib/jquery-ui-1.10.4.min.js"> </script>
		<script src="/jslib/jquery.timepicker.min.js"> </script>
		<cfif StructKeyExists(rc, "showCalendar")>
			<!-- modified fullcalendar.js to display custom data -->
			<script src='/jslib/fullcalendar.mod2.js'></script>
		</cfif>
		<script src='/jslib/jquery.qtip.min.js'></script>
	
		<!-- Include all compiled plugins (below), or include individual files as needed -->
		<script src="/bootstrap/js/bootstrap.min.js"></script>
		<!-- ********* end add javascript ******** -->
		
		<style type="text/css">
			body {
			  padding-top: 50px;
			}
			.starter-template {
			  text-align: left;
			}
			h1 {
				margin-top:0px;	
			}
			.nav-stacked li {
				border-bottom: 1px dotted #999;
			}
			.nav-stacked li:last-child {
				border-bottom:0px;
			}
			.venueHeader {
				background: #333333;min-height:120px; padding:20px; margin-bottom:30px;
			}
			.venueHeader h1, .venueHeader h2, .venueHeader p {
				color: #FFFFFF;
			}
			.venueHeader h1 {
				font-size: 54px;
				color: #d4d4d4;
			}
		</style>
	</head>
	<body>
	<cfoutput>
		<!-- top nav - corp nav -->
		<nav class="navbar navbar-inverse navbar-fixed-top">
    		<div class="container">
        		<div class="navbar-header">
          			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##navbar" aria-expanded="false" aria-controls="navbar">
            			<span class="sr-only">Toggle navigation</span>
    	        		<span class="icon-bar"></span>
	            		<span class="icon-bar"></span>
  		          		<span class="icon-bar"></span>
  	        		</button>
        	  		<a class="navbar-brand" href="##">Project name</a>
  		      	</div>
        		<div id="navbar" class="collapse navbar-collapse">
          			<ul class="nav navbar-nav">
            			<li class="active"><a href="##">Home</a></li>
     		   	 	   	<li><a href="##about">About</a></li>
         			   	<li><a href="##contact">Contact</a></li>
          			</ul>
    	    	</div><!--/.nav-collapse -->
   		   	</div>
    	</nav>
    	<!-- venue header -->
		<div class="venueHeader" style="">	
			<div class="container">
				<h1 style="">Chelsea Piers Connecticut</h1>
				<h2 style="margin:0px;padding:0px;">Public Site</h2>	
			</div>
		</div>
		<!-- end venue header -->
		
		<!-- venue body -->
	    <div class="container">
			<!-- main content -->
			<cfoutput>#body#</cfoutput>	<!--- body is result of views --->		
   		   	<!-- end main content -->

    	</div>
		<!-- end venue body -->
		<!-- /.container -->
		
		</cfoutput>
	</body>
</html>