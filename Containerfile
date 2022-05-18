FROM public.ecr.aws/amazonlinux/amazonlinux:2022

ENV NAME=amznlinux2022-toolbox VERSION=2022
LABEL com.github.containers.toolbox="true" \
  com.github.debarshiray.toolbox="true" \
  name="$NAME" \
  version="$VERSION" \
  usage="This image is meant to be used with the toolbox command" \
  summary="Base image for creating Amazon Linux 2022 toolbox containers"

COPY README.md /

RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

COPY packages /
RUN dnf -y install $(<packages)

COPY missing-docs /
RUN dnf -y reinstall $(<missing-docs)

RUN rm /{packages,missing-docs}

RUN dnf clean all

RUN sed -i -e 's/ ALL$/ NOPASSWD:ALL/' /etc/sudoers
RUN echo 'Defaults lecture="never"' > /etc/sudoers.d/disable-sudo-lecture

RUN echo VARIANT_ID=container >> /etc/os-release

CMD /bin/sh
