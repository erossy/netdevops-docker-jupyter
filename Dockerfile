ARG PYTHON
FROM python:${PYTHON}-slim-bullseye

ENV PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -yq curl git pandoc make vim wget npm nodejs libpam-sss \
    && apt-get -y upgrade \
    && npm install -g configurable-http-proxy

RUN sed -i 's/\(^passwd.*\)/\1 sss/g' /etc/nsswitch.conf \
    && sed -i 's/\(^group.*\)/\1 sss/g' /etc/nsswitch.conf 

RUN pam-auth-update --enable sss

RUN useradd -u 111 -m netdevops && echo netdevops:netdevops | chpasswd

WORKDIR /home/netdevops

COPY --chown=netdevops:netdevops requirements.txt requirements.txt

COPY --chown=netdevops:netdevops jupyterhub_config.py jupyterhub_config.py

COPY --chown=netdevops:netdevops create-user.py create-user.py

USER netdevops:netdevops

RUN pip3 install --user --no-cache-dir -r requirements.txt

ENV PATH="/home/netdevops/.local/bin:${PATH}"

CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000", "--no-ssl"]
