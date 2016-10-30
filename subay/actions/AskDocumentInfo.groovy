package subay.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import subay.facts.*;
import com.rameses.osiris3.common.*;
import java.rmi.server.*;

public class AskDocumentInfo implements RuleActionHandler {
	def request;
	def DV;
	String infotype;
	public void execute(def params, def drools) {
		def sdt = params.sdt;
		def attrid = params.attribute.key;
		def defvalue = params.defaultvalue;
		def entity = request.entity;
		def newinfos = request.newinfos;

		def info = getInfo( entity, newinfos, sdt, attrid, null, request.phase );
		if(info) info.defaultvalue = defvalue;
	}

	def getInfo( def entity, def newinfos, def sdt, def attrid, def val, def phase ) {
		//check first if info already exists. test is a list
		def test = null;
		if( !sdt ) {
			test = entity.infos.findAll{ it.sdt?.objid == null && it.attribute.objid == attrid };
			if(!test) {
				test = newinfos.findAll{it.sdt?.objid==null && it.attribute.objid == attrid };
			}	
		}
		else {
			test = entity.infos.findAll{ it.sdt?.objid!=null && it.sdt.objid == sdt.objid && it.attribute.objid == attrid };
			if(!test) {
				test =  newinfos.findAll{ it.sdt?.objid!=null && it.sdt.objid == sdt.objid && it.attribute.objid == attrid };
			}
		}

		if(test) return null;
			
		def info = [objid:"DOCINFO"+new UID()];
		info.phase = phase;
		info.infotype = infotype;
		info.attribute = DV.read( [objid: attrid ] );
		//remove desc, state and system.
		info.attribute.remove("description");
		info.attribute.remove("state");
		info.attribute.remove("system");

		if(sdt) {
			info.sdt = [objid:sdt.objid, name:sdt.name];
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

