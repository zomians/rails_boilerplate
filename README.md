# Rails Boilerplate

> Railsプロジェクトを素早く立ち上げるためのDocker化されたboilerplate

**貢献したい方は**: [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください

---

## 目次

- [プロジェクト概要](#プロジェクト概要)
- [技術スタック](#技術スタック)
- [クイックスタート](#クイックスタート)
- [開発環境セットアップ](#開発環境セットアップ)
- [アーキテクチャ](#アーキテクチャ)
- [よく使うコマンド](#よく使うコマンド)
- [本番環境デプロイ](#本番環境デプロイ)
- [プロジェクト構造](#プロジェクト構造)
- [トラブルシューティング](#トラブルシューティング)

---

## プロジェクト概要

このプロジェクトは、Dockerを使用したRails開発環境を提供するboilerplateです。通常のRails開発とECサイト開発（Solidus）の両方に対応しています。

### 特徴

- Docker Compose による開発環境の一貫性
- 環境ごとの設定ファイル管理（`.env.development` / `.env.production`）
- Makefileによる簡単なコマンド実行
- 定番gemのプリインストール（RSpec、FactoryBot、Pry等）
- 本番環境デプロイ対応

---

## 技術スタック

| 技術 | バージョン | 用途 |
|-----|----------|------|
| Ruby | 3.3.6 | プログラミング言語 |
| Rails | 8.0.4 | Webフレームワーク |
| PostgreSQL | 16-bookworm | データベース |
| Docker | 20.10+ | コンテナ実行環境 |
| Docker Compose | 2.0+ | 複数コンテナ管理 |
| Tailwind CSS | - | CSSフレームワーク |
| Import maps | - | JavaScript管理 |

バージョンは `.env.development` / `.env.production` で変更可能です。

---

## クイックスタート

```bash
# リポジトリをクローン
git clone https://github.com/zomians/rails_boilerplate.git
cd rails_boilerplate

# Rails アプリケーションを作成（初回のみ）
make init

# コンテナを起動
make up
```

アプリケーション: http://localhost:3000

---

## 開発環境セットアップ

### 必要なツール

| ツール | 必須/任意 | 推奨バージョン | 用途 |
|--------|----------|--------------|------|
| Docker | 必須 | 20.10+ | コンテナ実行環境 |
| Docker Compose | 必須 | 2.0+ | 複数コンテナの管理 |
| Git | 必須 | 2.30+ | バージョン管理 |
| Make | 任意 | - | コマンド簡略化 |

### セットアップ手順

このプロジェクトでは、用途に応じて2つの初期化コマンドを用意しています。

#### 通常のRails開発の場合

```bash
# リポジトリをクローン
git clone https://github.com/zomians/rails_boilerplate.git
cd rails_boilerplate

# 環境変数の確認・調整
# .env.development を編集して Ruby/Rails/Postgres バージョンやDB設定を変更できます

# 初回のみ: 定番gemを含むRailsアプリケーションを作成
make init

# コンテナ起動
make up
```

**`make init` で追加される定番gem:**
- `mini_racer`: Node.js不要のV8エンジン
- `stripe`: 決済処理
- `devise`: 認証（要手動セットアップ）
- `kaminari`: ページネーション
- `rack-cors`: CORS対応
- `pry-rails`: デバッグREPL（development）
- `rspec-rails`, `factory_bot_rails`, `faker`: テスト関連（development, test）
- Rails 8にはデフォルトで `rubocop-rails-omakase` が含まれます

**自動生成されるinitializer:**
- `config/initializers/stripe.rb`: Stripe APIキー設定
- `config/initializers/cors.rb`: CORS設定（開発環境向けデフォルト）

**Deviseの手動セットアップ:**

Devise gemはインストール済みですが、使用する場合は以下の手順でセットアップしてください：

```bash
# コンテナ内で実行
rails generate devise:install
rails generate devise User
rails db:migrate
```

セットアップ後、以下の設定を追加してください：
- ルートパス (`config/routes.rb`)
- フラッシュメッセージ (`app/views/layouts/application.html.erb`)

詳細は `rails generate devise:install` 実行時に表示される指示を参照してください。

**Stripeの初期設定:**
- `config/initializers/stripe.rb` が自動作成されます
- `.env.development` にサンプルのAPIキーが含まれています
- 実際に使用する場合は、[Stripe Dashboard](https://dashboard.stripe.com/test/apikeys) から取得したAPIキーに置き換えてください

#### ECサイト開発（Solidus）の場合

```bash
# リポジトリをクローン
git clone https://github.com/zomians/rails_boilerplate.git
cd rails_boilerplate

# 環境変数の確認・調整
# .env.development を編集して Ruby/Rails/Postgres バージョンやDB設定を変更できます

# 初回のみ: Solidus専用Railsアプリケーションを作成
make init-ec

# コンテナ起動
make up

# 管理画面にアクセス
# http://localhost:3000/admin
# ログイン: admin@example.com / test123
```

**`make init-ec` で行われる処理:**
- Rails newの実行（`--skip-asset-pipeline` で Propshaft を除外）
- Sprockets有効化（`sprockets-rails` gemを追加）
- Sprockets用の `manifest.js` と `assets.rb` を作成
- `mini_racer`の追加（JavaScript実行エンジン）
- Solidus gemの追加とインストール
- データベースマイグレーションとサンプルデータのロード
- Procfile.devの調整（Docker環境用に `-b 0.0.0.0` を追加）

**重要:** `make init` と `make init-ec` は独立した処理です。どちらか一方のみを実行してください。

---

## アーキテクチャ

### Docker構成

このプロジェクトは**マルチコンテナDocker構成**を採用しています。

#### 開発環境サービス構成

```
┌─────────────────────────────────────┐
│  app (Rails アプリケーション)         │
│  - ポート: 3000                      │
│  - ボリューム: カレントディレクトリ    │
│  - 依存: db サービス                 │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│  db (PostgreSQL)                    │
│  - ポート: 5432                      │
│  - ボリューム: postgres_data         │
│  - ヘルスチェック有効                │
└─────────────────────────────────────┘
```

#### 本番環境サービス構成

リバースプロキシはアプリケーションから独立した構成です。外部ネットワーク `web-proxy-net` を介して接続します。

```
Internet
    ↓
┌─────────────────────────────────────┐
│  caddy (reverse-proxy/)             │  ← 独立管理
│  - ポート: 80/443                    │
│  - SSL自動（Let's Encrypt）          │
│  - HTTP→HTTPSリダイレクト自動        │
│  - ネットワーク: web-proxy-net       │
└─────────────────────────────────────┘
              ↓ web-proxy-net（外部ネットワーク）
┌─────────────────────────────────────┐
│  app (Rails アプリケーション)         │
│  - ポート: 3000（内部のみ）          │
│  - ネットワーク: internal,           │
│                  web-proxy-net       │
│  - 依存: db サービス                 │
└─────────────────────────────────────┘
              ↓ internal
┌─────────────────────────────────────┐
│  db (PostgreSQL)                    │
│  - ポート: 5432（内部のみ）          │
│  - ネットワーク: internal            │
│  - ボリューム: postgres_data         │
│  - ヘルスチェック有効                │
└─────────────────────────────────────┘
```

**構成ファイル:**
- `reverse-proxy/compose.yaml` + `reverse-proxy/Caddyfile`: リバースプロキシ（独立管理）
- `compose.development.yaml` + `.env.development`: 開発環境（app + db）
- `compose.production.yaml` + `.env.production`: 本番環境（app + db）

#### 1. app サービス（`Dockerfile.app`）

- Ruby/Rails開発環境
- カレントディレクトリを `/app` にマウント
- `bundle_cache` ボリュームでgemを永続化
- デフォルトで `bin/dev` を実行（Railsサーバー起動 + アセットビルド）
- アクセス: http://localhost:3000

#### 2. db サービス

- PostgreSQLデータベース
- データは `postgres_data` ボリュームに永続化
- アクセス: localhost:5432
- ヘルスチェックでアプリ起動前にDB準備完了を確認

### 環境変数管理

#### ファイル構成

- `.env.development`: 開発環境用の設定（リポジトリにコミット、サンプル値含む）
- `.env.production`: 本番環境用の設定（リポジトリにコミット、サンプル値含む）

#### 設計方針

- `--env-file` オプションで環境ファイルを明示的に指定
- 開発環境: `docker compose -f compose.development.yaml --env-file .env.development`
- 本番環境: `docker compose -f compose.production.yaml --env-file .env.production`

#### メリット

- 環境ファイルのコピー不要
- 使用する環境が明示的
- `.gitignore` の設定不要
- セキュリティ向上（間違って機密情報をコミットするリスク低減）

#### 環境変数一覧

**開発環境（.env.development）:**
- `RUBY_VERSION`: Ruby version (default: 3.3.6)
- `RAILS_VERSION`: Rails version (default: 8.0.4)
- `POSTGRES_VERSION`: PostgreSQL version (default: 16-bookworm)
- `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`: Database credentials
- `DATABASE_URL`: PostgreSQL connection URL (auto-generated)

**本番環境用追加環境変数（.env.production）:**
- `SECRET_KEY_BASE`: Rails secret key（**必ず変更**）
- `POSTGRES_PASSWORD`: データベースパスワード（**必ず変更**）
- `RAILS_ENV=production`
- `RAILS_LOG_TO_STDOUT=true`
- `RAILS_SERVE_STATIC_FILES=true`

---

## よく使うコマンド

### 開発環境

```bash
# コンテナ起動
make up

# コンテナ停止
make down

# app コンテナに入る
make bash

# サービス状態確認
docker compose -f compose.development.yaml --env-file .env.development ps

# ログ表示
docker compose -f compose.development.yaml --env-file .env.development logs app
docker compose -f compose.development.yaml --env-file .env.development logs db

# 利用可能なコマンド一覧を表示
make help
```

### コンテナ内での作業

コンテナに入った後（`make bash`）、以下のコマンドが使用できます。

```bash
# Rails console
rails console

# データベースマイグレーション
rails db:migrate

# データベースセットアップ
rails db:setup

# モデル/コントローラー生成
rails generate model User name:string email:string

# Railsサーバー起動（bin/devが動いていない場合）
rails server
```

### Docker関連

```bash
# コンテナを再ビルド（Dockerfileや依存関係変更後）
docker compose -f compose.development.yaml --env-file .env.development build --no-cache

# このプロジェクトのDocker関連をクリーン（公式イメージは保持）
make clean
```

### リバースプロキシ

`reverse-proxy/` ディレクトリは自己完結しています。ディレクトリに移動して操作してください。

```bash
cd reverse-proxy/

# リバースプロキシを起動（web-proxy-netも自動作成）
make up

# リバースプロキシを停止
make down

# リバースプロキシのログを表示
make logs

# Caddyfile変更後に設定を再読み込み
make reload

# コマンド一覧
make help
```

### 本番環境

```bash
# 本番環境をデプロイ（ビルド→再作成→マイグレーション→シード）
make prod-deploy

# 本番環境のログを表示
make prod-logs

# 本番環境のappコンテナに入る
make prod-bash

# 本番環境のコンテナ状態を表示
make prod-ps

# その他の本番環境コマンド
make help  # 全コマンド確認
```

---

## 本番環境デプロイ

このプロジェクトは Docker Compose を使用した本番環境デプロイをサポートしています。

### 構成ファイル

| ファイル | 用途 |
|---------|------|
| `reverse-proxy/compose.yaml` | リバースプロキシ用 Docker Compose 設定 |
| `reverse-proxy/Caddyfile` | Caddy リバースプロキシ設定（SSL自動化） |
| `compose.production.yaml` | 本番環境用 Docker Compose 設定（app + db） |
| `.env.production` | 本番環境用環境変数（SECRET_KEY_BASE等を要変更） |
| `Dockerfile.app` | 本番ステージを含むマルチステージビルド |

### SSL/TLS（HTTPS）

本番環境では [Caddy](https://caddyserver.com/) をリバースプロキシとして使用し、Let's Encrypt による SSL/TLS 証明書の取得・更新を自動化しています。

- 証明書の取得・更新は完全自動（手動操作不要）
- HTTP→HTTPS リダイレクトも自動
- HTTP/3（QUIC）対応

### VPSへのデプロイ手順

#### 前提条件

- VPSにDockerとDocker Composeがインストール済み（[VPS初期セットアップ](docs/vps-setup.md) 参照）
- ドメインのDNS AレコードがVPSのIPアドレスに設定済み
- ポート80/443がファイアウォールで開放済み

#### 1. VPS上での初回セットアップ

```bash
# VPSにSSH接続
ssh devuser@your-vps-ip

# リポジトリをclone
git clone https://github.com/zomians/rails_boilerplate.git
cd rails_boilerplate

# .env.productionを編集
vi .env.production
```

**必須設定項目:**
- `SECRET_KEY_BASE`: `docker compose -f compose.production.yaml run --rm app bundle exec rails secret` で生成
- `POSTGRES_PASSWORD`: ランダムな強力なパスワードに変更

#### 2. リバースプロキシの設定・起動

リバースプロキシ（Caddy）はプロジェクトとは独立して `/srv/reverse-proxy/` で運用します（[VPS初期セットアップ](docs/vps-setup.md) 参照）。

```bash
# reverse-proxy/ を /srv/reverse-proxy/ にコピー
cp -r reverse-proxy/ /srv/reverse-proxy/

# Caddyfileにドメイン名を設定
vi /srv/reverse-proxy/Caddyfile

# リバースプロキシを起動（web-proxy-netネットワークも自動作成）
cd /srv/reverse-proxy/
make up
```

#### 3. アプリケーションのデプロイ

```bash
make prod-deploy
```

このコマンドで以下が一括実行されます:
1. `web-proxy-net` ネットワークの確認・作成
2. イメージをビルド（`--no-cache`）
3. 既存コンテナを停止
4. コンテナを起動
5. データベースのセットアップ（`db:create db:migrate db:seed`）

#### 4. 確認

アプリケーション: `https://yourdomain.com`

Caddy が自動的に Let's Encrypt から SSL 証明書を取得します。初回アクセス時に数秒かかる場合があります。

### 更新デプロイ

コードを更新した場合の手順:

```bash
# VPS上で
git pull origin main

# アプリケーションのみ再デプロイ（リバースプロキシは停止しない）
make prod-deploy
```

---

## プロジェクト構造

```
.
├── .env.development          # 開発環境用環境変数（コミット済み）
├── .env.production           # 本番環境用環境変数テンプレート（コミット済み）
├── reverse-proxy/            # リバースプロキシ（独立管理、ディレクトリごとコピーで運用可能）
│   ├── compose.yaml          # Caddy用 Docker Compose 設定
│   ├── Caddyfile             # Caddy リバースプロキシ設定
│   └── Makefile              # リバースプロキシ操作コマンド
├── compose.development.yaml  # 開発環境用 Docker Compose 設定
├── compose.production.yaml   # 本番環境用 Docker Compose 設定（app + db）
├── Dockerfile.app            # Appコンテナ定義（マルチステージビルド）
├── Makefile                  # 開発ショートカット
├── CONTRIBUTING.md           # 開発ガイドライン・ワークフロー
├── CLAUDE.md                 # Claude Code向けガイド
└── README.md                 # このファイル
```

**注意**: `make init` 実行後、カレントディレクトリに完全なRailsアプリケーション構造が作成されます。

---

## トラブルシューティング

### コンテナ起動に失敗する

```bash
# クリーンアップ後に再起動
docker compose -f compose.development.yaml --env-file .env.development down -v
docker compose -f compose.development.yaml --env-file .env.development up -d
```

### 依存関係のインストールに失敗する

```bash
# ボリューム削除後に再ビルド
docker compose -f compose.development.yaml --env-file .env.development down -v
docker compose -f compose.development.yaml --env-file .env.development build --no-cache
docker compose -f compose.development.yaml --env-file .env.development up -d
```

### データベース関連の問題

```bash
# コンテナに入る
make bash

# コンテナ内で実行
rails db:reset
rails db:migrate
```

### ファイル権限の問題

Dockerで作成されたファイルの権限問題が発生した場合:

```bash
# ホスト上で実行
sudo chown -R $(id -u):$(id -g) .
```

### 本番環境のトラブルシューティング

#### コンテナが起動しない

```bash
# ログを確認
make prod-logs

# コンテナ状態を確認
make prod-ps

# クリーンアップして再デプロイ
make prod-deploy
```

#### データベース接続エラー

```bash
# データベースコンテナの状態を確認
make prod-ps

# データベースをリセット（注意: 全データ削除）
make prod-db-reset
```

### よくある質問

**Q: ポート3000が既に使用されている**
```bash
# 使用中のプロセスを確認
lsof -i :3000

# プロセスを停止するか、compose.development.yamlでポートを変更
```

**Q: make コマンドが使えない**
```bash
# makeがインストールされていない場合、直接docker composeコマンドを使用
docker compose -f compose.development.yaml --env-file .env.development up -d
docker compose -f compose.development.yaml --env-file .env.development exec app bash
```

---

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。

