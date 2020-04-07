FROM openjdk:8

ARG VERSION=v1.12.13+hotfix.9

RUN apt-get update && \
	apt-get install -y curl unzip && \
	apt-get clean

RUN curl https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${VERSION}-stable.tar.xz --output /flutter.tar.xz && \
	tar xf flutter.tar.xz && \
	rm flutter.tar.xz

ENV PATH $PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin

RUN flutter doctor