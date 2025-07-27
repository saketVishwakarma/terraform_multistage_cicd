# Terraform Azure Infrastructure with Modules, Workspaces, Key Vault, and GitHub Actions CI/CD

## 📌 Project Overview
This project demonstrates a **modular Terraform setup for Azure** that includes best practices such as:
- Separation of concerns with **modules** for reusable components (e.g., VM, Storage, Network, Key Vault)
- **Environment-specific configurations** using **Terraform workspaces**
- Usage of **Azure Key Vault for secrets management**
- **CI/CD automation with GitHub Actions** including manual approvals, plan artifacts, and notifications

---

## 🛠️ Why This Setup?
To simulate real-world cloud infrastructure deployment while learning or showcasing:
- Modular Terraform architecture
- Multi-environment (dev, stage, prod) management
- Secure secrets handling using Azure Key Vault
- Safe, auditable, and automated provisioning via GitHub CI/CD

---

## 📁 Project Structure
```
terraform_multistage/
├── modules/
│   ├── keyvault/
│   ├── virtualMachine/
│   ├── storage/
│   ├── database/
│   ├── network/
│   └── resource_group/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars (not committed)
│   │   └── dev.backend.tfvars
│   ├── stage/
│   └── prod/
└── .github/workflows/
    └── terraform_pipeline.yml
```

---

## 🔐 Azure Key Vault Integration
- Key Vault is created in the `keyvault` module
- Secret (e.g., DB password) is stored securely
- Other modules (like `database`) access it via `data.azurerm_key_vault_secret`
- Secrets are **not exposed in tfvars or state files**

### Sample Code:
```hcl
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.keyvault.id
}
```

---

## 🧪 Terraform Workspaces Explained
Each environment (dev, stage, prod) uses a **dedicated Terraform workspace**.
- Automatically selected in CI/CD pipeline
- Enables separate state management

```bash
terraform workspace select dev || terraform workspace new dev
```

This ensures infra changes for one env don't affect others.

---
---

## 🧪 Variable Validation Example

To avoid invalid values (e.g., for PostgreSQL SKU), we use Terraform's built-in validation block:

```hcl
variable "sku_name" {
  type        = string
  description = "Valid SKU name for PostgreSQL Flexible Server"

  validation {
    condition = contains([
      "Standard_B1ms",
      "Standard_B2ms",
      "Standard_D2s_v3",
      "Standard_D4s_v3",
      "Standard_E2s_v3"
    ], var.sku_name)

    error_message = "Invalid SKU name! Allowed values are: Standard_B1ms, Standard_B2ms, Standard_D2s_v3, Standard_D4s_v3, Standard_E2s_v3."
  }
}
```

This prevents misconfigurations by enforcing only valid options.

---

## 🔁 Lifecycle Rules

We used the `lifecycle` block to control Terraform's behavior during updates or deletes. Example:

```hcl
resource "azurerm_storage_account" "example" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}
```

- `prevent_destroy`: Protects critical resources from accidental deletion.
- `ignore_changes`: Avoids unnecessary updates due to tag drift.

---

## ⛓ depends_on Usage

We used `depends_on` to ensure one module/resource waits for another. Example:

```hcl
module "database" {
  source              = "../../modules/database"
  ...
  depends_on          = [module.vm]
}
```

This guarantees correct provisioning order, even across modules, especially when implicit dependencies don't exist.
---

## 🔄 CI/CD Pipeline with GitHub Actions

### ✅ Key Features:
- Trigger via manual dispatch (workflow_dispatch)
- Choose environment and destroy mode
- Auto-selects workspace based on input
- Runs `terraform fmt`, `validate`, `plan`
- Uploads `tfplan` file as artifact
- Requires **manual approval** before apply
- Supports **safe destroy** with `YES` confirmation
- Sends **Slack notifications** on destroy

### 🧩 Dynamic Variable Usage
Secrets and sensitive variables are **fetched via GitHub Secrets**, e.g.:
```yaml
-var="location=${{ secrets.TF_DEV_LOCATION }}"
```

### ✅ Security Practices
- `terraform.tfvars` is excluded from repo
- Sensitive values stored in GitHub Secrets / Azure Key Vault
- Manual approvals for destructive operations
- Slack alerts for visibility

### 🧾 Sample GitHub Workflow (simplified):
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice
        options: [dev, stage, prod]

jobs:
  plan:
    steps:
      - terraform init
      - terraform plan -out=tfplan
      - upload tfplan
  apply:
    needs: plan
    environment: terraform-${{ github.event.inputs.environment }}
    steps:
      - download tfplan
      - terraform apply tfplan
```

---

## 📣 Slack Notification Setup

To receive alerts in Slack when a destroy operation is triggered:

### 🔧 Step 1: Create a Slack Webhook
1. Go to your Slack Workspace
2. Visit: https://api.slack.com/apps → Create a new app
3. Add **Incoming Webhooks** feature
4. Enable it and generate a Webhook URL
5. Choose the channel you want notifications sent to
6. Copy the Webhook URL (e.g., `https://hooks.slack.com/services/...`)

### 🔧 Step 2: Add the Webhook to GitHub Secrets
- Go to your GitHub repo → Settings → Secrets and Variables → Actions
- Add new secret:
  - Name: `SLACK_WEBHOOK_URL`
  - Value: your Slack Webhook URL

### 🔧 Step 3: Use it in Your CI/CD Workflow
In the `terraform_pipeline.yml`, include this step after apply:
```yaml
- name: Notify on Destroy
  if: env.DESTROY_MODE == 'true'
  run: |
    curl -X POST ${{ secrets.SLACK_WEBHOOK_URL }}       -H 'Content-type: application/json'       --data "{
        "text": "🚨 *Terraform Destroy Alert*
Workspace: *$TF_WORKSPACE*
Actor: *${{ github.actor }}*
Repo: *${{ github.repository }}*
🔗 <https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}|View Run>",
        "username": "Terraform Bot",
        "icon_emoji": ":warning:"
      }"
```

You’ll now receive messages in your designated Slack channel for all destroy actions.

---

## 🧑‍💻 Azure Setup Instructions

### 1️⃣ Create a Service Principal
```bash
az login
az ad sp create-for-rbac --name "terraform-sp"   --role="Contributor"   --scopes="/subscriptions/<your-subscription-id>"   --sdk-auth
```
Copy the full JSON output and save in GitHub Secrets as `AZURE_CREDENTIALS`

### 2️⃣ Grant Key Vault Access
Assign `Key Vault Secrets User` role to the SP:
```bash
az keyvault set-policy --name <vault-name>   --spn <appId> --secret-permissions get list
```

---

## 📦 Using the Project

### ▶️ To Deploy Infrastructure:
1. Go to GitHub Actions → Select `Terraform Azure Pipeline`
2. Choose environment (`dev`, `stage`, `prod`)
3. Click **Run workflow**

### ❌ To Destroy Infrastructure:
1. Select `destroy: true`
2. Type `YES` in confirm_destroy


## 🔑 Required GitHub Secrets

To keep your configuration secure, store the following variables in your **GitHub Secrets** (`Settings → Secrets and variables → Actions`):

| Secret Name                          | Description                                    |
|-------------------------------------|------------------------------------------------|
| `AZURE_CREDENTIALS`                 | Azure service principal JSON                   |
| `TF_DEV_LOCATION`                   | Azure region for dev (e.g., eastus)            |
| `TF_DEV_ADMIN_USER`                 | Admin username for dev VMs                     |
| `TF_DEV_PUBLIC_KEY`                 | SSH public key content (not path)              |
| `TF_DEV_PRIVATE_KEY`                | SSH private key content (not path)             |
| `TF_STAGE_LOCATION`                | Azure region for stage                         |
| `TF_STAGE_ADMIN_USER`              | Admin user for stage                           |
| `TF_STAGE_PUBLIC_KEY`              | SSH public key for stage                       |
| `TF_STAGE_PRIVATE_KEY`             | SSH private key for stage                      |
| `TF_PROD_LOCATION`                 | Azure region for prod                          |
| `TF_PROD_ADMIN_USER`               | Admin user for prod                            |
| `TF_PROD_PUBLIC_KEY`               | SSH public key for prod                        |
| `TF_PROD_PRIVATE_KEY`              | SSH private key for prod                       |
| `SLACK_WEBHOOK_URL`                | Webhook URL to send Slack notifications        |

Make sure all required values are formatted correctly and stored securely.
---

## ✅ Summary of Key Concepts Used
| Concept            | Used In                           |
|--------------------|------------------------------------|
| Modules            | VM, Storage, Key Vault, DB         |
| Workspaces         | dev, stage, prod isolation         |
| Key Vault          | Secrets management                 |
| GitHub Actions     | CI/CD automation                   |
| Secrets            | GitHub + Azure Key Vault           |
| Manual Approval    | Safe Apply step                    |
| Destroy Safety     | Double confirm for destructive ops |
| Slack Notification | Destroy alerts in Slack channel    |

---

Made with ❤️ using Terraform and GitHub Actions to reflect real-world DevOps practices.