# Flask Application Deployment Guide

This guide will walk you through the process of deploying and testing a Flask application on Kubernetes.

## Prerequisites

- Kubernetes cluster configured and accessible
- `kubectl` command-line tool installed and configured to interact with your Kubernetes cluster
- Docker installed on your local machine for building container images

## Deployment Steps

1. Clone the repository containing your Flask application code:

   ```bash
   git clone https://github.com/waeldalaous/app.git
   ```

2. Navigate to the directory containing your Flask application code:

   ```bash
   cd app/
   ```

3. Build the Docker image for your Flask application:

   ```bash
   docker build -t waeldalaous/app:v1 .
   ```

4. Push the Docker image to a container registry (if needed):

   ```bash
   docker push waeldalaous/app:v1
   ```

5. Deploy the Flask application to Kubernetes:

   ```bash
   kubectl apply -f manifests/deployment.yaml
   ```

6. Verify that the application pods are running:

   ```bash
   kubectl get pods
   ```

   Ensure that the status of your pods is `Running`.

7. Expose the application using a Kubernetes LoadBalancer Service:

   ```bash
   kubectl apply -f manifests/service.yaml
   ```

8. Get the external IP address to access the application:

   ```bash
   kubectl get svc
   ```

   Note down the external IP address.

9. Access the Flask application in a web browser using the provided IP address.


## Readiness & Liveness
In the deployment file, I have added a readiness and liveness probes.

### Liveness Probe
The `livenessProbe` configuration is used to determine whether the application is running properly. Kubernetes periodically sends requests to the specified endpoint to check the health of the application. If the application fails to respond within a specified time period or returns an error status code, Kubernetes restarts the container.

   ```yaml
      livenessProbe:
          httpGet:
            path: /health
            port: 5000
            scheme: HTTP
          initialDelaySeconds: 30 # Kubernetes will wait for 30 seconds before initiating the initial liveness probe after starting the container.
          periodSeconds: 5 #This interval defines how frequently Kubernetes checks the health of the application.
   ```

### Readiness Probe
The `readinessProbe` configuration is used to determine whether the application is ready to serve traffic. Kubernetes periodically sends requests to the specified endpoint to check the readiness of the application. If the application fails to respond within a specified time period or returns an error status code, Kubernetes will not route traffic to the container until it becomes ready.

   ```yaml
      readinessProbe:
          httpGet:
            path: /health
            port: 5000
            scheme: HTTP
          initialDelaySeconds: 30 # Kubernetes will wait for 30 seconds before initiating the initial liveness probe after starting the container.
          periodSeconds: 5 #This interval defines how frequently Kubernetes checks the health of the application.
   ```

## Self-Healing and Scaling
The Horizontal Pod Autoscaler (HPA) automatically adjusts the number of replicas of the application based on observed CPU or memory utilization (or other metrics) in the cluster. This allows the application to scale up or down dynamically to handle varying workloads.

1. Apply the HPA configuration to the cluster using:
   ```bash
   kubectl apply -f manifests/hpa.yaml
   ```
## Note
Before using Horizontal Pod Autoscaler (HPA), ensure that the Metrics Server is installed and running in your Kubernetes cluster.

### Configuration Details
In our case, the scale of the application is based on the CPU utilization.
   ```yaml
   averageUtilization: 50
   ``` 
This specifies the target average CPU utilization across all the pods in the Deployment. The HPA will adjust the number of replicas to try to maintain this target CPU utilization. Here, it's set to 50, meaning the HPA will aim for an average CPU utilization of 50% across all pods.

## Security Measures

To ensure the security of our application, we have implemented a Kubernetes Network Policy to control the traffic allowed to and from our application pods.
### Kubernetes Network Policy

A Network Policy is a Kubernetes resource that allows you to control the traffic flow at the network level. By defining rules within the Network Policy, we can restrict which pods can communicate with our application pods and which pods our application pods can communicate with.

Our Network Policy specifies:

- Ingress rules to control incoming traffic to our application pods.
- Egress rules to control outgoing traffic from our application pods.
- Rules to allow traffic only from trusted sources and to trusted destinations.

1. Apply the network security policy through:
   ```bash
   kubectl apply -f manifests/network-policy.yaml
   ```

