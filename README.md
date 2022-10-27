# aws-web

Author: Theuns Steyn

Prerequisites: terraform 14

To set this all up:

Setup a container regsitry
--------------------------
Run the following commands from the ./terraform/bootstrap directory:
#> terraform init
#> terraform apply
get the repo_url and set it in ./deploy/deploy.sh

Build the docker container and push it to ECR
---------------------------------------------
Be sure to update the ECR repo url in ./deploy/deploy.sh
Run deploy.sh

Create the AWS resources:
-------------------------
Run the following commands from the ./terraform directory:
#> terraform init
#> terraform apply

Browse to the url given as output