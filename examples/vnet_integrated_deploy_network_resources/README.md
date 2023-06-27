# SonarQube Internal/Private Azure Container Instance - Example 1

## VNET integrated deployment - networking resources deployed separately

In this example virtual network prerequisites such as the VNET, subnets and private DNS zones are deployed as separate Terraform resources for use with a **VNET integrated Azure Container Instance** to run **SonarQube** inside of an internal/private Azure network using a self signed certificate (using a **Caddy sidecar container**) that can be peered to other networks in the organisation to utilise SonarQube inside of the organisation privately.  

Networking prerequisites are created separately to allow for reuse of the networking resources, and then the SonarQube instance is created using the module.  

See **[VNET integrated deployment - networking resources deployed (Built-in)](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_builtin_network_resources):**  
For an example of how to create the required **networking prerequisites** and **SonarQube instance** in one module by setting the parameter: `"var.create_networking_prereqs = true"`.  

See **[VNET integrated deployment - existing network resources](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples/vnet_integrated_with_existing_network_resources):**  
For an example on how to create and integrate the SonarQube instance on existing network resources by setting the parameter: `"var.create_networking_prereqs = false"`.
