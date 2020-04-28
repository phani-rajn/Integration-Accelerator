# Integration Accelerator Asset
## User Manual

### Package Components	 
#### Resources (3)
|Component Name|Parent Object|Component Type|
|--------------|-------------|--------------|
|All	|Integration Setup|	List View|
|Integration Values Setup Layout|Integration Values Setup|Page Layout|
|Integration Setup Layout|Integration Setup|Page Layout|

 
#### Code (4)
|Component Name|Parent Object|Component Type|
|--------------|-------------|--------------|
|HttpApiFactory_Test||Apex Class|
|HttpApiCustomException||Apex Class|
|HttpApiFactory||Apex Class|
|MockHttpResponseGeneratorForHTTPFactory||Apex Class|

 
#### Objects (2)
|Component Name|Parent Object|Component Type|
|--------------|-------------|--------------|
|Integration Setup||Custom Object|
|Integration Values Setup||Custom Object|

#### Fields (8)
|Component Name|Parent Object|Component Type|
|--------------|-------------|--------------|
|Related Integration Setup|Integration Values Setup|Custom Field|
|Type Key|Integration Values Setup|Custom Field|
|Response Parse Class Name|Integration Setup|Custom Field|
|Callout Endpoint Url|Integration Setup|Custom Field|
|Request Type|Integration Setup|Custom Field|
|Type Value|	Integration Values Setup|Custom Field|
|Type|	Integration Values Setup|Custom Field|
|Is Response a collection type|Integration Setup|Custom Field|
 
 
#### Tabs (1)
|Component Name|Parent Object|Component Type|
|--------------|-------------|--------------|
|Integration Setup||Tab|

Every component in the package is editable. 
* Check for desired profile to enable Integration Setup Tab in your org.
* Create a record in Integration Setup object with following details
** Name for Integration – This would be used as identifier in our integration framework. So, this could be kept as unique name.
** End Point Url
** Request Type – **GET, POST, PUT, PATCH** *(Note: It is expected there will remote site settings for domain url if the request is of type GET)*
** Response Parse Class Name – Ideally for any response we would be getting in any integration, we create a wrapper class. We could also use sObject name here if desired response is of type sObject details.
** Is Response a collection type – if the response is of type collection, pls check this checkbox.
* If the Integration Setup created above needs to set header details or url parameters, create record in Related List – Integration Values Setup
* Create a record in Integration values setup with following details
** Related Integration Setup – Master detail field with Integration setup object
** Type – Header or Url Param
** Type Key – Key element for Type
** Type Value – Value element for Type


Things to consider:
* It is suggested to create a Named Credential if the Authentication is of type Username-password or oAuth authentication.
* It is suggested to use Auth Providers and use that in named credentials to set up authentication.
* Endpoint generated created in Named Credentials can be used in Integration Setup object. 

Screenshots for example:
![](Images/IntegrationSetup.png)
----------------------------------------------------------------------------------------------------------
![](Images/DynamicParamValuesForIntegration.png)

#### Code Snippets
**The code supports both static and non static methods. Below is the snippet for various use-cases.**<br/>
*GET Request With static parameters defined or no parameters defined*<br/>
If we have a setup where we have GET request setup and if the parameters are statically defined in setup values object
```
HttpApiFactory.requestResourceStatic(<Integration Setup Name>)
```
<br/>
*GET Request With dynamic parameters defined*<br/>
If we have a setup where we have GET request setup and if the parameter values are to be passed dynamically.
* We need to setup Integration Values for the dynamic parameter values. 
* For this, we need to setup place holders for every Integration Values Setup record in the Integration values setup object. 
![](Images/DynamicParamValuesForIntegration.png)
```
HttpApiFactory.requestResourceStatic(<Integration Setup Name>)
```
<br/>
