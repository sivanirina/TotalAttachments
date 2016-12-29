public class AttachmentsSummary {
    private List<Opportunity> parentsAttachments = new List<Opportunity>();

    public void Recalculate() {
		    //to get Opportunities and count of their attachments
	      for(Opportunity opp: [Select Id, Total_Attachments__c, (Select Id From Attachments) FROM Opportunity]) {
	          if(opp.Total_Attachments__c != opp.Attachments.size()) {
	        	    opp.Total_Attachments__c = opp.Attachments.size();
	        	    parentsAttachments.add(opp);
	        	}
    		}
       	//commit opp-ties changes
    		update parentsAttachments;
    }

    public void Recalculate(List<Attachment> triggerList) {
        //get parentId of inserted attachments
		    Map<ID,Integer> parentsId = new Map<ID,Integer>();
	      for(Attachment att : triggerList) {
				    if(!parentsId.containsKey(att.ParentId)) {
					      parentsId.put(att.ParentId, 1);
				    } else {
					      parentsId.put(att.ParentId, parentsId.get(att.ParentId)+1);
				    }
	      }
	      //to get Opportunities and count of their attachments
			  for(Opportunity parent: [SELECT Id, Total_Attachments__c, (select Id from Attachments)
	    		                       FROM Opportunity
																 WHERE Id IN :parentsId.keySet()]) {
	          parent.Total_Attachments__c = (Trigger.isBefore && Trigger.isDelete)
																	      ? parent.Attachments.size() - parentsId.get(parent.Id)
																				: parent.Attachments.size();
	          parentsAttachments.add(parent);
	      }
	      //commit opp-ties changes
	      update parentsAttachments;
    }
}
