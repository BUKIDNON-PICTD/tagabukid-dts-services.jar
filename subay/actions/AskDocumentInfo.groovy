package subay.actions;

import com.rameses.rules.common.*;
import subay.facts.*;

public class AskDocumentInfo extends AbstractDocumentInfoAction implements RuleActionHandler {

	def request;

	public void execute(def params, def drools) {
	
		def documenttype = params.documenttype;
		def attrid = params.attribute.key;
		def defvalue = params.defaultvalue;
		def entity = request.entity;
		def newinfos = request.newinfos;
		def info = getInfo( entity, newinfos, documenttype, attrid, null, request.phase );
		if(info) info.defaultvalue = defvalue;
	}

}

