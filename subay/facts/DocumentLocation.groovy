package subay.facts;

public class DocumentLocation {
	
	String type;
	String orgid;

	public DocumentLocation() {
	}

	public DocumentLocation(a) {
		this.type = a.type;
		if(a.type == 'local') type = 'owned';
		if(a.organization) {
			orgid = a.organization.objid	
		}
	}

}