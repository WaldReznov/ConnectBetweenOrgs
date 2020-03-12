@RestResource(urlMapping='/House/*')
global with sharing class HouseWebService {
    global class HouseWrapper {
        global String name;
        global String ownerPhone;
        global String id;
        global String externalId;
        global Decimal floorsNumber;
        global Decimal price;
    }

    @HttpGet
    global static String syncHouses(){
        String method = RestContext.request.params.get('method');

        if(method == 'upsert') {
            Database.ExecuteBatch(new SyncBetweenOrgs(), 200);
        } else if(method == 'delete') {
            Database.ExecuteBatch(new DeleteRecordsFromDifferentOrg(), 200);
        }

        return 'Ok';
    }

    @HttpPut
    global static String upsertHouse(List<HouseWrapper> housesWrapper) {
        List<House__c> houses = getHouses(getHousesExternalId(housesWrapper));

        houses = updateHouses(houses, housesWrapper);

        List<House__c> uniqHouses = getUniqHouses(houses, housesWrapper);

        houses.addAll(uniqHouses);

        try {
            upsert houses;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return 'Success';
    }

    private static List<House__c> updateHouses(List<House__c> houses, List<HouseWrapper> housesWrapper){
        for (HouseWrapper houseWrapperItem : housesWrapper) {
            for (House__c houseItem : houses) {
                if (houseItem.ExternalId__c == houseWrapperItem.externalId) {
                    houseItem.Name            = houseWrapperItem.name;
                    houseItem.OwnerPhone__c   = houseWrapperItem.ownerPhone;
                    houseItem.Price__c        = houseWrapperItem.price;
                    houseItem.FloorsNumber__c = houseWrapperItem.floorsNumber;
                } 
            }
        }

        return houses;
    }

    private static List<House__c> getUniqHouses(List<House__c> houses, List<HouseWrapper> housesWrapper) {
        List<House__c> uniqHouses = new List<House__c>();

        for(HouseWrapper houseWrapperItem : housesWrapper){
            Boolean isValid = true;

            for(House__c houseItem : houses){
                if(houseItem.ExternalId__c == houseWrapperItem.externalId) {
                    isValid = false;
                }
            }

            if(isValid) {
                uniqHouses.add(new House__c(
                    Name            = houseWrapperItem.name,
                    OwnerPhone__c   = houseWrapperItem.ownerPhone,
                    Price__c        = houseWrapperItem.price,
                    FloorsNumber__c = houseWrapperItem.floorsNumber,
                    ExternalId__c   = houseWrapperItem.externalId
                ));
            }
        }

        return uniqHouses;
    }

    @HttpDelete
    global static String deleteHouse() {
        List<HouseWrapper> housesWrapper = (List<HouseWrapper>) JSON.deserialize(
            RestContext.request.requestBody.toString(), 
            List<HouseWrapper>.class
        );

        List<House__c> houses = getHouses(getHousesExternalId(housesWrapper));
        
        try {
            delete houses;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return 'Success';
    }

    private static List<String> getHousesExternalId(List<HouseWrapper> housesWrapper) {
        List<String> housesExternalId = new List<String>();

        for(HouseWrapper houseWrapper : housesWrapper) {
            housesExternalId.add(houseWrapper.externalId);
        }

        return housesExternalId;
    }

    private static List<House__c> getHouses(List<String> housesExternalId) {
        List<House__c> houses = [
            SELECT 
                    Id,
                    ExternalId__c,
                    Name,
                    OwnerPhone__c,
                    Price__c,
                    FloorsNumber__c 
            FROM 
                    House__c 
            WHERE 
                    ExternalId__c IN :housesExternalId 
            LIMIT 
                    10000
        ];

        return houses;
    }

}