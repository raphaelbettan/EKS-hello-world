# EKS Cluster with Hello World Application

This project sets up an Amazon EKS cluster and deploys a simple "Hello World" application using Terraform and Helm. It implements multi-tenancy and includes basic monitoring with Prometheus and Grafana.

## Prerequisites

- AWS CLI configured with appropriate credentials (Sandbox-user-1A)
- Terraform (version 1.9.0 or later)
- kubectl
- helm

## Directory Structure

```txt
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── modules
│   ├── vpc
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── security_groups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lb_controller
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── hello_world_app
│   │   ├── main.tf
│   │   └── variables.tf
│   └── monitoring
│       ├── main.tf
│       └── variables.tf
└── hello-world
    ├── Chart.yaml
    ├── values.yaml
    └── templates
        ├── deployment.yaml
        ├── service.yaml
        ├── ingress.yaml
        └── _helpers.tpl
```

## Setup Instructions

1. Clone this repository:

   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Initialize Terraform:

   ```sh
   terraform init
   ```

3. Review and modify the `variables.tf` file to set your desired values, particularly:
   - `cluster_name`
   - `region`
   - `vpc_cidr`

4. Plan the Terraform configuration:

   ```sh
   terraform plan -out terraform.plan
   ```

5. Apply the Terraform configuration:

   ```sh
   terraform apply
   ```

6. After the apply is complete, configure kubectl to interact with your new EKS cluster:

   ```sh
   aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
   ```

7. Verify that the applications are running:

   ```sh
   kubectl get pods -A
   ```

8. Get the ALB DNS name:

   ```sh
   kubectl get ingress -A
   ```

9. Open the ALB DNS name in a web browser to see the "Hello World" application.

## Solution Explanation

This solution uses Terraform to provision the following resources:

1. A VPC with public and private subnets across two availability zones.
2. An EKS cluster with worker nodes in the private subnets.
3. Security groups to allow necessary traffic.
4. The AWS Load Balancer Controller, which manages the ALB for ingress.
5. A Helm release of the "Hello World" application, deployed to multiple namespaces for multi-tenancy.
6. Prometheus and Grafana for basic monitoring.

The "Hello World" application is a simple web server running on port 8000, deployed using a custom Helm chart. The chart includes a deployment, a service, and an ingress resource.

The ALB Ingress Controller creates an Application Load Balancer based on the ingress resource, allowing external access to the application.

Multi-tenancy is implemented by deploying the application to multiple namespaces (team-a, team-b, team-c).

Basic monitoring is set up using Prometheus for metrics collection and Grafana for visualization.

## Accessing Grafana

To access Grafana:

1. Get the Grafana service external IP:

   ```sh
   kubectl get svc -n monitoring grafana
   ```

2. Use the external IP to access Grafana in your web browser.

3. Login with the default credentials (admin/admin) and change the password when prompted.

4. Configure Prometheus as a data source and create dashboards as needed.

## Cleanup

To delete all resources created by this project:

```sh
terraform destroy
```

Note: This will delete all resources, including the EKS cluster and any deployed applications.

## Customization

You can customize the deployment by modifying the following:

- Terraform variables in `variables.tf`
- Helm chart values in `modules/hello_world_app/main.tf`
- Helm chart templates in the `hello-world` directory
- Monitoring configuration in `modules/monitoring/main.tf`

## Troubleshooting

If you encounter issues:

1. Ensure your AWS CLI is configured correctly.
2. Check the Terraform output for any error messages.
3. Use `kubectl` to check the status of pods, services, and ingress resources.
4. Review the AWS EKS and EC2 console for any visible issues.
5. Check Prometheus and Grafana logs for monitoring-related issues.

For further assistance, please open an issue in the repository.

IF Modules not working,
then run below commands:

- `hello-world (Multi Tenant)`:

  ```sh
  helm package hello-world
  helm install hello-world ./hello-world-0.1.0.tgz --namespace team-a
  helm install hello-world ./hello-world-0.1.0.tgz --namespace team-b
  ```

- `monitoring (Prometheus)`:

  ```sh
  helm install prometheus prometheus-community/prometheus -n monitoring
  ```

- `monitoring (Grafana)`:

  ```sh
  helm install grafana grafana/grafana -n monitoring --set persistence.enabled=false --set service.type=NodePort --set service.nodePort=30000
  kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
  export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace monitoring port-forward $POD_NAME 3000
  ```

access Grafana: <http://localhost:3000/login>
