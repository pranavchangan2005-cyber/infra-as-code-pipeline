# 🚀 Zero-Touch Deployment Pipeline

**Capstone Project 3 | DevOps Institute Mumbai, in association with IIT Patna**

An Infrastructure as Code and CI/CD project that automates Terraform validation, Docker image builds, Amazon ECR publishing, and application deployment to Amazon ECS using GitHub Actions.

## 📌 Project Overview

The goal of this project is to reduce manual deployment steps and demonstrate how cloud infrastructure and application releases can be automated using modern DevOps tools.

The pipeline is triggered when changes to the application, Terraform configuration, or workflow files are pushed to the `main` branch. It validates the Terraform configuration, builds a Docker image, pushes the image to Amazon ECR, updates the ECS task definition, and waits for the ECS service to become stable.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS VPC | Network isolation and connectivity |
| Amazon ECS with Fargate | Container deployment |
| Amazon ECR | Docker image registry |
| Application Load Balancer | Routes HTTP traffic to the application |
| AWS IAM | Permissions and access control |
| GitHub Actions | CI/CD automation |
| GitHub OIDC | Short-lived AWS authentication without long-lived access keys in GitHub |
| Docker | Application containerization |
| Node.js | Application runtime |
| Express.js | HTTP API and health endpoint |
| Amazon CloudWatch Logs | Application log collection |
| TFLint | Terraform linting |

## 🏗️ Architecture

```text
Developer
    |
    | Commit and push to main
    v
GitHub Repository
    |
    v
GitHub Actions Workflow
    |
    +--> Terraform Initialization
    |        |
    |        v
    |    Terraform Validation
    |        |
    |        v
    |      TFLint
    |
    v
AWS Authentication through OIDC
    |
    v
Build Docker Image
    |
    v
Push Image to Amazon ECR
    |
    v
Register Updated ECS Task Definition
    |
    v
Deploy to Amazon ECS Fargate
    |
    v
Wait for ECS Service Stability
    |
    v
Application Load Balancer
    |
    v
Live Node.js Application
```

Terraform manages the AWS infrastructure, while GitHub Actions automates the application deployment process.

## 📂 Repository Structure

```text
infra-as-code-pipeline/
├── .github/
│   └── workflows/
│       └── terraform-ci.yml
├── app/
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── terraform/
│   ├── bootstrap/
│   ├── modules/
│   │   ├── networking/
│   │   ├── security/
│   │   ├── compute/
│   │   └── monitoring/
│   └── environments/
│       ├── dev/
│       ├── staging/
│       └── production/
├── .tflint.hcl
└── README.md
```

## ⚙️ Application Features

The Express.js application exposes two endpoints.

### Main endpoint

`GET /`

Returns the application message, runtime status, and environment.

Example response:

```json
{
  "message": "Zero-Touch Deployment Successful - Version 2",
  "status": "running",
  "environment": "dev"
}
```

### Health endpoint

`GET /health`

Returns HTTP 200 when the application responds successfully.

```json
{
  "status": "healthy"
}
```

The health endpoint is useful for validating application availability and supporting health checks.

## 🔄 CI/CD Workflow

The GitHub Actions workflow contains two jobs.

### 1. Validate Terraform

- Checks out the repository.
- Installs Terraform.
- Initializes Terraform without accessing the remote backend.
- Validates the development environment configuration.
- Installs and runs TFLint.

### 2. Build, Push, and Deploy to ECS

For pushes to `main`, after validation succeeds, the deployment job:

1. Authenticates with AWS using GitHub OIDC.
2. Logs in to Amazon ECR.
3. Builds the Docker image.
4. Tags the image with the Git commit SHA.
5. Pushes the image to Amazon ECR.
6. Retrieves the current ECS task definition.
7. Updates the application container image.
8. Deploys the new task definition to the ECS service.
9. Waits for ECS service stability.

Using a commit SHA as the image tag makes it easier to identify which source revision produced a deployed image.

## ☁️ AWS Infrastructure

The development deployment uses the following AWS resources:

- VPC and public subnets.
- Security groups for the load balancer and ECS service.
- Application Load Balancer and listener.
- Amazon ECS cluster and Fargate service.
- Amazon ECR repository.
- ECS task definition and task execution IAM role.
- CloudWatch log group.
- S3 bucket for Terraform remote state.
- DynamoDB table for Terraform state locking.

The Terraform backend uses an S3 bucket for state storage and a DynamoDB table for state locking in the configured development setup.

**Important:** Confirm the configuration of each environment before describing dev, staging, and production as fully deployed. The presence of environment directories alone does not establish that all three environments are implemented and tested.

## 🔐 Security Practices

- GitHub Actions authenticates with AWS through OpenID Connect.
- The IAM role trust policy restricts access to the intended GitHub repository and `main` branch.
- The workflow uses the `id-token: write` permission for OIDC authentication.
- Docker images use commit-specific tags.
- Terraform state is stored remotely.
- Application and infrastructure configuration should be reviewed before production use.

Do not commit AWS access keys, private keys, passwords, tokens, or Terraform state files to the repository.

## 🚀 Setup and Deployment

### Prerequisites

- An AWS account with appropriate IAM permissions.
- Terraform installed.
- AWS CLI installed and configured for initial infrastructure provisioning.
- Docker installed.
- Git installed.
- A GitHub repository.
- An AWS IAM OIDC provider and deployment role configured for GitHub Actions.

### 1. Clone the repository

```bash
git clone https://github.com/pranavchangan2005-cyber/infra-as-code-pipeline.git
cd infra-as-code-pipeline
```

### 2. Configure AWS

Configure the AWS CLI for your development account and select the intended AWS region.

For this deployment, the region is `ap-south-1` (Mumbai).

### 3. Provision infrastructure

Review the Terraform configuration and required variables before applying it.

```bash
cd terraform/environments/dev
terraform init
terraform validate
terraform plan
```

Review the plan before applying any changes. Provisioning commands should only be run when the required variables, backend, IAM permissions, and infrastructure settings have been verified.

### 4. Configure GitHub Actions variables

In the repository, open **Settings → Secrets and variables → Actions → Variables**.

Configure these repository variables:

| Variable | Description |
|---|---|
| `AWS_REGION` | AWS deployment region |
| `AWS_ROLE_ARN` | ARN of the GitHub Actions deployment IAM role |

The AWS role trust policy must match the OIDC subject claim used by the repository.

### 5. Trigger the deployment

Make an application change, commit it, and push to `main`.

```bash
git add app/index.js
git commit -m "Update application response"
git push origin main
```

Open the repository's **Actions** tab and monitor the workflow until both jobs complete.

## 🧪 Testing and Verification

The following checks were performed during development:

- Terraform validation and TFLint passed in GitHub Actions.
- GitHub Actions successfully authenticated with AWS using OIDC.
- The Docker image was built and pushed to Amazon ECR.
- The ECS task definition was updated and the deployment completed.
- The application was accessible through the Application Load Balancer.
- The `/health` endpoint returned a healthy response.
- A new application message was pushed to `main` and appeared on the live application after automated deployment.

### Live Application

**Application URL:**  
http://infra-as-code-pipeline-alb-25432617.ap-south-1.elb.amazonaws.com

**Health endpoint:**  
http://infra-as-code-pipeline-alb-25432617.ap-south-1.elb.amazonaws.com/health

These endpoints depend on the AWS resources remaining deployed and available.

## 📈 Learning Outcomes

This project provided practical experience with:

- Infrastructure as Code using Terraform.
- AWS networking and security groups.
- Containerized application deployment.
- Amazon ECS, Fargate, and ECR.
- CI/CD workflow automation with GitHub Actions.
- Secure AWS authentication using OIDC.
- Terraform validation and linting.
- ECS task definition updates and deployment verification.
- Troubleshooting IAM trust policies and CI/CD authentication.

## 🔮 Future Improvements

Potential improvements for a more complete production-grade pipeline include:

- Independent, fully configured development, staging, and production environments.
- Pull request validation and staging deployment.
- Protected production deployments with manual approval.
- ECS autoscaling and CloudWatch alarms.
- Automated rollback testing and deployment recovery documentation.
- Additional application and infrastructure security scanning.
- Automated tests and deployment evidence.

These improvements should be marked complete only after implementation and verification.

## 👨‍💻 Author

**Pranav Changan**

- GitHub: https://github.com/pranavchangan2005-cyber
- LinkedIn: https://www.linkedin.com/in/pranav-changan-a608b13a5

## 🎓 Acknowledgement

DevOps Institute Mumbai, in association with IIT Patna.

---

*This project demonstrates a working automated application deployment pipeline using Terraform, GitHub Actions, Docker, and AWS ECS.*
