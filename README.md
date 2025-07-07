# docker-keycloak-production
Production-ready Docker image for Keycloak with  automated realm import.

## Setting Application Insights in Azure App Service / Container Apps

Application Insights provides powerful monitoring and diagnostics capabilities, enabling you to track the health and performance of your Keycloak deployment in Azure environments.

1. Create an Application Insights resource in Azure.
2. Obtain the Instrumentation Key from the Application Insights resource.
3. Set the following environment variables in your Azure App Service / Container Apps configuration:
   - `APPLICATIONINSIGHTS_CONNECTION_STRING`: The connection string for your Application Insights resource.
   - `ENVIRONMENT`: The environment name (e.g., "production", "staging").
   - `DEPLOYMENT_NAME`: The name of the deployment (e.g., "keycloak").

## References
- [Keycloak](https://www.keycloak.org/)
- [構成オプション - Azure Monitor Application Insights for Java - Azure Monitor | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/java-standalone-config)
- [anderly/keycloak-azure-container-apps: A customized Keycloak docker container designed to run on Azure Container Apps.](https://github.com/anderly/keycloak-azure-container-apps) 
