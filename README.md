# Rails Boilerplate

Docker環境でRailsアプリケーションを迅速に開発・デプロイするためのボイラープレート。

## 技術スタック

- Ruby 3.3.6
- Rails 8.0.4
- PostgreSQL 16
- Docker & Docker Compose
- Tailwind CSS

## 開発環境セットアップ

### 初回のみ

```bash
# Rails アプリケーションを作成
make init

# コンテナを起動
make up
```

### 日常的な開発

```bash
# コンテナ起動
make up

# コンテナに入る
make bash

# ログ確認
make help  # 利用可能なコマンド一覧を表示
```

アプリケーション: http://localhost:3000

## 本番環境デプロイ

### VPSへのデプロイ手順

**1. VPS上での初回セットアップ**

```bash
# VPSにSSH接続
ssh user@your-vps-ip

# リポジトリをclone
git clone https://github.com/zomians/rails_boilerplate.git
cd rails_boilerplate

# .env.productionを編集（SECRET_KEY_BASE等を設定）
vi .env.production
```

**2. 本番環境の起動**

```bash
# イメージをビルド
make prod-build

# 本番環境を起動
make prod-up

# データベースをセットアップ
make prod-db-setup
```

**3. 確認**

アプリケーション: http://your-vps-ip:3000

### 本番環境の操作コマンド

```bash
make prod-up         # 起動
make prod-down       # 停止
make prod-restart    # 再起動
make prod-logs       # ログ表示
make prod-bash       # コンテナに入る
make prod-ps         # 状態確認
```

### 更新デプロイ

```bash
# VPS上で
git pull
make prod-build
make prod-restart
```

## 環境変数

- **開発環境**: `.env.development`（コミット済み）
- **本番環境**: `.env.production`（要編集）

本番環境では以下を必ず変更：
- `SECRET_KEY_BASE`
- `POSTGRES_PASSWORD`

## 詳細ドキュメント

- [CONTRIBUTING.md](CONTRIBUTING.md) - 開発ガイドライン・ワークフロー
