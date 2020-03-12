@IsTest
public class HouseWebServiceTest {

    public class HouseWrapper {
        String name;
        String ownerPhone;
        String id;
        String externalId;
        Decimal floorsNumber;
        Decimal price;
    }

    @TestSetup
    static void makeData(){
        insert new House__c(Name = 'John Doe', ExternalId__c = 'externalId');
    }


    @IsTest
    static void updateHouse(){

        House__c house = [SELECT Id, Name, ExternalId__c FROM House__c LIMIT 1];

        List<HouseWebService.HouseWrapper> houses = new List<HouseWebService.HouseWrapper>();
        
        HouseWebService.HouseWrapper houseWrapper = new HouseWebService.HouseWrapper();
        houseWrapper.name = 'TEST';
        houseWrapper.externalId = house.ExternalId__c;

        houses.add(houseWrapper);
        Test.startTest();

        HouseWebService.upsertHouse(houses);
        System.assert([SELECT count() FROM House__c WHERE Name = 'TEST'] == 1);

        Test.stopTest();
        
    }
    
    @IsTest
    static void upsertHouses(){

        House__c house = [SELECT Id, Name, ExternalId__c FROM House__c LIMIT 1];

        List<HouseWebService.HouseWrapper> houses = new List<HouseWebService.HouseWrapper>();
        
        HouseWebService.HouseWrapper houseWrapper = new HouseWebService.HouseWrapper();
        houseWrapper.name = 'TEST';        
        houseWrapper.externalId = house.ExternalId__c;

        houses.add(houseWrapper);

        HouseWebService.HouseWrapper houseWrapper2 = new HouseWebService.HouseWrapper();
        houseWrapper2.name = 'house Name';
        houseWrapper2.externalId = 'TEST';

        houses.add(houseWrapper2);
        Test.startTest();

        HouseWebService.upsertHouse(houses);
        System.assert([SELECT count() FROM House__c WHERE Name = 'TEST'] == 1);
        System.assert([SELECT count() FROM House__c] == 2);

        Test.stopTest();
        
    }

    @IsTest
    static void createHouse(){

        delete [SELECT Id FROM House__c];

        List<HouseWebService.HouseWrapper> houses = new List<HouseWebService.HouseWrapper>();
        HouseWebService.HouseWrapper houseWrapper = new HouseWebService.HouseWrapper();
        houseWrapper.name = 'TEST';
        houseWrapper.externalId = 'externalId';

        houses.add(houseWrapper);
        Test.startTest();

        HouseWebService.upsertHouse(houses);
        System.assert([SELECT count() FROM House__c WHERE Name = 'TEST'] == 1);

        Test.stopTest();
        
    }

    @IsTest
    static void callBatchForSync(){

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        insert new OrgInformation__c(
            Login__c = 'vladislav.ershov@vjlink.com',
            Name = 'vladislav.ershov@vjlink.com',
            Password__c = 'vladislav.ershov@vjlink.com',
            RestUrl__c = 'vladislav.ershov@vjlink.com'
        );

        RestRequest req = new RestRequest(); 

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/House/';
        RestContext.request = req; 
        RestContext.request.params.put('method', 'upsert');

        Test.startTest();
        
        HouseWebService.syncHouses();

        Test.stopTest();
        
    }

    @IsTest
    static void callBatchForDelete(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        insert new OrgInformation__c(
            Login__c = 'vladislav.ershov@vjlink.com',
            Name = 'vladislav.ershov@vjlink.com',
            Password__c = 'vladislav.ershov@vjlink.com',
            RestUrl__c = 'vladislav.ershov@vjlink.com'
        );

        RestRequest req = new RestRequest(); 

        req.addHeader('httpMethod', 'GET');
        req.requestUri = '/services/apexrest/House/';
        RestContext.request = req; 
        RestContext.request.params.put('method', 'delete');

        Test.startTest();
            HouseWebService.syncHouses();
        Test.stopTest();
        
    }

    @IsTest
    static void deleteHouses(){

        House__c house = [SELECT Id, Name, ExternalId__c FROM House__c LIMIT 1];

        List<HouseWebService.HouseWrapper> houses = new List<HouseWebService.HouseWrapper>();
        
        HouseWebService.HouseWrapper houseWrapper = new HouseWebService.HouseWrapper();
        houseWrapper.externalId = house.ExternalId__c;
        houses.add(houseWrapper);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'DELETE');
        req.requestUri = '/services/apexrest/House/';       
        String JsonMsg = JSON.serialize(houses);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;


        Test.startTest();

        HouseWebService.deleteHouse();
        System.assert([SELECT count() FROM House__c] == 0);

        Test.stopTest();
        
    }

}