ARG PYTHON
FROM python:${PYTHON}-slim-bullseye

ENV PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -yq sssd \
    && apt-get -y upgrade

COPY sssd.conf /etc/sssd/sssd.conf

COPY nsswitch.conf /etc/nsswitch.conf

RUN chmod 600 /etc/sssd/sssd.conf

RUN mkdir -p /var/lib/sss/db

RUN mkdir -p /var/lib/sss/pipes/private

RUN mkdir -p /var/lib/sss/mc

RUN sssd

RUN useradd -u 111 -m netdevops && echo netdevops:netdevops | chpasswd

WORKDIR /home/netdevops

USER netdevops:netdevops

ENV PATH="/home/netdevops/.local/bin:${PATH}"

WORKDIR /opt/netdevops

CMD [/bin/sh]