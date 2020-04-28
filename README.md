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
|CustomException||Apex Class|
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


Here is the package url : https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2v000005tEla 
As this is unmanaged package, every component in the package is editable. 
1.	Check for desired profile to enable Integration Setup Tab in your org.
2.	Create a record in Integration Setup object with following details
a.	Name for Integration – This would be used as identifier in our integration framework. So, this could be kept as unique name.
b.	End Point Url
c.	Request Type – GET, POST, PUT, PATCH (Note: It is expected there will remote site settings for domain url if the request is of type GET)
d.	Response Parse Class Name – Ideally for any response we would be getting in any integration, we create a wrapper class. We could also use sObject name here if desired response is of type sObject details.
e.	Is Response a collection type – if the response is of type collection, pls check this checkbox.
3.	If the Integration Setup created above needs to set header details or url parameters, create record in Related List – Integration Values Setup
4.	Create a record in Integration values setup with following details
a.	Related Integration Setup – Master detail field with Integration setup object
b.	Type – Header or Url Param
c.	Type Key – Key element for Type
d.	Type Value – Value element for Type
5.	Test the Integration with following code snippet
HttpApiFactory.requestResourceStatic(<name of integration setup record created above>, 
<body if the request is of type POST else this can be null>);

6.	This will give a debug of the response if request is successful.

Things to consider:
1.	It is suggested to create a Named Credential if the Authentication is of type Username-password or oAuth authentication.
2.	It is suggested to use Auth Providers and use that in named credentials to set up authentication.
3.	Endpoint generated created in Named Credentials can be used in Integration Setup object. 

Screenshots for example:
 
