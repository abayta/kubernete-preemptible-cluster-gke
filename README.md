Deploy kubernetes cluster with preemptible instances on GKE.

## Create clusters

Go to terraform folder: 
`cd terraform`

## Download cluster credentials

gcloud container clusters get-credentials cluster-name

## Descargar helm: https://github.com/helm/helm/releases (Update to current version)

```shell
latest=$(wget -qO- https://github.com/kubernetes/helm/releases | sed -n '/Latest release<\/a>/,$p' | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' |head -1)
wget https://storage.googleapis.com/kubernetes-helm/helm-$latest-linux-amd64.tar.gz
tar -zxvf helm-$latest-linux-amd64.tar.gz
mv linux-amd64 /helm /usr/local/bin/helm
sudo mv linux-amd64/helm /usr/local/bin/helm
```

## Add your user like cluster admin in the cluster's RBAC

kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value account)

## Grant Tiller, the server side of Helm, the cluster-admin role in your cluster:

kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

## init helm

./helm init --service-account=tiller
./helm repo update

## verify version

./helm version

------------------------------------------------------------------------------------------------------------------

## Jenkins 

./helm install -n cd-jenkins stable/jenkins -f jenkins/values.yml --namespace ci --wait

# values.yml para jenkins
#
# Master: NodePort
# 
# This is because after create Jenkins we will create a HTTP load balancer
# using an ingress and we will use this load balancer like the front to all
# our environments
#
## Apply ingress to have the entrypoints for the all environtments

kubectl apply -f ingress/ingress.yml

## 
## annotations:
##    kubernetes.io/ingress.global-static-ip-name: "cluster-name-ip"
## 
## Use this anotacion to used reserved IP
## 




