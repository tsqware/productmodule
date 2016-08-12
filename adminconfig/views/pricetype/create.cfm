<cfoutput>

<!-- venue nav -->
<nav class="navbar navbar-default">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="##navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#buildURL('adminconfig:main')#">Product Module</a>
    </div>
    <div id="navbar" class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
        <li class="active"><a href="##">#rc.title#</a></li>
      </ul>
    </div><!--/.nav-collapse -->
  </div>
</nav>
<!-- end venue nav -->

<h1>#rc.title#</h1>

<cfif StructKeyExists(rc, "message")>
	<div>
		<h3>#rc.message#</h3>
		<cfif StructKeyExists(rc, "valerrors") and not ArrayIsEmpty(rc.valerrors)>
			<ul>
				<cfloop array="#rc.valerrors#" index="er">
					<li>#er.getMessage()#</li>
				</cfloop>
			</ul>
		</cfif>
	</div>
</cfif>

<form action="#buildURL(action='adminconfig:pricetype.doCreate')#" method="post">
	<div class="row">
		<div class="col-xs-6">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<div style="padding-bottom:20px;">
							<label>Price Type Name</label>
							<input class="form-control" type="text" name="priceTypeName" placeholder="Name of Price" maxlength="100" value="#rc.priceTypeName#" >
						</div>
						<div style="padding-bottom:20px;">
							<label>Price Type Param</label>
							<input class="form-control" type="text" name="priceTypeParam" maxlength="100" value="#rc.priceTypeParam#" placeholder="Machine Name, dashes allowed, no spaces">
						</div>
						<div style="padding-bottom:20px;">
							<label>Price Type Class Name</label>
							<input class="form-control" type="text" name="priceTypeClassName" maxlength="50" value="#rc.priceTypeClassName#" placeholder="Class Name, used for programming">
						</div>		
					</fieldset>
				</div>
			</div>
			<div class="row" style="text-align:center;">	
				<button type="submit" class="btn">Save</button>
			</div>
		</div>
	</div>
</form>
</cfoutput>