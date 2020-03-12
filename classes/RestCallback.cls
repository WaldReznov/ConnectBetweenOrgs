public class RestCallback {

    class ResponseWrapper {
        String id;
        String access_token;
    }

    class HouseWrapper {
        String name;
        String ownerPhone;
        String id;
        String externalId;
        Decimal floorsNumber;
        Decimal price;
    }

    public static void callUpsertHouseCallback(String houses) {
        RestCallback restCallback = new RestCallback();
        String accessToken        = restCallback.returnAccessToken(restCallback);
        
        OrgInformation__c orgInformation = getOrgInformation();

        String endPoint = orgInformation.RestUrl__c;
        
        if (accessToken != null) {
            Http http           = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody('{"housesWrapper" : ' + houses + '}');
            request.setMethod('PUT');
            request.setEndpoint(endPoint);

            HttpResponse httpResponse = http.send(request);
        }
    }

    public static void callDeleteHouse(String houses) {
        RestCallback restCallback = new RestCallback();
        String accessToken        = restCallback.returnAccessToken(restCallback);
        
        OrgInformation__c orgInformation = getOrgInformation();

        String endPoint = orgInformation.RestUrl__c;
        
        if (accessToken != null) {
            Http http           = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(houses);
            request.setMethod('DELETE');
            request.setEndpoint(endPoint);

            HttpResponse httpResponse = http.send(request);
        }
    }

    public static void houseActions(String method) {
        RestCallback restCallback = new RestCallback();
        String accessToken        = restCallback.returnAccessToken(restCallback);
       
        OrgInformation__c orgInformation = getOrgInformation();

        String endPoint = orgInformation.RestUrl__c + '?method=' + method;

        if(accessToken != null) {
            Http http = new Http();

            HttpRequest request = new HttpRequest();
            
            request.setHeader('Authorization','Bearer ' + accessToken);
            request.setHeader('Content-Type','application/json;charset=UTF-8');
            request.setMethod('GET');
            request.setEndpoint(endPoint);
            
            HttpResponse response = http.send(request);
        }
    } 
    
    public static void syncHouse() {
        RestCallback restCallback = new RestCallback();
        String accessToken        = RestCallback.ReturnAccessToken(restCallback);

        OrgInformation__c orgInformation = getOrgInformation();

        String endPoint = orgInformation.RestUrl__c  + '?method=upsert';

        if(accessToken != null) {
            Http http = new Http();

            HttpRequest request = new HttpRequest();
            
            request.setHeader('Authorization','Bearer ' + accessToken);
            request.setHeader('Content-Type','application/json;charset=UTF-8');
            request.setMethod('GET');
            request.setEndpoint(endPoint);
            
            HttpResponse response = http.send(request);
        }
    }

    public String returnAccessToken(RestCallback account) {
        Http http           = new Http();
        HttpRequest request = new HttpRequest();

        OrgInformation__c orgInformation = getOrgInformation();
        
        request.setMethod('POST');
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9G9pzCUSkzZuYi2FUP6XiWhTK42af35GHMI9v1e7Cc866mL6c2zGkjtgMa7qLMfMz3VjFhxm9RKS7bd8h&client_secret=06EE1679697E5353A8FBBDEB21B5AC27DB19E246D4F58D7661300A6241C43B96&username=' + orgInformation.Login__c + '&password=' + orgInformation.Password__c);
        
        HttpResponse response           = http.send(request);
        ResponseWrapper responseWrapper = (ResponseWrapper) JSON.deserialize(response.getBody(), ResponseWrapper.class);
        
        return responseWrapper.access_token;
    }

    public static OrgInformation__c getOrgInformation() {
        return OrgInformation__c.getValues('vladislav.ershov@vjlink.com');
    }    
    
}