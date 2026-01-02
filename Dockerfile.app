# syntax=docker/dockerfile:1

# ============================================
# Base ステージ - 最小限のランタイム依存関係
# ============================================
ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-slim AS base

WORKDIR /app

# 実行時に必要な最小限のパッケージをインストール
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        libpq-dev \
        postgresql-client \
        shared-mime-info \
        libvips42 \
        ca-certificates \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# Development ステージ - ローカル開発環境用
# ============================================
FROM base AS development

# ビルドツールと開発ツールをインストール
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        less \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Rails をインストール
ARG RAILS_VERSION
RUN gem install rails -v ${RAILS_VERSION} --no-document

# ============================================
# Production-builder ステージ - アプリケーションビルド用
# ============================================
FROM base AS production-builder

# ビルドに必要なパッケージをインストール
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Gemfile をコピーして gem をインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3 --without development test

# アプリケーションコードをコピー
COPY . .

# アセットをプリコンパイル
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# ============================================
# Production ステージ - 最小限の本番実行環境
# ============================================
FROM base AS production

# 非 root ユーザーを作成
RUN groupadd -r rails && useradd -r -g rails rails \
    && mkdir -p /app \
    && chown -R rails:rails /app

# ビルド済みの gem とアプリケーションをコピー
COPY --from=production-builder --chown=rails:rails /usr/local/bundle /usr/local/bundle
COPY --from=production-builder --chown=rails:rails /app /app

# 非 root ユーザーに切り替え
USER rails

# ポートを公開
EXPOSE 3000

# 本番モードで Rails サーバーを起動
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-e", "production"]
