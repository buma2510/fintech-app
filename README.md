# fintech-app
Secure CI/CD pipeline for a fintech app

 <img width="468" height="311" alt="image" src="https://github.com/user-attachments/assets/b2a454ae-82f7-44f8-a42d-e942f4104479" />

Secure Fintech CI/CD 

 

1.	Create IAM user granting necessary permissions and proceed to create ACCESS KEY 
Copy ACCESS KEY and SECRET ACCESS KEY  and store securely

 

2.	Log in to console as IAM user
Create EC2 instance – Ubuntu 22.04 and Instance type: t2.micro
Create Security group and key pair
Launch Instance

3.	Click on instance and click on Connect, to Connect to the instance by running the following commands in your terminal;
cd into the dir of the key file

chmod 400 "fintech-kp.pem"

ssh -i "fintech-kp.pem" ubuntu@ec2-18-134-146-41.eu-west-2.compute.amazonaws.com 
select yes when prompted. 

4.	Install pre-reqs / dependencies as in script.  (sudo apt upgrade -y ) after update

5.	Run aws configure and enter creds when prompted – specify region: us-west-2 or region of your choice. 

6.	Create directory fintech-app and create files. But files are already available so clone repo.

7.	Setup SonarCloud + Get Token
1. Go to: https://sonarcloud.io and sign in with GitHub creds
2. Click “+” → Create new project and select your Github Repo
3. Name the project <fintech-app> and choose Manual Config
4. SonarCloud gives you:    project key 
                                                        organization
                                                        sonar-project.properties template
5. Go to My Account → Security → Generate Tokens save as SONAR_TOKEN
6. In Github, Go to Settings → Secrets and variables → Actions → New repository secret and Add Name: SONAR_TOKEN, Value:<paste token>

8.	Install Git on EC2 and Authenticate with GitHub
sudo apt update
sudo apt install -y git

Generate Key ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
Press ENTER till private and public keys are generated.

Copy public key from return output of running  cat ~/.ssh/id_rsa.pub

Go to GitHub → Settings → SSH and GPG Keys → New SSH Key and paste the public key. Name it EC2_ACCESS_KEY

9.	 Clone the repo 
git clone <Repo-url>

10.	Create your ECR first via CLI or else the workflow will fail at docker push step
aws ecr create-repository \ 
    --repository-name fintech-app-repo \ 
   --region eu-west-2 
You will get an output in json format. 

11.	Copy the repository URI  and save in your GitHub  Repo secrets section. 
This keeps your workflow dynamic and environment aware. 
Use it in your GitHub Actions Workflow.

12.	Cd to terraform directory and run
terraform init
terraform plan
terraform validate 
terraform fmt
terraform apply -auto-approve.

   

This creates ECS Cluster & Service, Task definition, Cloudwatch Alarm, 
ECR Repo – copy URI output 

13.	Check and make sure all secrets are added in GitHub
SONAR_TOKEN
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
ECR_REPOSITORY_URI

 

14.	Push code to github main branch
git add .
git commit -m "Initial CI/CD + Infra"
git push origin main

 

15.	Watch CI/CD
Go to GitHub → Actions tab
watch CI: Sonar +Trivy
and CD Build -> Push -> ECS Deployment

 

16.	Monitor Deployment 
Visit ECS Console → Services → fintech-app-service
CloudWatch Alarms tab → CPU usage > 80% triggers alarm




Issues Faced
1.	Had to create an inline policy granting IAM user permissions to access S3 buckets. 

Key Points to note
1.	Terraform does not create the S3 bucket for the backend automatically. It expects the bucket to already exist so it can store and retrieve the state file from there. So you must create this manually before running terraform commands. 

2.	You also need to manually create a DynamoDB table named terraform-locks (or whatever name you used in your backend block) with the correct schema.
<img width="451" height="699" alt="image" src="https://github.com/user-attachments/assets/9ba9357e-5f1c-41cd-b384-d322f34846b8" />
