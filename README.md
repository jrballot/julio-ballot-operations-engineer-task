# Operation Engineer Task
## Task

Provided are two simplified parts of the same application environment: A database dump and an API service. Your task is to automate setting up the development environment in a reliable and testable manner using "infrastructure as code" principles.

The goal is to end up with a limited set of commands that would install the different environments and run them using containers. You can use any software that you find suitable for the task. The code should come with instructions on how to run it and deploy it to arbitrary targets; whether it is deployed locally, towards physical machines, or towards virtual nodes in the cloud.

### Extra details
Provide the solution as a public git repository that can easily be cloned by our development team.

- The configuration file rates/config.py has some defaults that will most likely change depending on the solution. It would be beneficial to have a way of more dynamically pass in config values.

- List and describe the tool(s) used, and why they were chosen for the task.

- Provide any instructions needed to run the automation solution in README.md.

- If you have any questions, please don't hesitate to contact us at tech-recruitment@xeneta.com

## Solution

This is a solution for a container environment running a simple API using Python, Flask and PostgreSQL database. The tools used to build this environments are basically:

- AWS Services: AWS Fargate ECS, RDS PostgreSQL, AWS ABL, AWS ECR, Security Groups and VPC
- Terraform: Doing mainly the Infrastructure as Code parte of this job
- Shell Scripting: Script for loading data to AWS services

A diagram describing its layout can be seen in the following picture:

![Solution Layout](images/julio-ballot-practical-operations-task.png)

I decided to go with AWS services because in my point of view it allows me to only concern about the services and not the hardware or virtual machines running those services. Which, for me, makes a lot of sense when thinking about a cloud product in a tech company where my focus must be in the core aspect of my business and not the small parts related to running Linux systems and or installing a new webserver for a application or a classic relational database in a EC2 instances, in which I would need to concern mode about tuning and security than a service.

For a IaC tool I decided to go with Terraform, not because is the newest tool but because the quality compared to other tools like Ansible, which works fine and could also have done the same job, but when talking about interacting with Cloud Provider Hashicorp have being doing a better job. A mix could also be possible by reusing the te
rraform state to generate a ansible dynamic inventory, which for environments running EC2 instances is good idea, despite the fact that you could also use Packer and Cloud-Init for the same job. In conclusion, for a environment with not many services simple is better, and a single tool to handle it is what made me decide to use Terraform.

But even with Terraform I will have a problem, which is loading docker images and postgresql dump file to the respective services. For that I decide to call two separated shell scripts, one called build_push_docker_images.sh and another called load_postgres_dump.sh.

load_postgres_dump.sh:

'''SHELL
#!/bin/bash

DBHOST=$1
DBPORT=$2
DBUSERNAME=$3
DBPASSWORD=$4
DBDATABASE=$5

PSQL=$(which psql)

if [ -z $PSQL ]; then
  echo "ERROR: psql not found on your current path. "
  exit 1
fi

$PSQL  "postgresql://$DBUSERNAME:$DBPASSWORD@$DBHOST:$DBPORT" -c "drop database rates;"
$PSQL  "postgresql://$DBUSERNAME:$DBPASSWORD@$DBHOST:$DBPORT" -c "create database rates;"
$PSQL  "postgresql://$DBUSERNAME:$DBPASSWORD@$DBHOST:$DBPORT/rates" < db/rates.sql
'''

This script will receive all data needed to load the dump file via Terraform variables. It will run a simple check in the local system for psql binary and if it exists the dump will be loaded in the right database.

build_push_docker_images.sh:

'''SHELL
#!/bin/bash

ECRREPO=$1


cd rates/
docker build -t operations-task-image .
docker tag operations-task-image $ECRREPO:latest
aws ecr get-login-password  > docker-pass
docker login -u AWS $ECRREPO --password-stdin < docker-pass
docker push $ECRREPO:latest
rm docker-pass
'''

For loading docker image to the ECR service, I used a simple shell script to build, tag, logging to the service and push the image to the repository created by Terraform. One thing about the build processes was the use of **multi stage build** on Dockerfile.

'''
FROM python:3.6-alpine AS base

FROM base AS builder
WORKDIR /rates
ADD . /rates
RUN apk add py3-pip postgresql-dev gcc python3-dev musl-dev
RUN pip install -r requirements.txt --prefix=/install


FROM base
COPY --from=builder /install /usr/local/
WORKDIR /rates
ADD . /rates
RUN apk --no-cache add libpq
CMD ["gunicorn","-b",":3000","wsgi"]
'''

In this case I am using a temporary image to install all the dependencies, libs and pip packages needed by the rates application. The second build is the final one which will create the image, but only copying the binaries from the temporary image, which let me it a very small docker image.

## How to run it

To run this project some prerequisites needs to be solved. First you will need to have docker, aws cli and psql (postgresql-client) installed in your environment, and also Terraform.

**Installing AWS Cli**

'''
~$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
~$ unzip awscliv2.zip
~$ sudo ./aws/install
'''

**Installing Docker**
'''
$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
$ sudo apt-key fingerprint 0EBFCD88
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
'''

Do not forget about adding your user to the Docker group:

'''
~$ sudo usermod -aG docker <your_user>
'''

And check if it's running:

'''
~$ docker --version
'''

**Installing PostgreSQL Client**

'''
~$ sudo apt install -y postgresql
'''

**Installing Terraform**

'''
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt-get update && sudo apt-get install terraform
'''

Now that we have all that is needed to run this project lets understand its organization:

'''
.
├── bucket-state
│   ├── bucket-and-lock.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── variables.tf
├── db
│   └── rates.sql
├── images
│   └── julio-ballot-practical-operations-task.png
├── rates
│   ├── config.py
│   ├── Dockerfile
│   ├── docker-pass
│   ├── rates.py
│   ├── requirements.txt
│   └── wsgi.py
├── alb.tf
├── build_push_docker_image.sh
├── cloudwatch.tf
├── credentials
├── ecr.tf
├── ecs.tf
├── iam.tf
├── load_postgres_dump.sh
├── locals.tf
├── main.tf
├── operations-app.json.tpl
├── output.tf
├── rds.tf
├── README.md
├── security_group.tf
├── variables.tf
└── vpc.tf

'''

The directory is basicaly composed of four subdirectories: bucket-state,db,rates and image. Db and rates are the ones with the application provided, image is one used form to keep the images used in this documentation and the last one bucket-state is a terraform project to keep the tfstate of our project. So the bucket-state will create an S3 and DynamoDB services on AWS so that our main project could version its tfstate inside it and use it in the backend definicon on main.tf file. In this way we can work with team, having the tfstate and lock shared in one place, and if needed we could also use a terraform destroy without the  the limitations or risk of deleting the S3 keeping the state.

The rest of the files are self-explanatory, each file has the name of the service and terraform resource it is managing. The only one really important is the **credentials** files, which is not versioned for obvious reasons and will be used to keep our AWS credentials. Create it with the aws credentials of root account or one with the desirable permissions for using the services mentioned in this document.

'''
export AWS_ACCESS_KEY_ID=AKIAJQ656T4E2JEU4UGQ
export AWS_SECRET_ACCESS_KEY=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
'''

### Running it

To run this project start by first run the terraform init and apply inside bucket-state direcotory:

'''
cd bucket-state
terraform init
terraform apply
'''

When it finish creating the S3 and DynamoDB move one directory bellow and run terraform init and terraform apply again.

'''
cd ..
terraform init
terraform apply
'''

If everything runs nicely the output will show you the ALB DNS name that will be used for accessing the application:

![Terraform Output](images/tf-output.png)

By accessing the ALB DNS name on port 3000 you will be presented with the Hello World message.

![App Hello World](images/hello-world.png)

And by accesing the URI '''/rates?date_from=2016-01-01&date_to=2016-01-31&orig_code=CNGGZ&dest_code=EETLL''' you will be presented with the sample of the rates application API.

![App API Response](images/rates-api.png)
