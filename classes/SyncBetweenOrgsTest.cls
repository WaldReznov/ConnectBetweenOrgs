@isTest
public with sharing class SyncBetweenOrgsTest {
    
    @isTest 
    public static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        insert new OrgInformation__c(
            Login__c = 'vladislav.ershov@vjlink.com',
            Name = 'vladislav.ershov@vjlink.com',
            Password__c = 'vladislav.ershov@vjlink.com',
            RestUrl__c = 'vladislav.ershov@vjlink.com'
        );

        insert new House__c(Name = 'new house');
        
        Test.startTest();
        Database.executeBatch(new SyncBetweenOrgs());
        Test.stopTest();
        
    }

}