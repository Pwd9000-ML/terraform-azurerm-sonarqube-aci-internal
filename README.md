[![Automated-Dependency-Tests-and-Release](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/actions/workflows/dependency-tests.yml/badge.svg)](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/actions/workflows/dependency-tests.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

# Module: VNET integrated Internal/Private SonarQube Azure Container Instance (+ Automatic SSL self signed certificate)

![image.png](https://raw.githubusercontent.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/master/assets/main.png)

## Description

Public Terraform Registry module for setting up an (internal VNET integrated) AZURE hosted Sonarqube ACI instance incl. persistent PaaS Database (Azure SQL), PaaS File Share (Azure Files) and custom domain using reverse proxy (Caddy) sidecar container.

See **[Examples](https://github.com/Pwd9000-ML/terraform-azurerm-sonarqube-aci-internal/tree/master/examples)** for usage.

This module is published on the **[Public Terraform Registry - sonarqube-aci-internal](https://registry.terraform.io/modules/Pwd9000-ML/sonarqube-aci-internal/azurerm/latest)**  
