package subay.actions;

import java.rmi.server.*;

public abstract class AbstractDocumentInfoAction {
	
	def DV;
	String infotype;

	def getInfo( def entity, def newinfos, def documenttype, def attrid, def val, def phase ) {
		//check first if info already exists. test is a list
		def test = null;
		if( !documenttype ) {
			test = entity.infos.findAll{ it.documenttype?.objid == null && it.attribute.objid == attrid };
			if(!test) {
				test = newinfos.findAll{it.documenttype?.objid==null && it.attribute.objid == attrid };
			}	
		}
		else {
			test = entity.infos.findAll{ it.documenttype?.objid!=null && it.documenttype.objid == documenttype.objid && it.attribute.objid == attrid };
			if(!test) {
				test =  newinfos.findAll{ it.documenttype?.objid!=null && it.documenttype.objid == documenttype.objid && it.attribute.objid == attrid };
			}
		}

		if(test) return null;
			
		def info = [objid:"DDINFO"+new UID()];
		info.phase = phase;
		info.infotype = infotype;
		info.attribute = DV.read( [objid: attrid ] );
		//remove desc, state and system.
		info.attribute.remove("description");
		info.attribute.remove("state");
		info.attribute.remove("system");
		
		if(documenttype) {
			info.documenttype = [objid:documenttype.objid, name:documenttype.name];
		}

		info.datatype = info.attribute.datatype;
		
		if(val) {
			String datatype = info.attribute.datatype;
			switch(datatype) {
				case "integer":
					info.value = val.intValue;
					break;
				case "decimal":
					info.value = val.doubleValue;
					break;
				case "string":	
					info.value = val.stringValue;
					break;
				case "boolean":	
					info.value = val.booleanValue;
					break;
			}
		}			
		newinfos << info;
		return info;
	}




}