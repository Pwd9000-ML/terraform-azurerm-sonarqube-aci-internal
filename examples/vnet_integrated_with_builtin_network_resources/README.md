# SonarQube Internal/Private Azure Container Instance - Example 2

## VNET integrated deployment - networking resources deployed (Built-in)

In this example the virtual network prerequisites such as the VNET, subnets and private DNS zones are deployed as part of the same module. **Networking prerequisites** and the **SonarQube instance** is all built in one module by setting the parameter: `"var.create_networking_prereqs = true"`.  

See **[VNET integrated deployment - networking resources deployed separately](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_deploy_network_resources):**  
For an example of how to create the required **networking prerequisites** separately to the **SonarQube instance** by setting the parameter: `"var.create_networking_prereqs = false"`.  

See **[VNET integrated deployment - existing network resources](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_existing_network_resources):**  
For an example on how to create and integrate the SonarQube instance on existing network resources by setting the parameter: `"create_networking_prereqs = false"`.
