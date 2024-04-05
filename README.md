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


## Scalabilty and self-healing
In the deployment file, I have added a readiness and liveness probes.

### Liveness Probe
The `livenessProbe` configuration is used to determine whether the application is running properly. Kubernetes periodically sends requests to the specified endpoint to check the health of the application. If the application fails to respond within a specified time period or returns an error status code, Kubernetes restarts the container.

   ```yaml
      livenessProbe:
          httpGet:
            path: /health
            port: 5000
            scheme: HTTP
          initialDelaySeconds: 30
          periodSeconds: 5
   ```
Kubernetes should wait 30 seconds before performing the first liveness probe (initialDelaySeconds: 30)
## Cleanup

1. To clean up the resources created during deployment, you can delete the Kubernetes deployment and service:

   ```bash
   kubectl delete -f deployment.yaml
   kubectl delete -f service.yaml
   ```

   Replace `deployment.yaml` and `service.yaml` with the names of your Kubernetes configuration files.

2. Optionally, delete the Docker image from your container registry to free up storage space:

   ```bash
   docker rmi your-registry/your-app-image:tag
   ```

   Replace `your-registry/your-app-image:tag` with the name and tag of your Docker image.

## Additional Notes

- Customize the Kubernetes deployment and service configuration files according to your application's requirements.
  
- Ensure that your Flask application exposes the necessary endpoints for accessing its functionality.

- Monitor your application's logs and metrics using Kubernetes tools or external monitoring solutions to ensure its health and performance.

```

Feel free to replace `<repository_url>`, `<repository_directory>`, `your-app-image`, `your-registry`, `tag`, `deployment.yaml`, `service.yaml`, and any other placeholders with the actual values corresponding to your application and deployment configuration. Additionally, customize the additional notes section with any specific instructions or considerations relevant to your deployment.
