package subay.actions;

import com.rameses.rules.common.*;
import subay.facts.*;

public class AssertDocumentInfo extends AbstractDocumentInfoAction implements RuleActionHandler {

	def request;
	def comparator;

	public void execute(def params, def drools) {
		def documenttype = params.documenttype;
		def attrid = params.attribute.key;
		def val = params.value;
		def facts = request.facts;

		//check if fact already exists
		def info = getInfo( request.entity, request.newinfos, documenttype, attrid, val, request.phase );
		if(info!=null) {
			def dtype = info.attribute.datatype;
			def f = new DocumentInfo(dtype, info.value);
			f.objid = info.objid;
			f.name = info.attribute.name;
			f.documenttype = documenttype;
			facts << f;
		}
	}
}

