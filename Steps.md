## Create clusters

gcloud beta container \
    --project "emergya-digital-web" clusters create "emergya-digital" \
    --zone europe-west1-b \
    --node-locations europe-west1-b,europe-west1-c \
    --num-nodes 1 \
    --enable-autoscaling \
    --min-nodes 1 \
    --max-nodes 2 \
    --preemptible \
    --machine-type "n1-standard-1" \
    --disk-type "pd-standard" \
    --disk-size "50" \
    --tags=emergya-digital-node \
    --scopes "gke-default,storage-rw,cloud-platform,sql-admin" \
    --enable-autoupgrade \
    --enable-autorepair



## Download cluster credentials

gcloud container clusters get-credentials emergya-digital

## Descargar helm: https://github.com/helm/helm/releases

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
tar zxfv v2.11.0.tar.gz
cp linux-amd64/helm .

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

install traefik