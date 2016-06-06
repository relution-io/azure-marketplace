# Relution Azure Marketplace

This is an easy to use template to deploy Relution Server on Microsoft Azure infrastructure.
If you need information first what Relution is for or what services Relution provides, please read [here] (http://www.relution.io) before.

The template creates a Relution server including SQL Database. 
Our Relution freemium license grant you the permission to run our software on a dedicated instance for evaluation purposes.

There could be additional costs to run the service in Azure cloud your are responsible for.

You can view the UI in developer mode by [clicking here](https://portal.azure.com/#blade/Microsoft_Azure_Compute/CreateMultiVmWizardBlade/internal_bladeCallId/anything/internal_bladeCallerParams/{"initialData":{},"providerConfig":{"createUiDefinition":"https%3A%2F%2Fraw.githubusercontent.com%2Frelution-io%2Fazure-marketplace%2Fmaster%2FcreateUiDefinition.json"}}). If you feel something is cached improperly use [this client unoptimized link instead](https://portal.azure.com/?clientOptimizations=false#blade/Microsoft_Azure_Compute/CreateMultiVmWizardBlade/internal_bladeCallId/anything/internal_bladeCallerParams/{"initialData":{},"providerConfig":{"createUiDefinition":"https%3A%2F%2Fraw.githubusercontent.com%2Frelution-io%2Fazure-marketplace%2Fmaster%2FcreateUiDefinition.json"}})

Before you click on the button below:

1. Have your credentials available for the Azure platform
2. We provide you with a template where you have to enter few data:
    - Choose a name for your Service e.g. 'RelutionTrail'
    - Choose a strong password - choose a really strong passord!
    - Enter a ResourceGroupName "e.g. relution1" to identify all resources which are belongs to this service and keep it in mind (It will be your subdomin address to get access to your instance.)
    - Accept License Aggrement of Azure platform.
    - Being patient it takes a while until Relution server is launched
    - Now get access to your server under: https://&lt;ResourceGroupName&gt;.azure.mway.io (user: admin, password: admin123)
     (Please change your Password first after your server is launched. We will improve this in the future.)
    
 
### Deploy Relution Server on Azure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frelution-io%2Fazure-marketplace%2Fmaster%2FmainTemplate.json" target="_blank">
   <img alt="Deploy to Azure" src="http://azuredeploy.net/deploybutton.png"/>
</a>



Disclaimer:
 
Relution is a product of [M-Way Solutions GmbH](http://www.mwaysolutions.com).
Server license will be automatically measured through M-Way Solutions license service.


