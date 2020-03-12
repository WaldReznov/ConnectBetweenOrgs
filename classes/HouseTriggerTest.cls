@isTest
public with sharing class HouseTriggerTest {
    
    @IsTest
    static void testTrigger(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        House__c house = new House__c(
            Name            = 'John Doe', 
            OwnerPhone__c   = '6666666', 
            Price__c        = 666, 
            FloorsNumber__c = 666666,
            ExternalId__c   = '0012v00002toKbZAAA'
        );

        insert house;

        System.assert(1 == [SELECT Count() FROM House__c]);

        house.name = 'John Doe 1';

        update house;

        System.assert('John Doe 1' == [SELECT Name FROM House__c LIMIT 1].Name);

        delete house;

        System.assert(0 == [SELECT Count() FROM House__c]);

        
    }

}