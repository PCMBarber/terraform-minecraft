# terraform-minecraft

Download a Forge.jar and host it on a direct download link website - (change install.sh to reflect)
line 5 and line 15, the version that is unpacked from the installer.jar depends on version provided

https://files.minecraftforge.net/net/minecraftforge/forge/

Create new Role on aws with EC2 full access, name it "minecraft"

Create a new snapshot with 'MINECRAFT_SNAPSHOT' as the description, use ubuntu20.04LTS

On the machine you are running the terraform from create two new environment variables.

`TF_VAR_access_key`

`TF_VAR_secret_key`

The IAM role the access key and secret key relate to should have access to EC2 VPC and Subnets fully at least.

terraform init
terraform apply

After initial apply and destroy, server will self persist.
To relaunch the server with the same state when destroyed simply init and apply again.
