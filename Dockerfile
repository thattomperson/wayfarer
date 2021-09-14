FROM node:16-alpine as static

# set our node environment, either development or production
# defaults to production, compose overrides this to development on build and run
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

# you'll likely want the latest npm, regardless of node version, for speed and fixes
# but pin this version for the best stability
# RUN npm i npm@latest -g

# install dependencies first, in a different location for easier app bind mounting for local development
# due to default /opt permissions we have to create the dir with root and change perms
RUN mkdir /opt/wayfearer && chown node:node /opt/wayfearer
WORKDIR /opt/wayfearer


COPY package*.json .
RUN npm install --no-optional && npm cache clean --force
ENV PATH /opt/wayfearer/node_modules/.bin:$PATH

WORKDIR /opt/wayfearer/app

COPY client client
COPY public public
COPY *.config.*js .

RUN npm run build

# build the golang in a sperate container
FROM golang:1.16 AS builder
WORKDIR /go/src/github.com/thattomperson/wayfearer
COPY go.* .
COPY *.go .
COPY --from=static /opt/wayfearer/app/build .
RUN go get .
RUN CGO_ENABLED=0 GOOS=linux go build -o wayfearer .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/thattomperson/wayfearer/wayfearer ./
EXPOSE 8080
LABEL org.opencontainers.image.source "https://github.com/thattomperson/wayfearer"
CMD ["./wayfearer"]
