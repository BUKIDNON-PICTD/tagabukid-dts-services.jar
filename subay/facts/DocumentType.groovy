package subay.facts;

public class DocumentType {
    
    Document document;
    String objid
    String doctypeid
    String name
    String code
    String description
    boolean haschild

    // HouseholdSurvey householdsurvey;
    // String objid; 
    // String hhmid;
    // String name;
    // String relation;			
    			
    // String name;
    // String relation;
    // String classification;
    // String attributes;
    // String assessmenttype;
    
    /** Creates a new instance of HHM */
    public DocumentType() {
    }

    public DocumentType(def o) {
        this.objid = o.objid;
        this.doctypeid = o.objid;
        this.name = o.name;
        this.code = o.code;
        this.description = o.description;
        this.haschild = o.haschild;
        // this.assessmenttype = o.assessmenttype;  
    }

    public void printInfo() {
        /*print lob*/
        println "Document Type Fact"
        println "objid " + this.objid;
        // println "assessment type " + this.assessmenttype;  
    }

}
