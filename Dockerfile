FROM bitnami/git AS git
WORKDIR /app

ARG VERSION=1.52.0

RUN git clone https://github.com/eclipse-theia/theia.git
WORKDIR /app/theia
RUN git checkout --end-of-options v${VERSION}

FROM node:18 AS build
COPY --from=git /app/theia /theia

WORKDIR /theia

RUN yarn
RUN yarn theia build

FROM node:18
COPY --from=build /theia /theia
WORKDIR /theia
CMD ["yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0"]
EXPOSE 3000
