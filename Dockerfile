ARG PYTHON
FROM python:${PYTHON}-slim-bullseye

ENV PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -yq curl git pandoc make vim wget npm nodejs \
    && apt-get -y upgrade \
    && curl -sSL https://install.python-poetry.org | python \
    && poetry config virtualenvs.create false \
    && npm install -g configurable-http-proxy

RUN useradd -u 111 -m netdevops

WORKDIR /home/netdevops

COPY --chown=netdevops:netdevops requirements.txt requirements.txt

ADD jupyterhub_config.py /home/netdevops/jupyterhub_config.py

ADD create-user.py /home/netdevops/create-user.py

USER netdevops:netdevops

RUN pip3 install --user --no-cache-dir -r requirements.txt

ENV PATH="/home/netdevops/.local/bin:${PATH}"

WORKDIR /opt/netdevops

CMD ["jupyterhub", "--ip=0.0.0.0", "--port=8000", "--no-ssl"]
