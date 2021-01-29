ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION
LABEL maintainer "Scott Mathieson <scott@eingress.io>"

ARG NODE_VERSION
ARG YARN_VERSION

WORKDIR /build

RUN addgroup -g 1000 node \
	&& adduser -u 1000 -G node -s /bin/sh -D node \
	&& apk add --no-cache \
	libstdc++ \
	&& apk add --no-cache --virtual .build-deps \
	binutils-gold \
	curl \
	g++ \
	gcc \
	git \
	libgcc \
	linux-headers \
	make \
	python3 \
	tar \
	&& curl -LJO https://github.com/nodejs/node/archive/v${NODE_VERSION}.tar.gz \
	&& tar -xzf node-${NODE_VERSION}.tar.gz \
	&& cd node-${NODE_VERSION} \
	&& ./configure --experimental-quic \
	&& make -j$(getconf _NPROCESSORS_ONLN) V= \
	&& make install PREFIX=/usr/local \
	&& apk del .build-deps \
	&& cd  / \
	&& rm -rf /build

RUN apk add --no-cache --virtual .build-deps \
	curl \
	tar\
	&& curl -LJO --compressed https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz \
	&& tar -xzf yarn-v${YARN_VERSION}.tar.gz -C /opt/ \
	&& ln -s /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn \
	&& ln -s /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg \
	&& rm yarn-v${YARN_VERSION}.tar.gz \
	&& apk del .build-deps

WORKDIR /app

CMD [ "sh" ]
