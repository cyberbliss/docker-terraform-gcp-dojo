FROM golang:1.14-buster

ENV TERRAFORM_VERSION=0.12.24
ENV TERRAFORM_SHA256SUM=602d2529aafdaa0f605c06adb7c72cfb585d8aa19b3f4d8d189b42589e27bf11
ENV DOJO_VERSION 0.8.0
ENV TINI_VERSION v0.19.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install common Dojo scripts
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo git ca-certificates wget make curl rsync jq gcc unzip && \
  git clone --depth 1 -b ${DOJO_VERSION} https://github.com/kudulab/dojo.git /tmp/dojo_git &&\
  /tmp/dojo_git/image_scripts/src/install.sh && \
  rm -r /tmp/dojo_git

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
  wget -O terraform_${TERRAFORM_VERSION}_SHA256SUMS https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS &&\
  cat terraform_${TERRAFORM_VERSION}_SHA256SUMS | grep linux_amd64 > mySHA256SUM.txt &&\
  sha256sum -c mySHA256SUM.txt &&\
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin &&\
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install plugins
ENV TF_PROVIDER_EXTERNAL_VERSION="1.2.0" \
  TF_PROVIDER_LOCAL_VERSION="1.4.0" \
  TF_PROVIDER_TEMPLATE_VERSION="2.1.2" \
  TF_PROVIDER_NULL_VERSION="2.1.2" \
  TF_PROVIDER_RANDOM_VERSION="2.2.1" \
  TF_PROVIDER_GOOGLE_VERSION="3.24.0" \
  TF_PROVIDER_GOOGLE_BETA_VERSION="3.24.0"
RUN mkdir -p /home/dojo/.terraform.d/plugins/linux_amd64 && cd /tmp &&\
  wget https://releases.hashicorp.com/terraform-provider-random/${TF_PROVIDER_RANDOM_VERSION}/terraform-provider-random_${TF_PROVIDER_RANDOM_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-random_${TF_PROVIDER_RANDOM_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-random_${TF_PROVIDER_RANDOM_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-random* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  mkdir -p /home/dojo/.terraform.d/plugins/linux_amd64 && cd /tmp &&\
  wget https://releases.hashicorp.com/terraform-provider-google/${TF_PROVIDER_GOOGLE_VERSION}/terraform-provider-google_${TF_PROVIDER_GOOGLE_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-google_${TF_PROVIDER_GOOGLE_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-google_${TF_PROVIDER_GOOGLE_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-google* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  mkdir -p /home/dojo/.terraform.d/plugins/linux_amd64 && cd /tmp &&\
  wget https://releases.hashicorp.com/terraform-provider-google-beta/${TF_PROVIDER_GOOGLE_BETA_VERSION}/terraform-provider-google-beta_${TF_PROVIDER_GOOGLE_BETA_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-google-beta_${TF_PROVIDER_GOOGLE_BETA_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-google-beta_${TF_PROVIDER_GOOGLE_BETA_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-google-beta* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  wget https://releases.hashicorp.com/terraform-provider-null/${TF_PROVIDER_NULL_VERSION}/terraform-provider-null_${TF_PROVIDER_NULL_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-null_${TF_PROVIDER_NULL_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-null_${TF_PROVIDER_NULL_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-null* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  wget https://releases.hashicorp.com/terraform-provider-external/${TF_PROVIDER_EXTERNAL_VERSION}/terraform-provider-external_${TF_PROVIDER_EXTERNAL_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-external_${TF_PROVIDER_EXTERNAL_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-external_${TF_PROVIDER_EXTERNAL_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-external* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  wget https://releases.hashicorp.com/terraform-provider-local/${TF_PROVIDER_LOCAL_VERSION}/terraform-provider-local_${TF_PROVIDER_LOCAL_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-local_${TF_PROVIDER_LOCAL_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-local_${TF_PROVIDER_LOCAL_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-local* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  wget https://releases.hashicorp.com/terraform-provider-template/${TF_PROVIDER_TEMPLATE_VERSION}/terraform-provider-template_${TF_PROVIDER_TEMPLATE_VERSION}_linux_amd64.zip &&\
  unzip terraform-provider-template_${TF_PROVIDER_TEMPLATE_VERSION}_linux_amd64.zip &&\
  rm terraform-provider-template_${TF_PROVIDER_TEMPLATE_VERSION}_linux_amd64.zip &&\
  mv terraform-provider-template* /home/dojo/.terraform.d/plugins/linux_amd64 &&\
  chown dojo:dojo -R /home/dojo/.terraform.d/

# install gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# pretty bash prompt
COPY bashrc /home/dojo/.bashrc
COPY profile /home/dojo/.profile
RUN chown dojo:dojo /home/dojo/.bashrc /home/dojo/.profile

COPY terraformrc /home/dojo/.terraformrc
RUN chown dojo:dojo /home/dojo/.terraformrc

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/
COPY inputrc /etc/inputrc

# Setup Go
RUN mkdir /home/dojo/go && chown dojo:dojo /home/dojo/go
ENV GOPATH=/home/dojo/go

ENTRYPOINT ["/tini", "-g", "--", "/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]
