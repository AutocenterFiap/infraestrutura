resource "kubectl_manifest" "deployment" {
  depends_on       = [kubectl_manifest.namespace]
  wait_for_rollout = false
  yaml_body        = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
YAML
}