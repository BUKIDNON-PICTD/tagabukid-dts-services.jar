package subay.facts;

import java.util.*;

public class DocumentType {
	
	String objid
	String doctypeid
	String name
	String code
	String description
	boolean haschild

	public DocumentType(){

	}

	public DocumentType(def o) {
        this.objid = o.objid;
        this.doctypeid = o.objid;
        println this.objid;
    }
}