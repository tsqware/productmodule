component 
{
	public Security function init() {
		return this;
	}
	
	public boolean function isMemberOfGroup(required string groupname) {
		
		var $ = application.serviceFactory.getBean('$').init( session.siteid );
		
		var isAdmin = false;
		var admGroups = ArrayNew(1);
		
		var currentUserMemberships = $.currentUser().getMembershipsIterator();
		//WriteDump(session);
		//WriteDump(currentUserMemberships.getArray());
		currentUserMemberships.setNextN(0);
		
		While(currentUserMemberships.hasNext()) {
			var item = currentUserMemberships.next();
			//WriteDump(item);
			if (item.getGroupName() == "Admin" || item.getGroupName() == arguments.groupname) {
				isAdmin = true;
				break;
			}
		};
		//abort;
		return isAdmin;
	}

}