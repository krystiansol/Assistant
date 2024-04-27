#! /bin/bash
assistantGroup="assistantGroup"

create_group()
{
    az group create -l polandcentral -n $assistantGroup
}

delete_group(){
    az group delete -n $assistantGroup -y
}

create_deployment_service_principal(){
     az ad sp create-for-rbac --name "deployment" --role contributor --scopes /subscriptions/$1/resourceGroups/$assistantGroup --json-auth
}

setup()
{
    az appservice plan create --name assistantPlan --sku FREE --resource-group $assistantGroup --is-linux 
    az webapp create --resource-group $assistantGroup --plan assistantPlan --name ksmfassistant --runtime "DOTNETCORE:8.0"
}

destroy(){
    az webapp delete --name ksmfassistant --resource-group $assistantGroup
    az appservice plan delete --name assistantPlan --resource-group $assistantGroup
}

list_resources()
{
    az graph query -q "Resources | project name, type, location | order by name asc"
}

"$@"