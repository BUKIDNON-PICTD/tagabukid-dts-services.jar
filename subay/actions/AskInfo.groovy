package subay.actions;

import com.rameses.rules.common.*;
import com.rameses.util.*;
import java.util.*;
import subay.facts.*;
import com.rameses.osiris3.common.*;

class AskInfo implements RuleActionHandler {

	public void execute(def params, def drools) {
		def info = params.info;
		println info
		def ct = RuleExecutionContext.getCurrentContext();

		if( !ct.result.containsKey("infos") ) {
			ct.result.put("infos", [] );		
		}

		//retrieve the datatype
		def em = EntityManagerUtil.lookup( "subaydocumentvariable" );
		def z = em.find( [objid: info.key] ).first();
		z.name = z.objid;
		z.type = z.datatype;
		ct.result.infos << z;
	}
}