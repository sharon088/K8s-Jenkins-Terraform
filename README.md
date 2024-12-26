# Flask App with EKS, Jenkins Pipeline, and Docker

This project demonstrates a Flask application deployed on AWS EKS with Kubernetes, using Jenkins for CI/CD automation, and Docker for containerization. The infrastructure is provisioned using Terraform, and the application is built and deployed using Jenkins pipelines.


## Requirements

- **AWS CLI**: Set up your AWS credentials and CLI.
- **Terraform**: To provision infrastructure on AWS.
- **Docker**: To build and push Docker images.
- **Kubernetes**: To deploy the app on EKS.
- **Jenkins**: To automate the CI/CD pipeline.

## Setup

### 1. Set Up the Flask Application

The Flask app is located in the `/app` directory. It is a simple weather application that renders an HTML page.

- Install Python dependencies:
  ```bash
  pip install -r requirements.txt
  ```


### 2. Dockerize the Application
The project uses Docker to containerize the Flask app. The Dockerfile builds a multi-stage image for efficient deployment:
- Build the docker image:
  ```bash
  docker build -t my-flask-app .
  ```

- Run the Docker container:
  ```bash
  docker run -p 5000:5000 my-flask-app
  ```

### 3. Provision AWS EKS Cluster with Terraform
The terraform folder contains Terraform configurations to provision the AWS resources:
- Initialize Terraform:
  ```bash
  terraform init
  ```

- Apply Terraform Configurations:
  ```bash
  terraform apply
  ```
This will create an EKS cluster along with the necessary networking components.


### 4. Kubernetes Deployment
The manifests folder contains Kubernetes YAML files for deploying the Flask app on EKS:
- Deploy the application to EKS:
  ```bash
  kubectl apply -f manifests/deployment.yml
  kubectl apply -f manifests/service.yml
  kubectl apply -f manifests/ingress.yml
  ```

- Verify the deployment:
  ```bash
  kubectl get pods
  kubectl get services
  kubectl get ingress
  ```

### 5. Set Up Jenkins Pipeline
The Jenkins pipeline is defined in the Jenkinsfile in the /jenkins folder. This file automates the build, push, and deployment process.
- Create Jenkins Pipeline: Create a new Jenkins pipeline job and point it to your Git repository where this project is hosted.
- Configure Jenkins Credentials:
  - Add Docker Hub credentials to Jenkins as dockerhub.
  - Add your Kubernetes configuration as a Jenkins secret named kube_config.
- Run the Jenkins Pipeline: The pipeline will build the Docker image, push it to Docker Hub, update the Kubernetes deployment, and apply the new deployment to EKS.

## How the CI/CD Pipeline Works
- Build Docker Image: Jenkins builds the Docker image for the Flask app.
- Push Image to Docker Hub: The built image is pushed to Docker Hub.
- Update Kubernetes Deployment: The Kubernetes deployment manifest is updated with the new image.
- Deploy to Kubernetes: The new deployment is applied to the EKS cluster.

### Jenkins Pipeline Stages:
- Build the Docker image: Builds the Docker image from the Dockerfile.
- Push Docker image: Pushes the Docker image to Docker Hub with the build ID.
- Update Kubernetes Deployment: Updates the Kubernetes deployment manifest with the new image.
- Verify kubectl Connection: Verifies the connection to the Kubernetes cluster.
- Apply Deployment: Applies the new deployment and updates the application on EKS.

## Best Practices
### Flask Application
- Environment Variables: Store sensitive information like FLASK_APP in environment variables or use AWS Secrets Manager.
- Logging: Use proper logging with different log levels for debugging and monitoring.
- Production Settings: Avoid running Flask in debug mode in production. Use the FLASK_ENV variable to manage this.

### Terraform
- Modular Terraform Code: Break Terraform configurations into reusable modules.
- Remote State: Store the Terraform state in a remote backend (e.g., AWS S3) for collaboration and versioning.
- IAM Policies: Apply the principle of least privilege for IAM roles and policies.

### Kubernetes

- Readiness & Liveness Probes: Add readiness and liveness probes in the Kubernetes deployment to ensure the application is running properly.
- Secrets & ConfigMaps: Use Kubernetes Secrets for sensitive information (e.g., DB passwords) and ConfigMaps for non-sensitive configurations.
- Horizontal Pod Autoscaling: Implement Horizontal Pod Autoscaling (HPA) to scale pods automatically based on load.

### Jenkins

- Declarative Pipelines: Use declarative Jenkins pipelines for better readability and maintainability.
- Docker Layer Caching: Leverage Docker's layer caching to speed up builds.
- Secrets Management: Use Jenkins credentials to securely store sensitive data like Docker Hub credentials and Kubernetes config.

## Conclusion
This project demonstrates a full CI/CD pipeline for deploying a Flask app to AWS EKS using Terraform, Docker, and Jenkins. The setup follows best practices for scalability, security, and maintainability, making it suitable for real-world production environments.
