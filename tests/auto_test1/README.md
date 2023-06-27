# Automated Test 1

This terraform module test creates virtual network prerequisites with subnets and private DNS zones setup for use with SonarQube.  
Networking prerequisites are created as separate resources to the SonarQube instance to allow for reuse of the networking resources.  
In this test the module is used to create the networking prerequisites for SonarQube as separate resources and then the SonarQube instance is created using the module.  

See **[Automated Test 2](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/tests/auto_test2)** for an example on how to create the networking prerequisites and SonarQube instance in one module by setting the parameter: `"create_networking_prereqs = true"`.
