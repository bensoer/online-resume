FROM ruby:3.1.2 AS builder

RUN mkdir -p /build && \
    mkdir -p /build/_site && \
    mkdir -p /build/.jekyll-cache
WORKDIR /build

COPY . .
RUN bundle install && \
    bundle exec jekyll build --verbose


FROM nginxinc/nginx-unprivileged:stable-alpine-slim
WORKDIR /usr/share/nginx/html
USER root
RUN rm -rf ./*
USER nginx
COPY --from=builder /build/_site .

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]