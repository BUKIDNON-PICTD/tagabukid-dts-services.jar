package subay.facts;

import java.util.*;

public class UserOrganizationUnit {
	
	String objid
	String userorgunitid
	String name
	String code

	public OrganizationUnit(){

	}

	public OrganizationUnit(def o) {
        this.objid = o.org.objid;
        this.userorgunitid = o.objid;
        this.name = o.org.name;
        this.code = o.org.code;
    }
}