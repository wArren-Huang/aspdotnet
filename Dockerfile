ARG DOWNLOAD_SOURCE=https://download.visualstudio.microsoft.com/download/pr/16709432-660f-4cd3-8fd1-baaed55173b2/4a97f809fb29153e5dd475a795e6906b/aspnetcore-runtime-5.0.5-linux-musl-x64.tar.gz
ARG DOWNLOAD_CHECKSUM=04057353d890e73f5fe93cf9d05b2e84bf1f972a401acc631fc7ee7b83e97a4e40343458f274b7e900f96b94fbd2b954bde89b8874367776c82cb17567091d23

ARG INSTALL_TARGET=/opt/dotnet

FROM alpine:3.13.5 AS download
ARG DOWNLOAD_SOURCE
ARG DOWNLOAD_CHECKSUM
ARG INSTALL_TARGET
RUN apk update; apk upgrade
RUN apk add curl
RUN mkdir -p ${INSTALL_TARGET}
RUN curl -o dotnet.tar.gz ${DOWNLOAD_SOURCE}
RUN echo "${DOWNLOAD_CHECKSUM}  dotnet.tar.gz" > dotnet.tar.gz.sha512
RUN sha512sum -c dotnet.tar.gz.sha512
RUN tar xzf dotnet.tar.gz -C ${INSTALL_TARGET}

FROM alpine:3.13.5
ARG INSTALL_TARGET
RUN apk update; apk upgrade
RUN apk add icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib
COPY --from=download ${INSTALL_TARGET} ${INSTALL_TARGET}
RUN ln -s ${INSTALL_TARGET}/dotnet /usr/local/bin/dotnet
