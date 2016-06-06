# Relution Azure Marketplace

This is an easy to use template to deploy a Relution Server on Microsoft Azure infrastructure.
If you want to learn more about Relution please check out our [Website] (http://www.relution.io).

The template creates a Relution server node and includes a SQL Database. 
The Relution free license grants you the permission to run a Relution server on a dedicated instance for evaluation purposes with maximal 10 users.

Additional costs by Microsoft for the operation of Relution in the Azure cloud will occur.

Please check following points before deploying a Relution server through a click on the button below:

1. Have your credentials available for the Azure platform
2. Enter following data in the given template:
    - Choose a name for your service e.g. 'MyRelutionDemo'
    - Choose a strong password - choose a really strong password!
    - Enter a ResourceGroupName "e.g. relution1" to identify all resources which belong to this service and remember this name (It will be your subdomin address to get access to your instance)
    - Accept the license agreement of the Azure platform
    - Be patient until the Relution server is launched
    - Now get access to your server at: https://&lt;ResourceGroupName&gt;.azure.mway.io (user: admin, password: admin123)
     (Please change your password immediately after your server is launched)
    
 
### Deploy Relution to Azure

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Frelution-io%2Fazure-marketplace%2Fmaster%2FmainTemplate.json" target="_blank">
   <img alt="Deploy to Azure" src="http://azuredeploy.net/deploybutton.png"/>
</a>


Testing 'createUiDefinition':

You can view the UI in developer mode by [clicking here](https://portal.azure.com/#blade/Microsoft_Azure_Compute/CreateMultiVmWizardBlade/internal_bladeCallId/anything/internal_bladeCallerParams/{"initialData":{},"providerConfig":{"createUiDefinition":"https%3A%2F%2Fraw.githubusercontent.com%2Frelution-io%2Fazure-marketplace%2Fmaster%2FcreateUiDefinition.json"}}). If you feel something is cached improperly use [this client unoptimized link instead](https://portal.azure.com/?clientOptimizations=false#blade/Microsoft_Azure_Compute/CreateMultiVmWizardBlade/internal_bladeCallId/anything/internal_bladeCallerParams/{"initialData":{},"providerConfig":{"createUiDefinition":"https%3A%2F%2Fraw.githubusercontent.com%2Frelution-io%2Fazure-marketplace%2Fmaster%2FcreateUiDefinition.json"}})


Disclaimer:
 
Relution is a product of [M-Way Solutions GmbH](http://www.mwaysolutions.com).
Server license will be automatically measured through a M-Way Solutions license service.


