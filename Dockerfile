ARG PYTHON
FROM python:${PYTHON}-slim-bullseye

ENV PATH="/root/.local/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -yq sssd \
    && apt-get -y upgrade

COPY sssd.conf /etc/sssd/sssd.conf

RUN sleep 1

RUN sssd

COPY nsswitch.conf /etc/nsswitch.conf

RUN sed -i '6iauth        sufficient    pam_sss.so use_first_pass' /etc/pam.d/common-auth

RUN sed -i '6iauth        sufficient    pam_sss.so use_first_pass' /etc/pam.d/common-auth

CMD ["sssd", "-i"]