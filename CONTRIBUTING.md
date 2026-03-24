# 開発ガイド

> **対象読者**: 人間の開発者（コントリビューター）
> **目的**: プロジェクトへの貢献手順と開発規約
>
> このガイドは汎用的なRailsプロジェクトの開発規約です。
> プロジェクト固有の情報（セットアップ、アーキテクチャ、コマンド、デプロイ等）は [README.md](README.md) を参照してください。

rails_boilerplate への貢献ありがとうございます。このガイドでは、Issue 作成から PR までの開発フローと基準をまとめます。

---

## ドキュメントの役割分担

このプロジェクトでは、3つのドキュメントファイルで情報を整理しています。更新時はこの役割分担を維持してください。

| コンテンツ | README.md | CONTRIBUTING.md | CLAUDE.md |
|-----------|----------|----------------|-----------|
| プロジェクト概要 | ◎ 詳細 | - | ○ 簡潔 |
| 技術スタック | ◎ | - | ○ |
| セットアップ | ◎ | - | ○ 参照 |
| アーキテクチャ | ◎ | - | ○ 参照 |
| コマンド | ◎ 詳細 | - | ○ 重要なもののみ |
| 本番デプロイ | ◎ | - | - |
| Issue作成 | - | ◎ | ○ 参照 |
| Gitワークフロー | - | ◎ | ○ 参照 |
| コミット規約 | - | ◎ | ○ 参照 |
| PR作成 | - | ◎ | ○ 参照 |
| コーディング規約 | - | ◎ | ○ 参照 |
| テスト方針 | - | ◎ | ○ 参照 |
| レビュー基準 | - | ◎ | ○ 参照 |
| トラブルシューティング | ◎ | - | ○ 参照 |

**凡例:**
- ◎ 詳細に記載
- ○ 簡潔に記載または参照
- \- 含まない

---

## 目次

- [Issue 作成ガイドライン](#issue-作成ガイドライン)
- [Git ワークフロー](#git-ワークフロー)
- [コミット規約](#コミット規約)
- [PR 作成フロー](#pr-作成フロー)
- [コーディング規約](#コーディング規約)
- [テスト方針](#テスト方針)
- [コードレビュー基準](#コードレビュー基準)

---

## Issue 作成ガイドライン

新機能開発やバグ修正の前に、必ず GitHub Issue を作成してください。Issue は設計書であり、レビューの基準です。

### Issue テンプレート

```markdown
## 📋 概要

[1-2文で変更内容を簡潔に説明]

関連issue: [関連するIssue番号があれば記載]

---

## 🎯 背景・課題

### 現状の問題
- [現在どのような問題があるか]
- [なぜこの変更が必要なのか]

### 課題
- [具体的な課題1]
- [具体的な課題2]
- [具体的な課題3]

---

## 🎯 目的・ゴール

### 主目的
[この変更で達成したいこと]

### 副次的目標
- [追加で達成したいこと1]
- [追加で達成したいこと2]

---

## 📖 要件定義

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

## 🛠️ 技術仕様

### アーキテクチャ

[システム構成図、フロー図など]

### 実装詳細

[具体的な実装方法、コード例など]

---

## ✅ 受け入れ基準

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

## ⏱️ 工数見積

### タスク分解

| タスク | 内容 | 見積工数 |
|--------|------|----------|
| 設計 | [設計内容] | X.Xh |
| 実装 | [実装内容] | X.Xh |
| テスト | [テスト内容] | X.Xh |
| ドキュメント更新 | [ドキュメント更新内容] | X.Xh |

合計見積: X時間（X営業日）

---

## 🧪 テスト計画

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

## 📈 次のステップ

[この機能完了後の展開、将来の拡張など]

---

## 📚 関連資料

- [関連ドキュメント、外部リンクなど]

---

## ✅ Definition of Done

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

### 工数見積ガイドライン

#### タスク分解の基本

| タスク | 内容 | 一般的な割合 |
|--------|------|------------|
| **設計** | 技術仕様の詳細化、アーキテクチャ検討 | 15-20% |
| **実装** | コーディング、デバッグ | 40-50% |
| **テスト** | テストコード作成、動作確認 | 20-25% |
| **ドキュメント更新** | README、CONTRIBUTING等の更新 | 10-15% |

#### 見積単位

- **時間単位**: 0.5時間刻み
- **営業日換算**: 1営業日 = 8時間
- **最小単位**: 0.5時間
- **最大単位**: 16時間（2営業日）

推奨: 16時間を超える場合は、タスクを分割してください。

#### 確実性レベル

| レベル | 説明 | バッファ | 例 |
|--------|------|---------|-----|
| **高確実性** | 過去に類似実装あり、よく知っている技術 | +10% | CRUDの追加、既存機能の微修正 |
| **中確実性** | 一般的な実装パターン、ある程度経験あり | +25% | 新しいAPIエンドポイント、標準的なリファクタリング |
| **低確実性** | 初めての技術、複雑な仕様 | +50% | 新しいフレームワーク導入、複雑なアルゴリズム実装 |

#### 見積例

##### 難易度: Low（簡単な修正・追加）
- 例: 既存画面へのフィールド追加、軽微なバグ修正
- 見積: 2-4時間（0.25-0.5営業日）
- 内訳:
  - 設計: 0.5h
  - 実装: 1.5h
  - テスト: 0.5h
  - ドキュメント: 0.5h

##### 難易度: Medium（通常の機能開発）
- 例: 新しいCRUD機能、APIエンドポイント追加
- 見積: 8-16時間（1-2営業日）
- 内訳:
  - 設計: 2h
  - 実装: 6h
  - テスト: 3h
  - ドキュメント: 1h

##### 難易度: High（複雑な機能・新技術導入）
- 例: 認証システム実装、外部サービス統合
- 見積: 24-40時間（3-5営業日）
- 内訳:
  - 設計: 6h
  - 実装: 18h
  - テスト: 10h
  - ドキュメント: 2h

#### バッファの考え方

**基本ルール**: 見積工数に確実性レベルに応じたバッファを追加

例: 実装8時間、確実性レベル「中」の場合
```
基本見積: 8h
バッファ: 8h × 25% = 2h
最終見積: 10h
```

推奨: 全体に+25%のバッファを追加することで、予期せぬ問題に対応できます。

#### 優先度と難易度の定義

| 優先度 | 説明 | 対応期限の目安 |
|--------|------|---------------|
| **High** | ビジネスクリティカル、ブロッカー | 即座に着手 |
| **Medium** | 重要だが緊急ではない | 1-2週間以内 |
| **Low** | あると便利、改善項目 | 時間があるとき |

| 難易度 | 説明 | 見積工数目安 |
|--------|------|-------------|
| **Low** | 簡単な修正、既知の実装パターン | 2-4時間 |
| **Medium** | 通常の機能開発、一般的な複雑さ | 8-16時間 |
| **High** | 複雑な実装、新技術、大規模変更 | 24時間以上 |

---

## Git ワークフロー

このプロジェクトは GitHub Flow を採用します。

### 🚨 重要な原則：ブランチを作ってから作業する

**作業を開始する前に、必ず以下の手順を守ってください：**

#### ❌ BAD: main ブランチで直接作業

```bash
# これは絶対にやってはいけません！
git checkout main
# main ブランチで直接ファイルを編集...
git add .
git commit -m "fix: 修正"
git push origin main  # ❌ main へ直接プッシュ
```

#### ✅ GOOD: 正しい手順

```bash
# 1. Issue を作成（例: Issue #42 を作成）

# 2. main ブランチを最新化
git checkout main
git pull origin main

# 3. 作業用ブランチを作成
git checkout -b feature/42-new-feature

# 4. 実装作業
# ファイルを編集...

# 5. コミット
git add .
git commit -m "feat: 新機能を追加 (issue#42)"

# 6. プッシュ
git push origin feature/42-new-feature

# 7. GitHub で PR を作成
```

#### ⚠️ 間違いに気づいた場合

**main ブランチで作業してしまった場合：**

```bash
# 方法1: 変更をまだコミットしていない場合
git stash                              # 変更を一時保存
git checkout -b feature/XX-fix         # 正しいブランチを作成
git stash pop                          # 変更を適用

# 方法2: すでにコミットしてしまった場合（プッシュ前）
git branch feature/XX-fix              # 現在の状態で新ブランチ作成
git reset --hard origin/main           # main を元に戻す
git checkout feature/XX-fix            # 新ブランチに切り替え
```

**main ブランチにプッシュしてしまった場合：**

すぐにチームに報告してください。revert が必要になる場合があります。

#### なぜこれが重要か？

1. **main ブランチの保護**
   - main は常に安定した状態を保つ必要があります
   - CI/CDで自動デプロイされる可能性があります

2. **変更の追跡**
   - PR を通じてコードレビューが可能になります
   - 変更履歴が明確になります

3. **ロールバック**
   - 問題があった場合、簡単に元に戻せます
   - main ブランチは影響を受けません

4. **並行作業**
   - 複数の機能を同時に開発できます
   - 他のメンバーの作業と競合しません

### ブランチ命名規則

**フォーマット:**
```
<type>/<issue番号>-<機能名>
```

**Type 一覧:**

| Type | 用途 | 例 |
|------|------|-----|
| `feature/` | 新機能の追加 | `feature/57-user-authentication` |
| `bugfix/` | バグ修正 | `bugfix/58-fix-cart-calculation` |
| `hotfix/` | 緊急修正（本番環境の問題） | `hotfix/59-critical-security-fix` |
| `refactor/` | リファクタリング | `refactor/60-optimize-queries` |
| `docs/` | ドキュメント更新 | `docs/61-update-readme` |

**良い例:**
```bash
feature/42-add-user-profile
bugfix/43-fix-login-error
docs/44-update-contributing
```

**悪い例:**
```bash
fix-bug              # ❌ Issue番号がない
feature-new          # ❌ 具体的な機能名がない
update               # ❌ typeとIssue番号がない
```

---

## コミット規約

[Conventional Commits](https://www.conventionalcommits.org/) に準拠します。

**フォーマット:**

```
<type>(<scope>): <subject> (issue#<番号>)

<body>（任意）
<footer>（任意）
```

**Type 一覧:**

| Type | 用途 | 例 |
|------|------|-----|
| `feat` | 新機能の追加 | `feat(auth): ログイン機能を追加` |
| `fix` | バグ修正 | `fix(cart): 合計金額の計算を修正` |
| `docs` | ドキュメントのみの変更 | `docs: READMEを更新` |
| `refactor` | リファクタリング（機能変更なし） | `refactor(user): サービスクラスに抽出` |
| `test` | テストの追加・修正 | `test(user): バリデーションテストを追加` |
| `chore` | ビルド・ツール・依存関係の変更 | `chore: Gemfile更新` |
| `perf` | パフォーマンス改善 | `perf(query): N+1問題を解消` |
| `style` | コードスタイルの変更（機能に影響なし） | `style: インデント修正` |

**Scope（任意）:**

| Scope | 説明 |
|-------|------|
| `app` | アプリケーション全般 |
| `auth` | 認証関連 |
| `api` | API関連 |
| `db` | データベース関連 |
| `docker` | Docker設定 |

**良い例:**

```bash
feat(app): ユーザー一覧画面を追加 (issue#12)
fix(auth): バリデーションエラーを修正 (issue#34)
docs: CONTRIBUTING.mdを追加 (issue#1)
refactor(user): サービスオブジェクトに抽出 (issue#45)
```

**悪い例:**

```bash
update code          # ❌ typeがない、issue番号がない
fix bug              # ❌ 具体的な内容がない、issue番号がない
feat: 機能追加       # ❌ 具体的な内容がない、issue番号がない
```

### ❌ 禁止事項：AI生成メッセージの追加

**コミットメッセージには、AI（Claude Code、GitHub Copilot、Cursorなど）が生成したことを示すメッセージを追加しないでください。**

**禁止例:**

```bash
# ❌ これらのメッセージを追加してはいけません
feat(app): 新機能を追加 (issue#12)

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>

# ❌ これも禁止
fix(auth): ログイン修正 (issue#34)

Generated by GitHub Copilot
```

**理由:**
- コミット履歴はコードの変更内容を追跡するものであり、使用したツールを記録する場所ではありません
- 将来的にツールの記載が不要になった場合、履歴の一貫性が失われます
- AIツールはあくまで開発支援ツールであり、成果物の品質は開発者の責任です

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

[動作確認手順をbashコマンドで記載]

## チェックリスト

- [ ] テスト追加
- [ ] コーディング規約準拠
- [ ] ドキュメント更新

Closes #XX

```

### ❌ 禁止事項：AI生成メッセージの追加

**PRの説明文には、AI（Claude Code、GitHub Copilot、Cursorなど）が生成したことを示すメッセージを追加しないでください。**

**禁止例:**

```markdown
Closes #12

🤖 Generated with Claude Code  # ❌
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>  # ❌
Generated by GitHub Copilot  # ❌
```

**理由:**
- PRは変更内容とその理由を説明するものであり、使用したツールを宣伝する場所ではありません
- プロジェクトの履歴として残る情報は、技術的な内容に限定すべきです
- AIツールの利用は個人の選択であり、プロジェクト全体に影響を与えるべきではありません

### 3. マージ戦略：Squash and Merge 推奨

このプロジェクトでは **Squash and Merge** を推奨します。

#### メリット

1. **綺麗な履歴**
   - main ブランチに `1 PR = 1 コミット` として記録
   - WIPコミットや修正コミットが残らない
   - 履歴が読みやすく、理解しやすい

2. **Conventional Commits との相性**
   - PR タイトルがそのままコミットメッセージになる
   - 統一されたフォーマットが維持される

3. **Revert が簡単**
   - 機能単位で1コミットなので、revert が容易
   - 影響範囲が明確

#### マージ戦略の比較

| 戦略 | メリット | デメリット | 推奨度 |
|------|---------|-----------|-------|
| **Squash and Merge** | 綺麗な履歴、1PR=1コミット | 個別コミットの履歴が消える | ⭐⭐⭐ 推奨 |
| Merge commit | 完全な履歴保持 | マージコミットで履歴が複雑 | ⭐ 特殊なケースのみ |
| Rebase and merge | リニアな履歴 | コンフリクト解決が複雑 | ⭐⭐ 小規模変更 |

#### 使い方

GitHub の PR 画面で「Squash and merge」を選択してください。

```
Squash and merge ▼
```

デフォルトで Squash and Merge が選択されるように設定することを推奨します。

---

## コーディング規約

### Rails

#### 1. Service Object パターン

複雑なビジネスロジックは Service Object に抽出：

```ruby
# app/services/order_service.rb
class OrderService
  def initialize(order:)
    @order = order
  end

  def call
    # ビジネスロジック
  end
end
```

#### 2. 早期リターン

条件分岐はネストを避け、早期リターンを使用：

```ruby
# ✅ GOOD: 早期リターン
def process(order)
  return if order.nil?
  return unless order.valid?

  order.save
end

# ❌ BAD: ネストが深い
def process(order)
  if order.present?
    if order.valid?
      order.save
    end
  end
end
```

#### 3. RuboCop 準拠

```bash
# チェック
bundle exec rubocop

# 自動修正
bundle exec rubocop -a
```

### データベース

#### 1. マイグレーション命名規則

```ruby
# タイムスタンプ_動詞_対象_詳細.rb
20251206_add_phone_number_to_users.rb
20251206_create_orders.rb
20251206_add_index_to_products_category_id.rb
```

#### 2. ロールバック可能性

すべてのマイグレーションは `down` メソッドを実装：

```ruby
class AddPhoneNumberToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :phone_number, :string
  end

  def down
    remove_column :users, :phone_number
  end
end
```

#### 3. カラムコメント必須

```ruby
add_column :products, :category, :string, comment: "商品カテゴリ"
add_column :products, :price, :decimal, comment: "価格（税抜）"
```

---

## テスト方針

### RSpec 必須

すべての新機能・修正にはテストを追加してください。

#### モデルテスト

```ruby
# spec/models/product_spec.rb
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#active?' do
    it 'ステータスがactiveの場合trueを返す' do
      product = build(:product, status: 'active')
      expect(product.active?).to be true
    end
  end
end
```

#### API テスト（Request Spec）

```ruby
# spec/requests/api/v1/orders_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  describe 'GET /api/v1/orders' do
    it '注文一覧を返す' do
      get '/api/v1/orders'
      expect(response).to have_http_status(:ok)
    end
  end
end
```

### テスト実行

```bash
# 全テスト実行
bundle exec rspec

# 特定ファイルのみ
bundle exec rspec spec/models/product_spec.rb

# カバレッジ確認
bundle exec rspec --format documentation
```

---

## コードレビュー基準

### 基本チェック項目

- [ ] Issue の要件を満たしているか
- [ ] テストが十分か
- [ ] 命名が適切か
- [ ] パフォーマンス上の問題（N+1など）がないか
- [ ] セキュリティ上の懸念がないか
- [ ] マイグレーションはロールバック可能か

### セキュリティチェック

#### 1. SQLインジェクション対策

**✅ DO: プレースホルダーを使う**
```ruby
# 良い例
User.where("email = ?", params[:email])
User.where(email: params[:email])
```

**❌ DON'T: 直接文字列を埋め込まない**
```ruby
# 悪い例 - SQLインジェクションの危険
User.where("email = '#{params[:email]}'")
```

#### 2. XSS（クロスサイトスクリプティング）対策

**✅ DO: ERBの自動エスケープを活用**
```erb
<!-- 良い例 - 自動的にエスケープされる -->
<p><%= @user.name %></p>
<p><%= sanitize @user.bio %></p>
```

**❌ DON'T: html_safe を安易に使わない**
```erb
<!-- 悪い例 - XSSの危険 -->
<p><%= @user.name.html_safe %></p>
<%= raw @user.bio %>
```

#### 3. CSRF（クロスサイトリクエストフォージェリ）対策

**✅ DO: Railsのデフォルト設定を維持**
```ruby
# 良い例 - ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
```

**❌ DON'T: CSRF保護を無効化しない**
```ruby
# 悪い例
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token  # ❌
end
```

#### 4. マスアサインメント対策

**✅ DO: Strong Parameters を使う**
```ruby
# 良い例
def user_params
  params.require(:user).permit(:name, :email)
end

def create
  @user = User.new(user_params)
end
```

**❌ DON'T: params を直接渡さない**
```ruby
# 悪い例 - 意図しない属性の更新が可能
def create
  @user = User.new(params[:user])  # ❌
end
```

#### 5. 機密情報の保護

**✅ DO: 環境変数を使う**
```ruby
# 良い例
api_key = ENV['API_KEY']
database_url = ENV['DATABASE_URL']
```

**❌ DON'T: ハードコードしない**
```ruby
# 悪い例
api_key = "sk_live_abc123xyz"  # ❌
DATABASE_URL = "postgresql://user:pass@host/db"  # ❌
```

#### 6. 認可チェック

**✅ DO: 権限チェックを実装**
```ruby
# 良い例
def update
  @post = current_user.posts.find(params[:id])  # 自分の投稿のみ
  @post.update(post_params)
end
```

**❌ DON'T: IDだけで検索しない**
```ruby
# 悪い例 - 他人の投稿も更新できてしまう
def update
  @post = Post.find(params[:id])  # ❌
  @post.update(post_params)
end
```

### パフォーマンスチェック

#### 1. N+1 クエリ回避

**✅ DO: eager loading 使用**
```ruby
# 良い例
@products = Product.includes(:images, :variants).all
```

**❌ DON'T: N+1発生**
```ruby
# 悪い例
@products = Product.all
@products.each { |p| p.images.first }  # N+1！
```

#### 2. インデックス追加

頻繁に検索するカラムにはインデックス：

```ruby
add_index :products, :category_id
add_index :orders, [:user_id, :created_at]
```

---

## 質問・サポート

- Issue を作成して相談してください。
