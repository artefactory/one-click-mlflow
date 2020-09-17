FROM python:3.7

WORKDIR /mlflow/

RUN mkdir -p /mlflow/ \
  && apt-get update \
  && apt-get -y install --no-install-recommends apt-transport-https \
  ca-certificates gnupg default-libmysqlclient-dev libpq-dev build-essential curl

RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN gcloud components install beta -q

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY run_tracking.sh .
RUN chmod +x run_tracking.sh

CMD /mlflow/run_tracking.sh
