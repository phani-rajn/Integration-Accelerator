// Date : 01/25/2019
// Developer : EY Salesforce Team
// This class handles HTTP Request for any integration
public class HttpApiFactory{
    
    // Static Method with static request
    public static object requestResourceStatic(String integrationRequestSetupName){
        if(String.isBlank(integrationRequestSetupName)){
            throw new HttpApiCustomException('Please specify Integration request setup name');
        }
        HttpApiFactory requestFactory = new HttpApiFactory();
        Object factoryResponse = requestFactory.requestResource(integrationRequestSetupName, '', new List<String>());
        return factoryResponse;
    }
        
    // Static Method with body for post request
    public static Object requestResourceStatic(String integrationRequestSetupName, String bodyForPostRequest){
        if(String.isBlank(integrationRequestSetupName)){
            throw new HttpApiCustomException('Please specify Integration request setup name');
        }
        if(String.isBlank(bodyForPostRequest)){
            throw new HttpApiCustomException('Request cannot have null parameters');
        }
        HttpApiFactory requestFactory = new HttpApiFactory();
        Object factoryResponse = requestFactory.requestResource(integrationRequestSetupName, bodyForPostRequest, new List<String>());
        return factoryResponse;
    }
    
    // Static Method with dynamic parameters for enpoint
    public static Object requestResourceStatic(String integrationRequestSetupName, List<String> parameters){
        if(String.isBlank(integrationRequestSetupName)){
            throw new HttpApiCustomException('Please specify Integration request setup name');
        }
        if(parameters == null || parameters.isEmpty()){
            throw new HttpApiCustomException('Request cannot have null parameters');
        }
        HttpApiFactory requestFactory = new HttpApiFactory();
        Object factoryResponse = requestFactory.requestResource(integrationRequestSetupName, '', parameters);
        return factoryResponse;
    }
    
    // ================================================================================================ //
    // Non-static method with body for post request
    public Object requestResource(String integrationRequestSetupName){
        return requestResource(integrationRequestSetupName,'', new List<String>());
    }
    
    // Non-static method with body for post request
    public Object requestResource(String integrationRequestSetupName, String bodyForPostRequest){
        if(String.isBlank(bodyForPostRequest)){
            throw new HttpApiCustomException('Request cannot have null parameters');
        }
        return requestResource(integrationRequestSetupName,bodyForPostRequest, new List<String>());
    }
    
    // Non-static method with dynamic parameters for body
    public Object requestResource(String integrationRequestSetupName, List<string> parameters){
        if(parameters == null || parameters.isEmpty()){
            throw new HttpApiCustomException('Request cannot have null parameters');
        }
        return requestResource(integrationRequestSetupName, '', parameters);
    }
    
    // Non-static method
    Object requestResource(String integrationRequestSetupName, String bodyForPostRequest, List<String> dynamicUrlParameters){
        if(String.isBlank(integrationRequestSetupName)){
            throw new HttpApiCustomException('Please specify Integration request setup name');
        }
        Integration_Setup__c[] setupRecord = [Select Id, Name, Callout_Endpoint_Url__c, Request_Type__c, Response_Parse_Class_Name__c, Is_Response_a_collection_type__c,
                (Select Id,Type__c, Type_Key__c	,Type_Value__c from Integration_Values_Setup__r) from Integration_Setup__c where Name = :integrationRequestSetupName limit 1];
        if(setupRecord.isEmpty()){
            throw new HttpApiCustomException('Integration Setup record not found, please check Name in Integration Setup Object');
        }
        
        // set new Request 
        HttpRequest factoryRequest = new HttpRequest();
        // set end point url
        String endpoint = setupRecord[0].Callout_Endpoint_Url__c;
        if(!endpoint.endsWith('?')){
            endpoint += '?';
        }
        // set header values
        boolean removeLastCharacter = false;
        boolean urlFormattingReqd = false;
        for(Integration_Values_Setup__c valueRecord : setupRecord[0].Integration_Values_Setup__r){
            if(valueRecord.Type__c == 'Header' && String.isNotBlank(valueRecord.Type_Key__c) && String.isNotBlank(valueRecord.Type_Value__c)){
                factoryRequest.setHeader(valueRecord.Type_Key__c, valueRecord.Type_Value__c);
            }
            if(valueRecord.Type__c == 'urlParam' && String.isNotBlank(valueRecord.Type_Key__c) && String.isNotBlank(valueRecord.Type_Value__c)){
                removeLastCharacter = true;
                endpoint += valueRecord.Type_Key__c+'='+valueRecord.Type_Value__c+'&';
            }
            if(valueRecord.Type__c == 'RequestURI_with_lastIndex' && String.isNotBlank(valueRecord.Type_Key__c) && String.isNotBlank(valueRecord.Type_Value__c)){
                endpoint += '/'+valueRecord.Type_Value__c;
            }
        }
        
        if(removeLastCharacter){
            endpoint = endpoint.removeEnd('&');
        }else{
            endpoint = endpoint.remove('?');
        }
        
        if(!dynamicUrlParameters.isEmpty()){
            endpoint = String.format(endpoint, dynamicUrlParameters);
        }
        
        System.debug('endpoint '+endpoint);
           
        // set end point url for the request
        factoryRequest.setEndpoint(endpoint);
        
        // set the type of request => GET or POST.
        factoryRequest.setMethod(setupRecord[0].Request_Type__c);
        List<String> requestTypeCheck = new List<String>{'POST','PUT','PATCH' };
        if(requestTypeCheck.contains(setupRecord[0].Request_Type__c)){
            factoryRequest.setBody(bodyForPostRequest);
        }   
        
        // setup HTTP
        Http http = new Http();
        // initialize HttpRepsonse object
        HttpResponse factoryResponse;
        try{
            factoryResponse = http.send(factoryRequest);
        }catch(CalloutException exc){
            system.debug(exc.getMessage());
            throw new HttpApiCustomException('Bad Request, '+exc.getMessage());
        }
        // check for standard response code
        if(factoryResponse.getStatusCode() == 200){
            // setup type casting string
            Type resultType;
            if(String.isNotBlank(setupRecord[0].Response_Parse_Class_Name__c)){
                String typeCastName = setupRecord[0].Is_Response_a_Collection_Type__c ? 'List<'+setupRecord[0].Response_Parse_Class_Name__c+'>' : setupRecord[0].Response_Parse_Class_Name__c;
                resultType = Type.forName(typeCastName);
                System.debug(typeCastName);
            }
            try{
                System.debug(factoryResponse.getBody());
                // deserialize the response
                if(resultType != null){
                    Object responseObject = JSON.deserialize(factoryResponse.getBody(), resultType);
                    // return details
                    return responseObject;
                }
                return factoryResponse.getBody();
            }catch(Exception e){
                // throw exception on desrialize response
                throw new HttpApiCustomException('Could not deserialize response with '+setupRecord[0].Response_Parse_Class_Name__c);
            }
        }else{
            throw new HttpApiCustomException('Bad Request: Request returned with response - '+factoryResponse.getBody());
        }
    }
}