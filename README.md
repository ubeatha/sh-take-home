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

Optional! Change the default value for the `api_authorized_ips` variable to secure the API server to be accessed from specific IP range(s):
```
export TF_VAR_api_authorized_ips=[\"$(curl -s ifconfig.me)/32\"]
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

If the command times out double check the default value for `TFVAR_api_authorized_ips`:
```
echo $TF_VAR_api_authorized_ips
```

You can unset the variable if necessary:
```
unset TF_VAR_api_authorized_ips
```