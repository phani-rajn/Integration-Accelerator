@isTest
private class HttpApiFactory_Test {
     
    @TestSetup
    static void setup(){
        Integration_Setup__c setup = new Integration_Setup__c(
            Name = 'Example Endpoint',
            Callout_Endpoint_Url__c = 'http://example.com/example/test',
            Is_Response_a_collection_type__c = false,
            Request_Type__c = 'POST'
        );
        insert setup;
         
        List<Integration_Values_Setup__c> valuesSetup = new List<Integration_Values_Setup__c>();
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setup.id,
            Type__c = 'Header',
            Type_Key__c = 'Content-Type',
            Type_Value__c = 'application/json'
        ));
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setup.id,
            Type__c = 'urlParam',
            Type_Key__c = 'a',
            Type_Value__c = 'b'
        ));
         
        insert valuesSetup;
    }
     
    @isTest 
    static void positiveTestCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory.requestResourceStatic('Example Endpoint','{"example":"test"}');
        TEST.stopTest();
    }
    
    @isTest 
    static void positiveTestCalloutWithoutUrlParam() {
        Delete [Select Id from Integration_Values_Setup__c where Type__c = 'urlParam' and Type_Key__c = 'a'];
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory.requestResourceStatic('Example Endpoint','{"example":"test"}');
        TEST.stopTest();
    }
    
    @isTest 
    static void badRequestWithNoName() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory.requestResourceStatic(null,'{"example":"test"}');
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void badRequestWithBadName() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory.requestResourceStatic('Example','{"example":"test"}');
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void badPostRequestWithNoBody() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory.requestResourceStatic('Example Endpoint',null);
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void badPostRequestClassInstanceWithNoBody() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('Example Endpoint',null);
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void badPostRequestClassInstanceWithNoName() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('',null);
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void badPostRequestWithSomeActionInBackground() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        try{
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('Example Endpoint','{"example":"test"}');
        }catch(Exception e){}
    }
}