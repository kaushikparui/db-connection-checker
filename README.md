# 🚀 Node.js Docker App with EC2 Deployment via CodePipeline

This repository contains a simple Node.js application that runs inside a Docker container. It is deployed to an Amazon EC2 instance using **AWS CodePipeline**, **CodeBuild**, and **CodeDeploy**.

The application:
- Fetches database credentials from **AWS Secrets Manager**
- Tests the database connection
- Displays the result over **HTTP on port 80**

---

## 📁 Project Structure

| File/Dir              | Purpose                                                    |
|-----------------------|------------------------------------------------------------|
| `server.js`           | Main Node.js server code                                   |
| `Dockerfile`          | Defines container image with Node.js app                  |
| `buildspec.yaml`      | Build instructions for AWS CodeBuild                      |
| `appspec.yaml`        | Deployment instructions for AWS CodeDeploy (EC2)          |
| `scripts/deploy.sh`   | Script to pull Docker image and run the container on EC2  |
