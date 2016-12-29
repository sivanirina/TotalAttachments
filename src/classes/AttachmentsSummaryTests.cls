@isTest (seeAllData=false)
private class AttachmentsSummaryTests {
    /* Triggers Single Positive Test */
    static testmethod void testSingleInsert() {
        //create a test opportunity with an attachment
        Opportunity testOpp = OpportunitiesData.insertOpportunities();
        Attachment testAtt  = OpportunitiesData.insertAttachments(testOpp);

        //check summary fields' value
        System.assertEquals(Total(), 1);
    }

    static testmethod void testSingleDelete() {
        //create a test opportunity with an attachment
        Opportunity testOpp = OpportunitiesData.insertOpportunities();
        Attachment testAtt  = OpportunitiesData.insertAttachments(testOpp);

        //check summary fields' value
        System.assertEquals(Total(), 1);

        //delete the attachment
        delete testAtt;
        System.assertEquals(Total(), 0);
    }

    static testmethod void testSingleUnDelete() {
        //create a test opportunity with an attachment
        Opportunity testOpp = OpportunitiesData.insertOpportunities();
        Attachment testAtt  = OpportunitiesData.insertAttachments(testOpp);
        //check summary fields' value
        System.assertEquals(Total(), 1);

        //delete the attachment
        delete testAtt;
        System.assertEquals(Total(), 0);

        //undelete the attachment
        undelete testAtt;
        System.assertEquals(Total(), 1);
    }

    /* triggers Multi positive test */
    static testmethod void testMultiInsert() {
        //create 50 opportunities with 50 attachments
        final Integer amount       = 50;
        final Integer totalAmount  = 2500;
        List<Opportunity> testOpps = OpportunitiesData.insertOpportunities(amount);
        List<Attachment> testAtts  = OpportunitiesData.insertAttachments(amount, testOpps);

        //check summary fields' value
        System.assertEquals(Total(), totalAmount);
    }

    static testmethod void testMultiDelete() {
        //create 50 opportunities with 50 attachments
        final Integer amount       = 50;
        final Integer totalAmount  = 2500;
        List<Opportunity> testOpps = OpportunitiesData.insertOpportunities(amount);
        List<Attachment> testAtts  = OpportunitiesData.insertAttachments(amount, testOpps);

        //check summary fields' value
        System.assertEquals(Total(), totalAmount);

        //delete the attachments
        delete testAtts;
        System.assertEquals(Total(), 0);
    }

    static testmethod void testMultiUnDelete() {
        //create 50 opportunities with 50 attachments
        final Integer amount       = 50;
        final Integer totalAmount  = 2500;
        List<Opportunity> testOpps = OpportunitiesData.insertOpportunities(amount);
        List<Attachment> testAtts  = OpportunitiesData.insertAttachments(amount, testOpps);

        //check summary fields' value
        System.assertEquals(Total(), totalAmount);

        //delete the attachments
        delete testAtts;
        System.assertEquals(Total(), 0);

        //undelete the attachments
        undelete testAtts;
        System.assertEquals(Total(), totalAmount);
    }

    /* triggers negative test: test with another sObject, not Opportunity*/
    static testmethod void testNegative() {
        //create an account
        String accName = 'Test method';
        Account newAcc = new Account(Name = accName);
        insert newAcc;

        //create an attachment
        String attName    = 'New Test Attachment';
        String attBody    = 'Test Attachment Body';
        Attachment newAtt = OpportunitiesData.newAttachment(attName, attBody, newAcc.Id);

        //run test insert,delete,undelete triggers
        Test.startTest();
        Database.SaveResult saveResult         = database.insert(newAtt);
        Database.DeleteResult deleteResult     = database.delete(newAtt);
        Database.UndeleteResult undeleteResult = database.undelete(newAtt);
        Test.stopTest();

        System.assert(saveResult.isSuccess());
        System.assert(deleteResult.isSuccess());
        System.assert(undeleteResult.isSuccess());
    }

    /* Schedulable positive test */
    static testmethod void testSchedule() {
        //create a test opportunity with an attachment
        Opportunity testOpp = OpportunitiesData.insertOpportunities();
        Attachment testAtt 	= OpportunitiesData.insertAttachments(testOpp);

        //set wrong test value
        testOpp.Total_Attachments__c = null;
        update testOpp;

        //create Schedule class and datetime:
        AttachmentsSummarySchedule sch1 = new AttachmentsSummarySchedule();
        String sch='0 0 20 * * ?';

        Test.startTest();
        System.schedule('Test opportunity attachmnets count', sch, sch1);
        Test.stopTest();

        System.assertEquals(Total(), 1);
    }

    //Additional classes:
    //get total attachments of opportunities from database
    public static Integer Total() {
        AggregateResult agr = [Select Sum(Total_Attachments__c) totalSum From Opportunity];
        return Integer.valueOf(agr.get('totalSum')+'');
    }
}
