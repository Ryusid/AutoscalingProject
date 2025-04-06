# Kubernetes Project - Automated Deployment with Minikube, Kubernetes, Prometheus, and Grafana

This project uses **Minikube**, **Kubernetes**, **Prometheus**, **Grafana**, and other tools to deploy a backend and frontend application with monitoring and autoscaling.

## Prerequisites

Before running the script, ensure the following are installed and configured:

1. **Minikube**: Used to create a local Kubernetes cluster.
2. **Kubernetes (kubectl)**: Kubernetes command-line tool to manage your cluster.
3. **Helm**: Used to install the Prometheus and Grafana stack from the Helm repository.

### User Permissions

- If you're using **Minikube** with the Docker driver, make sure your user is part of the `docker` group. This can be done using the command:

```bash
sudo usermod -ag docker <user> && newgrp docker
```

Replace `<user>` with your actual username.

- Ensure you have the required permissions to install packages if needed (Helm will be downloaded in the script, so you must be able to execute the necessary package installations).

## Files Included

- `automation-script.sh`: The shell script that automates the entire deployment process.
- `Redis-master.yml`, `Redis-replicas.yml`, `BackendDep.yml`, `ReactDep.yml`, `Service-monitoring.yml`: Kubernetes YAML files for the various deployments and configurations.
- `projet-grafana-dashboard.json`: The JSON file used to import the Grafana dashboard.

## Step-by-Step Guide

1. **Prepare Your Environment**:

 - Install **Minikube**, **kubectl**, and **Helm**.
 - Make sure you have **Docker** installed if you plan to use the Docker driver for Minikube.

2. **Running the Automation Script**:

 Once your environment is set up, you can execute the script. This will automatically:

 - Start **Minikube** (if not already started).
 - Enable the **metrics-server**.
 - Deploy the Redis master and replicas, backend, and frontend React app.
 - Set up **autoscaling** for both Redis and backend deployments.
 - Install the **Prometheus and Grafana** stack using Helm.
 - Expose **Grafana** and **Prometheus** via `NodePort`.
 - Import a pre-configured **Grafana dashboard**.
 
 Ensure you execute the script with the following command:

```bash
./automation-script.sh
```

3. **Accessing the Services**:

After running the script, the services will be exposed and you can access them via:

- **Frontend React App**: Access it at `http://192.168.49.2:30002` (local Minikube address).
- **Grafana Dashboard**: Access it at `http://192.168.49.2:30000` (local Minikube address).
  - Login using `admin` as the username and `prom-operator` as the password.
- **Prometheus**: Access it at `http://192.168.49.2:30090` (local Minikube address).

4. **Testing and Autoscaling**:

- To simulate load on the backend, run the following command in a terminal:
  ```
  while true; do curl 192.168.49.2:30001; done
  ```
- In another terminal, monitor the pods with:
  ```
  kubectl get pods -w
  ```
- You can also monitor the **Grafana dashboard** for autoscaling data or use the Minikube dashboard.

5. **Grafana Dashboard**:

After importing the dashboard JSON file (`projet-grafana-dashboard.json`), the dashboard will display:
- Active resources per pod
- Number of total requests received per pod
- Duration of HTTP requests in seconds per pod
- Active resources per type

You can monitor these metrics in real-time using Grafana.

6. **Modifications**:

- If Minikube is already running or you're using a different driver, you might need to modify the script accordingly. For example, remove the `minikube start` command if Minikube is already running.

7. **Important Notes**:

- The script assumes **kubectl**, **Minikube**, and **Helm** are already installed and accessible.
- The script also assumes you have the necessary permissions to install Helm charts and deploy resources in Kubernetes.

---

## Conclusion

This script automates the entire process of deploying an application with autoscaling, monitoring with Prometheus and Grafana, and setting up an environment using Minikube and Kubernetes. You can easily customize it to fit specific requirements or environments.

For further questions or customizations, refer to the Kubernetes, Helm, Prometheus, and Grafana documentation.
