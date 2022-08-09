# Repository for IaC in Terraform

This repo contains all the terraform files to deploy an AKS cluster with the following services installed via Helm Charts:
  1. Ingress-nginx
  2. External-DNS (using Cloudflare Provider)
  3. Cert-Manager (using Let's Encrypt)

This helps deploy the [server](https://github.com/DevsuAssesment-AMacedoP/server) microservice providing an HTTPS endpoint for the requests.