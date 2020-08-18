FROM bitnami/minideb:buster
LABEL maintainer "Sitepilot <support@sitepilot.io>"

# ----- Args ----- #

ARG USER_ID=1000
ARG USER_GID=1000
ARG USER_NAME=sitepilot

ENV USER_ID=$USER_ID
ENV USER_GID=$USER_GID
ENV USER_NAME=$USER_NAME

# ----- Common ----- #

RUN install_packages sudo ca-certificates nano

# ----- Caddy ----- #

RUN echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list

RUN install_packages caddy

# ----- User ----- #

RUN addgroup --gid "$USER_GID" "$USER_NAME" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "/opt/sitepilot" \
    --ingroup "$USER_NAME" \
    --no-create-home \
    --uid "$USER_ID" \
    "$USER_NAME" \
    && usermod -aG sudo $USER_NAME \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ----- Filesystem ----- #

COPY tags /

RUN chown -R sitepilot:sitepilot /opt/sitepilot

# ----- Config ----- #

WORKDIR /opt/sitepilot

EXPOSE 80 443

USER $USER_NAME

# ----- Checks ----- #

RUN caddy version

# ----- Entrypoint & CMD ----- #

ENTRYPOINT ["sudo", "--preserve-env", "/opt/sitepilot/scripts/entrypoint.sh"]

CMD ["sudo", "caddy", "run", "--config", "/opt/sitepilot/caddy/Caddyfile", "--adapter", "caddyfile"]
