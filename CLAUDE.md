# CLAUDE.md

> **対象読者**: Claude Code（AI開発アシスタント）
> **目的**: Claude Codeが作業する際に参照する情報のクイックリファレンス

---

## 重要: ドキュメントの役割分担

作業を開始する前に、必ず以下のドキュメントを確認してください：

1. **[README.md](README.md)**: プロジェクト固有の技術情報
   - プロジェクト概要、技術スタック
   - 開発環境セットアップ（Docker、make コマンド）
   - アーキテクチャ（Docker構成、環境変数管理）
   - よく使うコマンド（詳細）
   - 本番環境デプロイ手順
   - プロジェクト構造
   - トラブルシューティング

2. **[CONTRIBUTING.md](CONTRIBUTING.md)**: 開発規約（**最重要**）
   - Issue作成ガイドライン
   - Gitワークフロー（ブランチ戦略）
   - コミット規約（Conventional Commits）
   - PR作成フロー
   - コーディング規約
   - テスト方針
   - コードレビュー基準（セキュリティチェック含む）

---

## プロジェクト概要

このプロジェクトは、**Railsプロジェクトを素早く立ち上げるためのDocker化されたboilerplate**です。

### 主要技術

- **Ruby**: 3.3.6
- **Rails**: 8.0.4
- **PostgreSQL**: 16-bookworm
- **Docker & Docker Compose**
- **Tailwind CSS**、**Import maps**

### 特徴

- Docker Composeによる開発環境
- 通常のRails開発とECサイト開発（Solidus）に対応
- 環境変数ファイルの明示的な管理（`.env.development` / `.env.production`）
- 本番環境デプロイ対応

詳細は [README.md](README.md) を参照してください。

---

## よく使うコマンド

### 初回セットアップ

```bash
# 通常のRails開発
make init

# ECサイト開発（Solidus）
make init-ec

# コンテナ起動
make up
```

### 開発作業

```bash
# コンテナ起動
make up

# コンテナ停止
make down

# コンテナに入る
make bash

# 全コマンド確認
make help
```

### コンテナ内での作業

```bash
# Rails console
rails console

# マイグレーション
rails db:migrate

# テスト
bundle exec rspec
```

詳細は [README.md](README.md) の「よく使うコマンド」セクションを参照してください。

---

## CONTRIBUTING.mdの活用方法

作業を開始する際は、**必ず [CONTRIBUTING.md](CONTRIBUTING.md) の手順を守ってください**：

### 必須手順

1. **Issue作成** → [Issue作成ガイドライン](CONTRIBUTING.md#issue-作成ガイドライン)
   - Issue番号を控える（例: #33）

2. **ブランチ作成** → [Gitワークフロー](CONTRIBUTING.md#git-ワークフロー)
   ```bash
   git checkout main
   git pull origin main
   git checkout -b <type>/<issue番号>-<機能名>
   # 例: git checkout -b docs/33-separate-file-roles
   ```

3. **実装作業**
   - コーディング規約に従う → [コーディング規約](CONTRIBUTING.md#コーディング規約)
   - セキュリティチェック必須 → [セキュリティチェック](CONTRIBUTING.md#セキュリティチェック)

4. **コミット** → [コミット規約](CONTRIBUTING.md#コミット規約)
   ```bash
   git add .
   git commit -m "<type>(<scope>): <subject> (issue#<番号>)"
   # 例: git commit -m "docs: 3ファイルの役割分担を明確化 (issue#33)"
   ```

5. **プッシュとPR作成** → [PR作成フロー](CONTRIBUTING.md#pr-作成フロー)
   ```bash
   git push origin <branch-name>
   # GitHub でPRを作成
   ```

### 重要な禁止事項

❌ **mainブランチへの直接コミット・プッシュ**
- 必ずブランチを作成してから作業する

❌ **AI生成メッセージの追加**
- コミットメッセージやPRに「Generated with Claude Code」や「Co-Authored-By: Claude」を追加しない
- 詳細: [禁止事項：AI生成メッセージの追加](CONTRIBUTING.md#-禁止事項ai生成メッセージの追加)

### セキュリティチェック項目

実装時に以下を必ず確認：

- [ ] SQLインジェクション対策（プレースホルダー使用）
- [ ] XSS対策（ERB自動エスケープ、html_safe禁止）
- [ ] CSRF保護（Rails デフォルト維持）
- [ ] Strong Parameters使用
- [ ] 機密情報の環境変数化
- [ ] 認可チェック実装

詳細: [セキュリティチェック](CONTRIBUTING.md#セキュリティチェック)

---

## アーキテクチャ概要

### Docker構成

```
app (Rails) → db (PostgreSQL)
```

- **app**: ポート3000、カレントディレクトリをマウント
- **db**: ポート5432、postgres_dataボリュームで永続化

### 環境変数管理

- 開発環境: `.env.development`（コミット済み）
- 本番環境: `.env.production`（コミット済み、要編集）
- `--env-file` で明示的に指定する設計

詳細は [README.md のアーキテクチャセクション](README.md#アーキテクチャ) を参照してください。

---

## トラブルシューティング

一般的な問題の解決方法は [README.md のトラブルシューティングセクション](README.md#トラブルシューティング) を参照してください。

### よくある問題

**コンテナ起動失敗:**
```bash
docker compose --env-file .env.development down -v
docker compose --env-file .env.development up -d
```

**依存関係の問題:**
```bash
docker compose --env-file .env.development build --no-cache
```

**データベースの問題:**
```bash
make bash
rails db:reset
```

---

## Claude Code向けのワークフローガイド

### 開発タスクを受けたときの手順

1. **ドキュメント確認**
   - README.mdで技術仕様を確認
   - CONTRIBUTING.mdで開発規約を確認

2. **Issue確認**
   - 既存Issueがあれば内容を確認
   - なければIssue作成を提案

3. **ブランチ作成**
   - 必ずmainから分岐
   - 命名規則: `<type>/<issue番号>-<機能名>`

4. **実装**
   - セキュリティチェックを意識
   - テストを追加
   - コーディング規約に従う

5. **コミット**
   - Conventional Commits形式
   - issue番号を含める
   - AI生成メッセージは追加しない

6. **PR作成**
   - PRテンプレートに従う
   - 変更内容を明確に説明
   - AI生成メッセージは追加しない

### 効果的なプロンプト例

**良い例:**
```
Implement issue #12 following CONTRIBUTING.md.
Create a feature branch, implement the User model with email validation,
write RSpec tests, commit, and create a PR.
```

**悪い例:**
```
Add a user model
```

常に以下を意識：
- Issue番号を明示
- CONTRIBUTING.mdへの言及
- 具体的な要件

---

## 参考リンク

- [README.md](README.md) - プロジェクト固有の技術情報
- [CONTRIBUTING.md](CONTRIBUTING.md) - 開発規約（最重要）
- [Conventional Commits](https://www.conventionalcommits.org/) - コミット規約の詳細

---

## まとめ

このファイル（CLAUDE.md）はクイックリファレンスです。詳細情報は必ず以下を参照してください：

- **技術的な質問** → [README.md](README.md)
- **開発フローの質問** → [CONTRIBUTING.md](CONTRIBUTING.md)

作業開始前に必ず両ファイルを確認し、規約に従って進めてください。
