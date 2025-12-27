# 開発ガイド

rails_boilerplate への貢献ありがとうございます。このガイドでは、Issue 作成から PR までの開発フローと基準をまとめます。

## 目次

- [Issue 作成ガイドライン](#issue-作成ガイドライン)
- [開発環境セットアップ](#開発環境セットアップ)
- [Git ワークフロー](#git-ワークフロー)
- [コミット規約](#コミット規約)
- [PR 作成フロー](#pr-作成フロー)
- [コーディング規約](#コーディング規約)
- [テスト方針](#テスト方針)
- [コードレビュー基準](#コードレビュー基準)
- [トラブルシューティング](#トラブルシューティング)

---

## Issue 作成ガイドライン

新機能開発やバグ修正の前に、必ず GitHub Issue を作成してください。Issue は設計書であり、レビューの基準です。

### Issue テンプレート

```markdown
## 概要

[1-2文で変更内容を簡潔に説明]

関連issue: [関連するIssue番号があれば記載]

---

## 背景・課題

### 現状の問題
- [現在どのような問題があるか]
- [なぜこの変更が必要なのか]

### 課題
- [具体的な課題1]
- [具体的な課題2]
- [具体的な課題3]

---

## 目的・ゴール

### 主目的
[この変更で達成したいこと]

### 副次的目標
- [追加で達成したいこと1]
- [追加で達成したいこと2]

---

## 要件定義

### 機能要件

#### FR-1: [機能名1]
- [詳細な要件説明]
- [実装内容]

#### FR-2: [機能名2]
- [詳細な要件説明]
- [実装内容]

### 非機能要件

#### NFR-1: パフォーマンス
- [パフォーマンス要件]

#### NFR-2: セキュリティ
- [セキュリティ要件]

#### NFR-3: 保守性
- [保守性要件]

---

## 技術仕様

### アーキテクチャ

[システム構成図、フロー図など]

### 実装詳細

[具体的な実装方法、コード例など]

---

## 受け入れ基準

### Must Have
- [ ] [必須要件1]
- [ ] [必須要件2]

### Should Have
- [ ] [推奨要件1]
- [ ] [推奨要件2]

### Nice to Have
- [ ] [オプション要件1]
- [ ] [オプション要件2]

---

## 工数見積

### タスク分解

| タスク | 内容 | 見積工数 |
|--------|------|----------|
| 設計 | [設計内容] | X.Xh |
| 実装 | [実装内容] | X.Xh |
| テスト | [テスト内容] | X.Xh |
| ドキュメント更新 | [ドキュメント更新内容] | X.Xh |

合計見積: X時間（X営業日）

---

## テスト計画

### テストケース

#### TC-1: [テストケース名1]
- 手順:
  1. [手順1]
  2. [手順2]
- 期待結果: [期待される結果]

#### TC-2: [テストケース名2]
- 手順:
  1. [手順1]
  2. [手順2]
- 期待結果: [期待される結果]

---

## 次のステップ

[この機能完了後の展開、将来の拡張など]

---

## 関連資料

- [関連ドキュメント、外部リンクなど]

---

## Definition of Done

- [ ] [完了条件1]
- [ ] [完了条件2]
- [ ] すべてのテストケース合格
- [ ] ドキュメント更新完了
- [ ] コードレビュー承認
- [ ] 本番環境デプロイ・検証完了

---

工数見積: X時間（X営業日）
優先度: High/Medium/Low
難易度: High/Medium/Low
依存関係: [依存するIssueや前提条件]
```

---

## 開発環境セットアップ

### 必要なツール

- Docker (20.10+)
- Docker Compose (2.0+)
- Git (2.30+)
- Make (任意)

### セットアップ手順

```bash
# リポジトリをクローン
git clone <your-repo-url>
cd rails_boilerplate

# 環境変数の確認・調整
# .env を編集して Ruby/Rails/Postgres バージョンやDB設定を変更できます

# 初回のみ: Rails アプリケーションを作成
make init

# コンテナ起動
docker compose up -d

# Makefile を使う場合
# make up
```

### よく使うコマンド

```bash
# app コンテナに入る
make bash

# サービス状態確認
docker compose ps
```

---

## Git ワークフロー

このプロジェクトは GitHub Flow を採用します。

### 重要な原則

- main ブランチへ直接コミットしない
- Issue 作成 -> ブランチ作成 -> 実装の順序を守る

### ブランチ命名規則

```
<type>/<issue番号>-<機能名>
```

Type 一覧:

- feature/ - 新機能
- bugfix/ - バグ修正
- hotfix/ - 緊急修正
- refactor/ - リファクタリング
- docs/ - ドキュメント

例:

```
feature/57-documentation-system
bugfix/58-fix-cart-calculation
docs/61-update-readme
```

---

## コミット規約

Conventional Commits に準拠します。

フォーマット:

```
<type>(<scope>): <subject> (issue#<番号>)

<body>（任意）
<footer>（任意）
```

Type 一覧:

- feat: 新機能
- fix: バグ修正
- docs: ドキュメント
- refactor: リファクタリング
- test: テスト追加・修正
- chore: ビルド・ツール設定
- perf: パフォーマンス改善
- style: コードスタイル

良い例:

```
feat(app): ユーザー一覧画面を追加 (issue#12)
fix(app): バリデーションを修正 (issue#34)
docs: CONTRIBUTING.mdを追加 (issue#1)
```

---

## PR 作成フロー

### 1. 実装とコミット

```bash
git add .
git commit -m "feat(app): 〇〇を実装 (issue#12)"
git push origin feature/12-xxx
```

### 2. PR テンプレート

```markdown
## 概要

[変更の概要を1-2文で説明]

## 変更内容

- [主要な変更点1]
- [主要な変更点2]

## テスト方法

```bash
[動作確認手順]
```

## チェックリスト

- [ ] テスト追加
- [ ] コーディング規約準拠
- [ ] ドキュメント更新

Closes #XX
```

---

## コーディング規約

### Rails

- ビジネスロジックは Service Object に抽出する
- 変更が広がる場合は Decorator / Concern を検討する
- RuboCop などの静的解析がある場合は準拠する

### Ruby

- 1メソッド1責務を意識
- 早期 return でネストを浅く

---

## テスト方針

- 新機能・修正にはテストを追加する
- RSpec を標準テストフレームワークとして扱う

例:

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a name' do
    user = build(:user, name: 'Alice')
    expect(user).to be_valid
  end
end
```

### RSpec セットアップ（初回）

```bash
# Gemfile に追加
# gem 'rspec-rails', group: [:development, :test]

bundle install
rails generate rspec:install
```

---

## コードレビュー基準

- Issue の要件を満たしているか
- テストが十分か
- 命名が適切か
- パフォーマンス上の問題（N+1など）がないか
- セキュリティ上の懸念がないか
- マイグレーションはロールバック可能か

---

## トラブルシューティング

### コンテナ起動に失敗する

```bash
# クリーンアップ後に再起動
docker compose down -v
docker compose up -d
```

### 依存インストールに失敗する

```bash
# ボリューム削除後に再ビルド
docker compose build --no-cache
```

---

## 質問・サポート

- Issue を作成して相談してください。
