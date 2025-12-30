# syntax=docker/dockerfile:1

# ベースイメージ
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-slim AS base

## システムパッケージインストール
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libyaml-dev \
        libpq-dev \
        postgresql-client \
        shared-mime-info \
        libvips42 \
        ca-certificates \
        curl \
        less \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 開発環境イメージ
FROM base AS development

## Railsインストール
ARG RAILS_VERSION
RUN gem install rails -v ${RAILS_VERSION} --no-document
