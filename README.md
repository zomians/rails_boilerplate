# Rails Boilerplate

Docker環境でRailsアプリケーションを迅速に開発・デプロイするためのボイラープレート。

## 技術スタック

- Ruby 3.3.6
- Rails 8.0.4
- PostgreSQL 16
- Docker & Docker Compose
- Tailwind CSS

## 開発環境セットアップ

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

**よく使うコマンド:**
```bash
make help   # 利用可能なコマンド一覧
make bash   # コンテナに入る
```

## 環境変数

このプロジェクトでは、環境ごとに環境変数ファイルを使い分けます。

- **開発環境**: `.env.development`（コミット済み）
- **本番環境**: `.env.production`（コミット済み、要編集）

`.env` ファイルは使用せず、`--env-file` で環境を明示的に指定します。

本番環境では以下を必ず変更：
- `SECRET_KEY_BASE`
- `POSTGRES_PASSWORD`

## 詳細ドキュメント

- [CONTRIBUTING.md](CONTRIBUTING.md) - 開発ガイドライン・ワークフロー
