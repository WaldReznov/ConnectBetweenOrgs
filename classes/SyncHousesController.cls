public with sharing class SyncHousesController {
    
    @AuraEnabled
    public static void houseActions(String method){
        RestCallback.houseActions(method);
    }

}