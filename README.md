# SH Take Home

Repository for SH take home.

# Requirements

The following utilities are required:
- [git](https://git-scm.com/downloads)
- [az cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) 
- [terraform](https://www.terraform.io/downloads.html)

# Process

Clone this repository:
```
git clone https://github.com/ubeatha/sh-take-home.git
```

Change directories into the repository
```
cd sh-take-home
```

Log into azure via the `az` cli:
```
az login
```

If necessary, select the correct subscription:
```
az account set --subscription "Azure subscription 1"
```

Optional: change the default value for the `api_authorized_ips` variable in the `variables.tf` file to secure the API server to be accessed from specific IP range(s):
```yaml
variable "api_authorized_ips" {
  description = "Restricts access to specified IP address ranges to access Kubernetes servers"
  type        = list(any)
  default     = ["your.ip.address.range1/mask"]
}
```

Initialize the terraform configuration:
```
terraform init
```

Apply terraform configuration:
```
terraform apply
```

Enter `yes` at the prompt after review the plan.

Get credentials for the AKS cluster created (assuming defaults have not been changed):
```
az aks get-credentials -n shtest-test -g shtest-test-resource-group
```

Confirm access to the cluster:
```
kubectl get nodes
```

If the command times out double check the default value for `api_authorized_ips` in the `variables.tf` file.

