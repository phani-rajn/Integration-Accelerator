@isTest
private class HttpApiFactory_Test {
     
    @TestSetup
    static void setup(){
        List<Integration_Setup__c> setupToInsert = new List<Integration_Setup__c>();
        setupToInsert.add(new Integration_Setup__c(
            Name = 'Example Endpoint',
            Callout_Endpoint_Url__c = 'http://example.com/example/test',
            Is_Response_a_collection_type__c = false,
            Request_Type__c = 'POST'
        ));
        setupToInsert.add(new Integration_Setup__c(
            Name = 'Examples GET Process',
            Callout_Endpoint_Url__c = 'http://example.com/example/testA',
            Is_Response_a_collection_type__c = false,
            Request_Type__c = 'GET'
        ));
        setupToInsert.add(new Integration_Setup__c(
            Name = 'Examples GET Static Process',
            Callout_Endpoint_Url__c = 'http://example.com/example/testA',
            Is_Response_a_collection_type__c = false,
            Request_Type__c = 'GET'
        ));
        insert setupToInsert;
         
        List<Integration_Values_Setup__c> valuesSetup = new List<Integration_Values_Setup__c>();
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setupToInsert[0].id,
            Type__c = 'Header',
            Type_Key__c = 'Content-Type',
            Type_Value__c = 'application/json'
        ));
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setupToInsert[0].id,
            Type__c = 'urlParam',
            Type_Key__c = 'a',
            Type_Value__c = 'b'
        ));
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setupToInsert[1].id,
            Type__c = 'urlParam',
            Type_Key__c = 'a',
            Type_Value__c = '{0}'
        ));
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setupToInsert[1].id,
            Type__c = 'urlParam',
            Type_Key__c = 'b',
            Type_Value__c = '{1}'
        ));
        valuesSetup.add(new Integration_Values_Setup__c(
            Related_Integration_Setup__c = setupToInsert[2].id,
            Type__c = 'RequestURI_with_lastIndex',
            Type_Key__c = 'a',
            Type_Value__c = '{0}'
        ));
        
        insert valuesSetup;
    }
    
    //************************ STATIC METHODS **********************//
     
    @isTest 
    static void positiveTestCalloutWithSetupName() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory.requestResourceStatic('Examples GET Static Process');
        TEST.stopTest();
    }
    
    @isTest 
    static void NegativeTestCalloutWithoutSetupName() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{
            HttpApiFactory.requestResourceStatic(null);
        }catch(exception e){}
        TEST.stopTest();
    }
    
    //***************************************************************
    
    @isTest 
    static void positiveTestCalloutWithSetupNameAndBody() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory.requestResourceStatic('Example Endpoint','{"example":"test"}');
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithoutSetupNameAndWithBody() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{
            HttpApiFactory.requestResourceStatic('','{"example":"test"}');
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithSetupNameAndWithoutBody() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{
            HttpApiFactory.requestResourceStatic('Example Endpoint','');
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    //************************************************************************************
    
    @isTest 
    static void positiveTestCalloutWithSetupNameAndListOfParams() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        List<String> urlParams = new List<String>{'aa','bb'};
        TEST.startTest();
        HttpApiFactory.requestResourceStatic('Examples GET Process',urlParams);
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithoutSetupNameAndWithListOfParams() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        List<String> urlParams = new List<String>{'aa','bb'};
        TEST.startTest();
        try{    
            HttpApiFactory.requestResourceStatic('',urlParams);
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithSetupNameAndWithoutListOfParams() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory.requestResourceStatic('Examples GET Process',new List<String>());
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    //************************************************************************************
    
    //************************ NON-STATIC METHODS **********************//
    
    @isTest 
    static void positiveTestCalloutWithSetupNameNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory apiFactory = new HttpApiFactory();
        apiFactory.requestResource('Examples GET Static Process');
        TEST.stopTest();
    }
    
    @isTest 
    static void NegativeTestCalloutWithoutSetupNameNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource(null);
        }catch(exception e){}
        TEST.stopTest();
    }
    
    //***************************************************************
    
    @isTest 
    static void positiveTestCalloutWithSetupNameAndBodyNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory apiFactory = new HttpApiFactory();
        apiFactory.requestResource('Example Endpoint','{"example":"test"}');
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithoutSetupNameAndWithBodyNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('','{"example":"test"}');
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithSetupNameAndWithoutBodyNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('Example Endpoint','');
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    //************************************************************************************
    
    @isTest 
    static void positiveTestCalloutWithSetupNameAndListOfParamsNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        List<String> urlParams = new List<String>{'aa','bb'};
        TEST.startTest();
        HttpApiFactory apiFactory = new HttpApiFactory();
        apiFactory.requestResource('Examples GET Process',urlParams);
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithoutSetupNameAndWithListOfParamsNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        List<String> urlParams = new List<String>{'aa','bb'};
        TEST.startTest();
        try{    
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('',urlParams);
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithSetupNameAndWithoutListOfParamsNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('Examples GET Process',new List<String>());
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    @isTest 
    static void negativeTestCalloutWithWrongSetupNameAndWithoutListOfParamsNonStatic() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        try{    
            HttpApiFactory apiFactory = new HttpApiFactory();
            apiFactory.requestResource('Examples POST Process',new List<String>{'a','b'});
        }catch(Exception e){}
        TEST.stopTest();
    }
    
    //************************************************************************************
    @isTest
    static void positiveTestCalloutWithSetupNameAndRequestUriParams(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForHTTPFactory());
        TEST.startTest();
        HttpApiFactory apiFactory = new HttpApiFactory();
        apiFactory.requestResource('Examples GET Static Process',new List<String>{'a'});
        TEST.stopTest();
    }
}