FROM continuumio/miniconda3:4.7.10

WORKDIR /mlflow/

ARG MLFLOW_VERSION=1.2.0
RUN mkdir -p /mlflow/ \
  && apt-get update \
  && apt-get -y install --no-install-recommends apt-transport-https ca-certificates gnupg default-libmysqlclient-dev libpq-dev build-essential curl \
  && pip install \
    mlflow==$MLFLOW_VERSION \
    sqlalchemy \
    boto3 \
    google-cloud-storage \
    psycopg2 \
    mysql \
    pymysql

EXPOSE 8080

RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN gcloud components install beta -q

COPY run_tracking.sh .
RUN chmod +x run_tracking.sh


CMD /mlflow/run_tracking.sh
