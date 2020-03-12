@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id": "0012v00002toKbZAAU", "access_token": "00D2v0000012RGe!AQQAQGbbbFMlQZU8E3PRe951c_r36MKzhJWo_9xzwFtblBC.Z.hGJuvk_DE7UHidTagR9DsVgyrcOFxg7pARiXlBWoUyv_sL"}');
        res.setStatusCode(200);
        return res;
    }

}