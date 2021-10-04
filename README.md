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

Initialize the Azure terraform configuration:
```
terraform -chdir=azure init
```

Apply terraform configuration:
```
terraform -chdir=azure apply
```

Enter `yes` at the prompt after review the plan.

Get info for the AKS cluster created (assuming defaults have not been changed):
```
az aks get-credentials -n shtest-test -g shtest-test-resource-group --overwrite-existing
```

Force kubectl/AD RBAC authentication:
````
kubectl get nodes
````
Copy link from terminal and paste in browser.  Paste code into web page.  Select account and then click Continue.  You should receive a message saying AKS AAD client application on your device.  Close the browser window.

If the command times out double check the default value for `TFVAR_api_authorized_ips`:
```
echo $TF_VAR_api_authorized_ips
```

Initialize the Kubernetes terraform configuration:
```
terraform -chdir=kubernetes init
```

Apply the kuberentes configuration:
```
terraform -chdir=kubernetes apply
```

Check the deploy:
curl http://$(kubectl get service/hello-world -n prod -o custom-columns=:.status.loadBalancer.ingress[0].ip | sed '/^$/d')

For Azure metrics go to portal and click on Home -> Resource Groups -> `shtest-test-resource-group` -> Metrics.  Select a scope of `shtest-test-resource-group`, select Kubernetes services from the Resource type drop down menu, select `shtest-test` from Kubernetes service dropdown menu, and click Apply.  Select your desired metric from the Metric dropdown menu.

Click on Alerts and check if the configured alert rule fired.  If not the rule can be seen under the Manage alert rule button at the top.

Log into Grafana with default dashboards and data collection:
```
kubectl port-forward  service/prometheus-stack-grafana 8080:80
```
Login with username and password: `admin`  `prom-operator`.

# Notes

A (bug)[https://github.com/hashicorp/terraform-provider-azurerm/pull/13493] in the azurerm provider requires that the version currently be locked to v2.78.0.

An additional bug was discovered working on the logging and alerting and the behaviour observed around log analytics work space was not always idempotent.

https://github.com/hashicorp/terraform-provider-azurerm/issues/13596

