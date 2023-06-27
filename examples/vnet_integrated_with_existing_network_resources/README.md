# Automated Test 3

This terraform module only creates the SonarQube instance and supporting resources. VNET integration is done on existing network resources.  
Networking prerequisites are not created and the module requires parameters for existing VNET/Subnets and private DNS zones to be integrated into.  

In this test the module is used to create + VNET integrate ONLY the SonarQube instance and supporting resources. The parameter for creating networking resources: `"create_networking_prereqs = false"`.  

See **[Automated Test 1](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/tests/auto_test1)** for an example on how to create the networking prerequisites as separate resources, or **[Automated Test 2](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/tests/auto_test2)** for an example of how to create the networking prerequisites and SonarQube instance in one module.  
