FROM nginx:1.11

MAINTAINER Valerii Savchenko <wellic72@gmail.com>

ARG DOCKER_GROUP_ID
ARG DOCKER_GROUP_NAME
ARG DOCKER_USER_ID
ARG DOCKER_USER_NAME

USER 0

RUN groupadd --gid ${DOCKER_GROUP_ID} ${DOCKER_GROUP_NAME}
RUN useradd  --gid ${DOCKER_GROUP_ID} --uid ${DOCKER_USER_ID} --create-home --shell /bin/bash ${DOCKER_USER_NAME}
RUN usermod --append --groups sudo ${DOCKER_USER_NAME}
RUN mkdir -p /etc/sudoers.d
RUN echo "${DOCKER_USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${DOCKER_USER_NAME}
RUN chmod 400 /etc/sudoers.d/${DOCKER_USER_NAME}

