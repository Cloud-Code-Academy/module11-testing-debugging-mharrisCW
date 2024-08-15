@isTest
public with sharing class LeadTriggerHandlerTest {

    @isTest
    public static void testLeadTitleNormalization() {
        List<Lead> leads = new List<Lead>();
        Lead lead = new Lead(FirstName = 'Test', LastName = 'Test', Title = 'vp', Company = 'Test');
        leads.add(lead);
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = 'mgr', Company = 'Test'));
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = 'exec', Company = 'Test'));
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Title = 'assistant', Company = 'Test'));

        
        
        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leads);
        Test.stopTest();
        Lead updatedLead = leads[0];
        Assert.areEqual('Vice President', updatedLead.Title, 'Title should be Vice President');
        Assert.areEqual('Manager', leads[1].Title, 'Title should be Manager');
        Assert.areEqual('Executive', leads[2].Title, 'Title should be Executive');
        Assert.areEqual('Assistant', leads[3].Title, 'Title should be Assistant');
    }

    @isTest
    public static void testHandleAutoLeadScoring() {
     
        List<Lead> leads = new List<Lead>();
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Company = 'Test', Title = 'vp', LeadSource = 'Website', Industry = 'Technology', Phone = '4055141430', Email ='j.matt.harris@gmail.com'));
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Company = 'Test', Title = 'vp', LeadSource = 'Website', Industry = 'Technology', Phone = '4055141430'));
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Company = 'Test', Title = 'vp', LeadSource = 'Website', Industry = 'Technology'));
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Company = 'Test', Title = 'vp', LeadSource = 'Website'));
        leads.add(new Lead(FirstName = 'Test', LastName = 'Test', Company = 'Test', Title = 'vp'));
        insert leads;

        test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leads);
        test.stopTest();

        Assert.areEqual(18, leads[0].Lead_Score__c, 'Lead score should be 18');
        Assert.areEqual(15, leads[1].Lead_Score__c, 'Lead score should be 15');
        Assert.areEqual(10, leads[2].Lead_Score__c, 'Lead score should be 10');
        Assert.areEqual(0, leads[3].Lead_Score__c,  'Lead score should be 0');
        Assert.areEqual(0, leads[4].Lead_Score__c,  'Lead score should be 0');

    }
    @isTest
    static void testhandleLeadAutoConvert(){
        Account acc = new Account(Name ='Test');
        insert acc;
        Contact contact = new Contact(FirstName = 'Test', LastName = 'Test', AccountId = acc.Id, Email = 'test@test.com');
        insert contact;
        lead leadToConvert = new Lead(FirstName = 'Test', LastName = 'Test', Company = 'Test', Email = 'test@test.com');
        
       

        test.startTest();
        insert leadToConvert;
        test.stopTest();

        Lead updatedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :leadToConvert.Id];
        Assert.isTrue(updatedLead.IsConverted, 'Lead should be converted');
    }
}