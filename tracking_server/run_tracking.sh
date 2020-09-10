GCP_PROJECT=$(curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
FUNCTION_REGION=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/region" -H "Metadata-Flavor: Google")

echo "/mlflow/cloud_sql_proxy -instances=${GCP_PROJECT}:${FUNCTION_REGION}:${INSTANCE}=tcp:3306 &"

/mlflow/cloud_sql_proxy -instances=${GCP_PROJECT}:${FUNCTION_REGION}:${INSTANCE}=tcp:3306 &

sleep 10

echo "Artifact Root is ${ARTIFACT_ROOT}"

DB_PASSWORD=$(gcloud beta secrets versions access 1 --secret="db_password")
BACKEND_URI=mysql+pymysql://root:${DB_PASSWORD}@127.0.0.1:3306/mlflow_store


mlflow db upgrade ${BACKEND_URI}

mlflow server \
  --backend-store-uri ${BACKEND_URI} \
  --default-artifact-root ${ARTIFACT_ROOT} \
  --host 0.0.0.0