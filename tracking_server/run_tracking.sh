#!/bin/bash
# GNU Lesser General Public License v3.0 only
# Copyright (C) 2020 Artefact
# licence-information@artefact.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DB_PASSWORD=$(gcloud beta secrets versions access --project=${GCP_PROJECT} --secret=${DB_PASSWORD_NAME} latest)
BACKEND_URI=mysql+pymysql://${DB_USERNAME}:${DB_PASSWORD}@${DB_PRIVATE_IP}:3306/${DB_NAME}

mlflow db upgrade ${BACKEND_URI}

mlflow server \
  --backend-store-uri ${BACKEND_URI} \
  --default-artifact-root ${GCS_BACKEND} \
  --host 0.0.0.0 \
  --port ${PORT}
