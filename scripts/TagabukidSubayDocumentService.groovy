import com.rameses.annotations.*;
import com.rameses.util.*;
import java.rmi.server.*;
import com.rameses.services.extended.*;

public class TagabukidSubayDocumentService  {

	@ActiveDB(value='dts', em='tagabukid_etracs')
	def em

	@ActiveDB(value='document_task', em='tagabukid_etracs')
	def taskem

	//initialize new document
	@ProxyMethod
	public def initNew(o) {
		def entity= [:]
		entity.objid ="DTS"+ new UID();
		entity.dininventoryid = null;
		entity.documenttype = [:]
		entity.recordlog = [:]
		entity.state = 'IDLE'
		entity.docstate = 'IDLE'
		entity.child = []
		entity.docinfo = [:]
		entity.recordlog.datecreated = dtSvc.serverDate
		entity.recordlog.createdbyuserid = env.USERID
		entity.recordlog.createdbyuser = env.FULLNAME
		entity.recordlog.dateoflastupdate =  dtSvc.serverDate
		entity.recordlog.lastupdatedbyuserid = env.USERID
		entity.recordlog.lastupdatedbyuser = env.FULLNAME
		return entity
	}

	//create new document
	@ProxyMethod
    public def create(def o){
		if(!o.docstate) o.docstate = 'IDLE';

		// if(!o.din) {o.din = createdin(o)}
		// o.documenttypeid =  o.documenttype.objid
		o.org = getUserOrg(env.USERID)
		em.create(o);
		createinittask(o);


		if(o.documenttype.haschild){
			o.child.each{
				
				def taskid = createchildtask(o,it)
				def doclink = [
					objid:o.objid,
					documentchildid :it.objid,
					taskid: taskid
				]
				em.create(doclink, 'documentlink')
				// em.updateparent([parentid:o.objid,objid:it.objid])
				// if(it.linked){
				// 	taskem.attachChildTask([parentprocessid:task.objid,enddate:dtSvc.serverDate,refid:it.objid,state:'processing',message:'Linked to document no. ' + o.din]);
				// }else{
				// 	taskem.attachChildTask([parentprocessid:task.objid,enddate:dtSvc.serverDate,refid:it.objid,state:'attached',message:'Attached to document no. ' + o.din]);
				// }
				
			}
		}

		return o;
    }

    public def createinittask(o){
		def inittask = [
			objid          : 'TSK' + new java.rmi.server.UID(),
			refid          : o.objid,
			parentprocessid: null,
			lft			   : 1,
			rgt			   : 2,
			state          : 'idle',
			startdate      : dtSvc.serverDate,
			assignee_objid : env.USERID,
			assignee_name  : env.FULLNAME,
			assignee_title : env.JOBTITLE,
			actor_objid    : env.USERID,
			actor_name     : env.FULLNAME,
			actor_title    : env.JOBTITLE,
			message        : 'DOCUMENT WITH DIN ' + o.din + ' WAS INITIALIZED BY ' + env.FULLNAME,
		]

		def newtaskorg = [
			taskid:inittask.objid,
			org:o.org,
			macaddress:env.MACADDRESS,
		]

		taskem.save(inittask)
		taskem.save(newtaskorg,'document_task_org')

		return inittask
	}

	@ProxyMethod
	public def verifydin(din) {
		try{
			def prefix = (din.substring(0,5)=="71007" ? din.substring(6,15) : din.substring(0,9)) 
			def sequence = (din.substring(0,5)=="71007" ? din.substring(15) : din.substring(9)) 

			din = prefix + sequence

			def filter = ''' d.din = $P{barcodeid} ''';
			def doc = em.findDocumentbyBarcode([barcodeid:din,filter:filter])
			if (doc){
				throw new Exception("DIN :" + din + " is already referenced to a document");
			}
			
			def inv = em.findDocumentInv([prefix:prefix,sequence:sequence,orgid:getUserOrg(env.USERID).organizationid])
			if(!inv){
				throw new Exception("Invalid DIN");
			}


			return [din:din,inv:inv]
		}catch(e){
			throw new Exception("Invalid DIN");
		}
	}

	public def createchildlog(doc,o){
    		if (o.state != 'attached'){
    			closechildtask(o);
    		}
    		addChild(o)
			o.newlft = o.lft + 1
			o.newrgt = o.lft + 2
			if (o.linked){
				o.state = 'linked'
				o.startdate = dtSvc.serverDate
				o.enddate = null
				o.message = 'Linked to document no. ' + doc.din
			}else{
				o.state = 'attached'
				o.startdate = dtSvc.serverDate
				o.enddate = dtSvc.serverDate
				o.message = 'Attached to document no. ' + doc.din
			}

			def newtask = [
				objid          : 'TSK' + new java.rmi.server.UID(),
				refid          : o.refid,
				parentprocessid: null,
				lft			   : o.newlft,
				rgt			   : o.newrgt,
				state          : o.state,
				startdate      : o.startdate,
				enddate		   : o.enddate,
				assignee_objid : env.USERID,
				assignee_name  : env.FULLNAME,
				assignee_title : env.JOBTITLE,
				actor_objid    : env.USERID,
				actor_name     : env.FULLNAME,
				actor_title    : env.JOBTITLE,
				message        : o.message,
			]

			def newtaskorg = [
				taskid    :newtask.objid,
				org       :doc.org,
				macaddress:env.MACADDRESS,
			]

	    	taskem.save(newtask)
	    	taskem.save(newtaskorg,'document_task_org')
	    	return newtask.objid
    }

    void addChild(o){
    	taskem.changeRight([myleft:o.lft,refid:o.objid])
		taskem.changeLeft([myleft:o.lft,refid:o.objid])
    }

    void closechildtask(o){
    	def filter = ''' AND dto.orgid = $P{userorgid} AND dt.objid = $P{taskid} '''
    	taskem.closePrevTask([enddate:dtSvc.serverDate,refid:o.refid,filter:filter,userorgid:getUserOrg(env.USERID).organizationid,taskid:o.taskid]);
    }
}
