# Terraform Load Balancer Template


<img alt="Terraform on Azure" src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="600px">

Prerequisite on linux: azure cli, terraform and git.<br>
Prerequisite on windows: azure cli, terraform, git and powershell/git-bash.<br>
Prerequisite on mac: brew, azure cli, terraform and git.<br>

## Follow the instructions below, 

### $ az login<br>
This will output:<br>
*To sign in, use a web browser to open the page https://aka.ms/devicelogin and enter the code cccccccc to authenticate.<br>
Follow above instructions and then it should also ask you to login to your azure account.<br>
Next will output the account info,<br>
[<br>
&nbsp;&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;"cloudName": "AzureCloud",<br>
&nbsp;&nbsp;&nbsp;&nbsp;"id": "xxxxxxxxxxxx",<br>
&nbsp;&nbsp;&nbsp;&nbsp;"isDefault": true,<br>
&nbsp;&nbsp;&nbsp;&nbsp;"name": "OPS-SDC-POC01",<br>
&nbsp;&nbsp;&nbsp;&nbsp;"state": "Enabled",<br>
&nbsp;&nbsp;&nbsp;&nbsp;"tenantId": "yyyyyyyyyyyyyyyyyyyyyy",<br>
&nbsp;&nbsp;&nbsp;&nbsp;"user": {<br>
&nbsp;&nbsp;&nbsp;&nbsp;"name": "john.doe@ontario.ca",<br>
&nbsp;&nbsp;&nbsp;&nbsp;"type": "user"<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;}<br>
]<br>
<br>
Grab the id (subscription id) and paste below,<br>
### $ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/xxxxxxxxxx"<br>
This will output below,<br>
Retrying role assignment creation: 1/36<br>
Retrying role assignment creation: 2/36<br>
{<br>
&nbsp;&nbsp;"appId": "aaaaaaaaaaaaaaaa",<br>
&nbsp;&nbsp;"displayName": "azure-cli-2018-02-12-18-49-01",<br>
&nbsp;&nbsp;"name": "http://azure-cli-2018-02-12-18-49-01",<br>
&nbsp;&nbsp;"password": "pppppppppppppppppppppp",<br>
&nbsp;&nbsp;"tenant": "yyyyyyyyyyyyyyyyyyyy"<br>
}<br>
<br>
Grab the appid, the password which is the clientsecret and the tenantid.<br>
Put it on the terraform.tfvars.<br>
subscriptid = "xxxxxxxxxxxxxxxxxxx"<br>
appid = "aaaaaaaaaaaaaaaaaa"<br>
clientsecret = "ppppppppppppppp"<br>
tenantid = "yyyyyyyyyyyyyyyyyyyyyy"<br>
location = "canadaeast"<br>
<br>
The terraform.tfvars can also be used by other templates, since you only need one credentials.  Usually you put it outside the folder of development/UAT/production
so that it easy to reference like ***"terraform apply --var-file=../terraform.tfvars"***.

First grab the reposity using git.<br>

### $ git clone http://gitlab-scm.52.235.39.185.nip.io/tso-mto-gitlab/terraform-lb.git<br>

It will create a directory terraform1/ and change directory to it.<br>
Update the ssh by copying your own ssh.

## $ cd terraform-lb<br>

Initialize the terraform, it will add a file .terraform on the folder,<br>
this add the plugins component necessary to be able to connect to  Azure Cloud.<br>

### $ terraform init<br>

Terraform plan inspect the syntax for terraform execution but it doesn't check Azure syntax, so you might find it that<br> 
although the "terraform plan" execute without error but when the "terraform apply" was executed, it will return an error like if you<br>
didn't put the proper vm images publisher or sku or offer.<br>

### $ terraform plan<br>


### $ terraform apply<br>

This will create terraform.tfstate which is very important not to touch it, inside it have all the json format what was executed on the terraform.<br> 
This is also important to backup this file and you can transfer it to another client.  If you have a template that you are not sure updated or sync,<br>
use the command ***"terraform apply -state=terraform.tfstate"*** to make sure it execute properly the current codes, otherwise it might remove or add resources you
don't want.<br>

<br>
---do your testing---<br>
<br>

This will destroy the whole resources group on the templates code including the resource region itself.<br>

### $ terraform destroy<br>
 
If you want updated template all the time and you want to just delet the vm, then remove the vm procedures on the template and run again<br> 
another "terraform appy".  It should destroy the vm only.  But if you want to delete a subnet and it is being used by the vm,<br> 
then you can't delete that subnet.  You should know the heirarchy of resources from top to bottom.<br>


The terraform will inspect the files with extension of tf.  If multiple files with *.tf found,<br>
terraform will compile it into one, and execute it according to the procedures found inside the template.<br>
So you can also organize your terraform files into main.tf, providers.tf, variables.tf and output.tf.<br>
But for this demo I make it simple with few files only.<br>
If you don't want to create a very large file and you want to extend your template,<br>
you can add another file like main2.tf and so on.<br>
Also on hierarchy to create procedures like it's always the resource group first on the template,<br> 
it doesn't matter with terraform but for clarity it should be added the one should be added first.<br>
<br>
When terraform execute. It start by login using the terraform.tfvars<br> 
and then execute all the files with the extension of tf and compile into one, it should start<br> 
to check if the azure resource group exist, if it exist, it should skip, if it doesn't exist then it will create it.<br>
it should go to the virtual network next, and so on.<br>
You can also just create a vm with only an azure resource group and a vm procedures,<br> 
it should create the other infrastructure automatically.<br>
But this is only good for terraform enterprise version and not always work most of the time on terraform opensource.<br>
<br>
### TIP<br>
Finding the image reference for vm like the publisher or offer or sku.  Is to research on the azure documentation which is<br> 
not updated most of the time, you will have errors that this sku is not offered on this local region storage or LRS.  The best solution<br>
is to get from the template of azure when pre creating the vm and don't submit it but click the template instead which is injson format.<br>
The json format will show all the information on the image publishe/offer/sku/etc.  And then you could put it on your terraform<br> 
template the right vm information.<br>

