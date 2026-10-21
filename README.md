## Entra ID–Authenticated Azure P2S VPN

**Project Overview**  
Designed and deployed a secure Azure environment that enables authorised administrators to manage a virtual machine and authenticated remote users to access an internal web application over a Point-to-Site (P2S) VPN.

**Key Implementation Highlights**
- **Terraform & Remote State:** Configured an Azure Storage Account and Blob Container as a secure remote backend for Terraform state management.
- **Azure Network Architecture:** Deployed a Virtual Network (VNet) and dedicated subnets for the application VM, Azure Bastion, and VPN Gateway.
- **Secure Remote Connectivity:** Configured an Azure VPN Gateway with P2S connectivity and Microsoft Entra ID authentication.
- **Identity & Access Management:** Created users and groups, applied role-based access control (RBAC), and restricted VPN and VM administration privileges to authorised identities.
- **Secure VM Administration:** Used Azure Bastion with Microsoft Entra ID authentication for SSH-based VM management, avoiding direct public SSH exposure.
- **Secrets Management:** Stored SSH-related secrets in Azure Key Vault and controlled access through RBAC.
- **Monitoring & Diagnostics:** Configured Virtual Network diagnostics to send logs to an existing Log Analytics workspace.
- **Application Access:** Enabled authorised remote users to reach the internal web application through the P2S VPN.

**Architecture Decision & Trade-offs**  
Selected Azure Bastion and Microsoft Entra ID authentication to provide centralised, identity-based administrative access for multiple administrators who connect occasionally. Although this approach increases infrastructure costs compared with simpler SSH access methods, it prioritises security, access control, and ease of administration.

**Technologies:** Microsoft Azure | Terraform | Azure VPN Gateway | Point-to-Site VPN | Microsoft Entra ID | Azure Bastion | Azure Key Vault | Azure RBAC | Log Analytics
