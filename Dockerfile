FROM alpine:latest

ENV SUMMARY="Official Alpine Docker image using OpenShift specific guidelines." \
    DESCRIPTION="Alpine Linux is a security-oriented, lightweight Linux distribution based on musl libc and busybox."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
### Required labels above - recommended below
      url="https://github.com/ilfkrylov/openshift-utils" \
      help="For more information visit https://github.com/ilfkrylov/openshift-utils" \
      run='docker run -itd --name ubuntu -u default openshift-utils' \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="${SUMMARY}" \
      io.openshift.expose-services="" \
      io.openshift.tags="alpine,starter-arbitrary-uid,starter,arbitrary,uid"

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
ENV PATH=/usr/local/bin:${APP_ROOT}/.local/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ /usr/local/bin/
RUN mkdir -p ${APP_ROOT} && \
    chmod -R u+x /usr/local/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Install utils
RUN apk update
RUN apk add busybox-extras
RUN apk add netcat-openbsd

### Containers should NOT run as root as a good practice
USER 10001
WORKDIR ${APP_ROOT}

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
ENTRYPOINT [ "uid_entrypoint" ]
# VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data
CMD run

# ref: https://github.com/RHsyseng/container-rhel-examples/blob/master/starter-arbitrary-uid/Dockerfile.centos7
# ref: https://github.com/jefferyb/openshift-base-images
