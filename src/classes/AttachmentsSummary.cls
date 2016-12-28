public class AttachmentsSummary {
	private List<Opportunity> parentsAttachments;

	public void Recalculate() {
		//to get Opportunities and count of their attachments
	  parentsAttachments = new List<Opportunity>();
		try{
	    	for(Opportunity opp: [Select Id, Total_Attachments__c, (Select Id From Attachments) FROM Opportunity]) {
	        	if(opp.Total_Attachments__c != opp.Attachments.size()) {
	        		opp.Total_Attachments__c = opp.Attachments.size();
	        		parentsAttachments.add(opp);
	        	}
    		}
       		//commit opp-ties changes
    		update parentsAttachments;
    	} catch (QueryException qe) {
        	System.debug('Have none opportunity attachments.' + qe.getMessage());
    	} catch (DmlException de) {
        	System.debug('Can\'t update opportunity Total Attachments field.' + de.getMessage());
    	}
	}

	public void Recalculate(List<Attachment> triggerList) {
		Recalculate(triggerList, true);
	}

    public void Recalculate(List<Attachment> triggerList, Boolean isNew) {
    	// to get parentId inserted attachments
		Set<ID> parentsId = new Set<ID>();
	    for(Attachment att : triggerList) {
	        parentsId.add(att.ParentId);
	    }
	    //to get Opportunities and count of their attachments
	    parentsAttachments = new List<Opportunity>();
	    try {
	    	  for(Opportunity parent: [SELECT Id, Total_Attachments__c, (select Id from Attachments)
	    		                         FROM Opportunity WHERE Id IN :parentsId]) {
	        		parent.Total_Attachments__c = parent.Attachments.size();
	       			parentsAttachments.add(parent);
	        }
	        if(isNew==false && parentsAttachments.size()>0){
	    	      Subtract(triggerList);
	        }
	    	  //commit opp-ties changes
	    	  update parentsAttachments;
	    } catch (QueryException qe) {
	        System.debug('Have none opportunity attachments.' + qe.getMessage());
	    } catch (DmlException de) {
	        System.debug('Can\'t update opportunity AttCount__c field.' + de.getMessage());
	    }
	}

	private void Subtract(List<Attachment> OldList) {
    		// Calculate how many files were deleted
    		for(Opportunity o : parentsAttachments) {
    			for(Attachment a : OldList) {
    				if(o.Id == a.ParentId) {
    					o.Total_Attachments__c--;
    				}
    			}
    		}
	}
}