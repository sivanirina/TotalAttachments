@isTest (seeAllData=false)
public class OpportunitiesData {    
	static Opportunity newOpportunity(String name) {    	
    	// Create an opportunity
        Opportunity opp = new Opportunity(
        	Name 	  = name,
        	CloseDate = Date.today() + 30,
        	StageName = 'Prospecting');
        
        return opp; 
    }

	public static Attachment newAttachment(String name, String newBody, ID newParentId) {
		// Create an attachment
		Attachment att = new Attachment(
            Name 	 = name, 
            Body 	 = Blob.valueOf(newBody), 
            ParentId = newParentId);
		
        return att;
	}
	
    //Insert data   
    public static Opportunity insertOpportunities() { //single        
        String name = 'Test method';
        Opportunity newOpp = newOpportunity(name);
        insert newOpp; 
        return newOpp;
    }    
    
    public static List<Opportunity> insertOpportunities(Integer amount) { //multi        
        String name = 'Test method ';
        List<Opportunity> newOpps = new List<Opportunity>();
        for(Integer i=0; i<amount; i++) {
        	newOpps.add(newOpportunity(name+i));
        }        
        insert newOpps;
        return newOpps;
    }    
     
    public static Attachment insertAttachments(Opportunity newOpp) { //single        
        String name = 'New Test Attachment';
        String body = 'Test Attachment Body';
        Attachment newAtt = newAttachment(name, body, newOpp.Id);
        insert newAtt;
        return newAtt;
    }
    
    public static List<Attachment> insertAttachments(Integer amount, List<Opportunity> newOpps) { //multi
        String name = 'New Test Attachment ';
        String body = 'Test Attachment Body ';
        List<Attachment> newAtts = new List<Attachment>();
        
        for(Opportunity opp : newOpps) {
        	for(Integer j=0; j<amount; j++) {
        		newAtts.add(newAttachment(name+j, body+j, opp.Id));
        	}
        }       
        insert newAtts;
        return newAtts;
    }
}