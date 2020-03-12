global with sharing class DeleteRecordsFromDifferentOrg implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful  {
    global class HouseWrapper {
        String name;
        String ownerPhone;
        String id;
        String externalId;
        Decimal floorsNumber;
        Decimal price;

        global HouseWrapper(String id, String name, String ownerPhone, String externalId, Decimal floorsNumber, Decimal price) {
            this.name = name;
            this.id = id; 
            this.ownerPhone = ownerPhone;
            this.externalId = externalId;
            this.floorsNumber = floorsNumber; 
            this.price = price;
        }
    }

    String query = 'SELECT Id, Name, OwnerPhone__c, ExternalId__c, FloorsNumber__c, Price__c FROM House__c WHERE IsDeleted = true ALL ROWS';

    global Database.QueryLocator start(Database.BatchableContext jobId) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext jobId, List<House__c> recordList) {
        List<HouseWrapper> houses = new List<HouseWrapper>();

        for(House__c house : recordList) {
            houses.add(new HouseWrapper(
                house.Id, house.Name, house.OwnerPhone__c, house.ExternalId__c, house.FloorsNumber__c, house.Price__c
            ));
        }

        RestCallback.callDeleteHouse(JSON.serialize(houses, true));
    }

    global void finish(Database.BatchableContext jobIdParam) {
    }
}