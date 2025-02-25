# GNU Lesser General Public License v3.0 only
# Copyright (C) 2025 Artefact
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
FROM google/cloud-sdk:511.0.0


# Install Python 3.11
# Install necessary packages and add backports repository
RUN apt-get update && apt-get install -y software-properties-common \
  && echo "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main" >> /etc/apt/sources.list.d/backports.list \
  && apt-get update \
  && apt-get install -y -t $(lsb_release -cs)-backports python3.11 python3.11-venv python3.11-dev python3-pip \
  && ln -s /usr/bin/python3.11 /usr/bin/python

# Clean up to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Explicitly allow release info change to avoid errors
RUN apt-get update --allow-releaseinfo-change --fix-missing\
  && apt-get -y install --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  gnupg \
  default-libmysqlclient-dev \
  libpq-dev \
  build-essential \
  curl \
  pkg-config

WORKDIR /mlflow/

# Ensure subsequent commands use the virtual environment
RUN python -m venv /env 
ENV PATH="/env/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip 
RUN pip install -r requirements.txt


COPY run_tracking.sh .
RUN chmod +x run_tracking.sh

CMD /mlflow/run_tracking.sh
