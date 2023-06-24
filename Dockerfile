FROM debian:11.7-slim
# FROM ubuntu:jammy
# dockdock/libre_office_script_provider:debian-11.7-slim-1

ARG USER_ID=1000
ARG GROUP_ID=1000

# switch to root, let the entrypoint drop back
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        nano \
        curl \
        git \
        gnupg \
        jq \
        make \
        openssh-client \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        # python3-venv \
        # python3-virtualenv \
        unzip \
        wget \
        libreoffice-script-provider-python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN addgroup --gid $GROUP_ID dockdock
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID dockdock

RUN pip install virtualenv \
    && python3 -m pip install poetry \
    && python3 -m pip install black
    # && poetry config virtualenvs.in-project true

WORKDIR /root

COPY ./bashrc.txt .

RUN cat bashrc.txt >> .bashrc \
    && rm bashrc.txt \
    && git config --global alias.co checkout \
    && git config --global alias.br branch \
    && git config --global alias.ci commit \
    && git config --global alias.s status -s \
    && git config --global alias.type cat-file -t \
    && git config --global alias.dump cat-file -p

USER dockdock

WORKDIR /home/dockdock

# RUN python3 -m pip install --user pipx \
#     && python3 -m pipx ensurepath \
#     && python3 -m pipx install poetry



COPY ./bashrc.txt .

RUN cat bashrc.txt >> .bashrc \
    && rm bashrc.txt \
    && git config --global alias.co checkout \
    && git config --global alias.br branch \
    && git config --global alias.ci commit \
    && git config --global alias.s status \
    && git config --global alias.type cat-file -t \
    && git config --global alias.dump cat-file -p
