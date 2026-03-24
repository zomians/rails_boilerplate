.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## 定番gemを含むRailsアプリケーションを作成（通常開発用）
	@echo "📦 Railsアプリケーションを作成します..."
	@[ -f README.md ] && cp README.md README.md.bak || true
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app app \
	rails new . --name railsapp --database=postgresql --css=tailwind --javascript=importmap --skip-test --force
	@[ -f README.md.bak ] && mv README.md.bak README.md || true
	@echo "✅ Rails アプリケーションを作成しました"
	@echo "⚙️  Procfile.devをDocker環境用に調整します..."
	@if [ -f Procfile.dev ]; then \
		if ! grep -q "\-b 0.0.0.0" Procfile.dev; then \
			perl -i -pe 's/bin\/rails server/bin\/rails server -b 0.0.0.0/' Procfile.dev; \
			echo "✅ Procfile.dev を Docker 環境用に編集しました"; \
		fi \
	fi
	@echo "📦 定番gemを追加します..."
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app app \
	bash -c "bundle add mini_racer stripe devise kaminari rack-cors && \
	bundle add pry-rails --group development && \
	bundle add rspec-rails factory_bot_rails faker --group 'development,test'"
	@echo "✅ 定番gemを追加しました"
	@echo "📄 Stripe initializerを作成します..."
	@mkdir -p config/initializers
	@printf '%s\n' \
		'# Stripe configuration' \
		'# API keys are loaded from environment variables' \
		'' \
		'Rails.configuration.stripe = {' \
		"  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY']," \
		"  secret_key: ENV['STRIPE_SECRET_KEY']" \
		'}' \
		'' \
		'Stripe.api_key = Rails.configuration.stripe[:secret_key]' \
		> config/initializers/stripe.rb
	@echo "✅ Stripe initializerを作成しました"
	@echo "📄 CORS initializerを作成します..."
	@printf '%s\n' \
		'# CORS configuration' \
		'# Adjust origins for your production environment' \
		'' \
		'Rails.application.config.middleware.insert_before 0, Rack::Cors do' \
		'  allow do' \
		'    origins "http://localhost:3000"' \
		'' \
		'    resource "*",' \
		'      headers: :any,' \
		'      methods: [:get, :post, :put, :patch, :delete, :options, :head]' \
		'  end' \
		'end' \
		> config/initializers/cors.rb
	@echo "✅ CORS initializerを作成しました"
	@echo "🎉 セットアップ完了！ 次のコマンド: make up"

.PHONY: init-ec
init-ec: ## Solidus専用Railsアプリケーションを作成（ECサイト開発用）
	@echo "📦 Solidus専用Railsアプリケーションを作成します..."
	@[ -f README.md ] && cp README.md README.md.bak || true
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app app \
	rails new . --name railsapp --database=postgresql --javascript=importmap --skip-asset-pipeline --force
	@[ -f README.md.bak ] && mv README.md.bak README.md || true
	@echo "✅ Rails アプリケーションを作成しました"
	@echo "🔧 アセットパイプラインをSprocketsに設定します..."
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app app bundle add sprockets-rails
	@echo "✅ sprockets-railsを追加しました"
	@echo "📄 Sprockets用のmanifest.jsを作成します..."
	@mkdir -p app/assets/config
	@printf '%s\n' \
		'//= link_tree ../images' \
		'//= link_directory ../stylesheets .css' \
		'//= link_directory ../javascripts .js' \
		> app/assets/config/manifest.js
	@echo "✅ manifest.jsを作成しました"
	@echo "📄 assets initializerを作成します..."
	@mkdir -p config/initializers
	@printf '%s\n' \
		'# Be sure to restart your server when you modify this file.' \
		'' \
		'# Version of your assets, change this if you want to expire all your assets.' \
		'Rails.application.config.assets.version = "1.0"' \
		'' \
		'# Add additional assets to the asset load path.' \
		'# Rails.application.config.assets.paths << Emoji.images_path' \
		'' \
		'# Precompile additional assets.' \
		'# application.js, application.css, and all non-JS/CSS in the app/assets' \
		'# folder are already added.' \
		'# Rails.application.config.assets.precompile += %w( admin.js admin.css )' \
		> config/initializers/assets.rb
	@echo "✅ assets.rbを作成しました"
	@echo "📦 mini_racerを追加します..."
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app app bundle add mini_racer
	@echo "📦 Solidusをセットアップします..."
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app app \
	bash -c "bundle add solidus && \
	rails generate solidus:install --auto-accept && \
	bundle install && \
	rails db:migrate && \
	rails db:seed"
	@echo "⚙️  Procfile.devをDocker環境用に調整します..."
	@if [ -f Procfile.dev ]; then \
		if ! grep -q "\-b 0.0.0.0" Procfile.dev; then \
			perl -i -pe 's/bin\/rails server/bin\/rails server -b 0.0.0.0/' Procfile.dev; \
			echo "✅ Procfile.dev を Docker 環境用に編集しました"; \
		fi \
	fi
	@echo "🎉 Solidusのセットアップ完了！"
	@echo "次のコマンド: make up"
	@echo "管理画面: http://localhost:3000/admin (admin@example.com / test123)"

.PHONY: up
up: ## コンテナを起動
	docker compose -f compose.development.yaml --env-file .env.development up -d
	@echo "アプリケーションが起動しました: http://localhost:3000"

.PHONY: down
down: ## コンテナを停止
	docker compose -f compose.development.yaml --env-file .env.development down --remove-orphans
	@echo "✅ コンテナを停止しました"

.PHONY: bash
bash: ## app コンテナに入る
	docker compose -f compose.development.yaml --env-file .env.development exec app bash

.PHONY: clean
clean: ## このプロジェクトのDocker関連をクリーン（公式イメージは保持）
	docker compose -f compose.development.yaml --env-file .env.development down -v --rmi local

# ==============================================
# 本番環境用コマンド
# ==============================================

.PHONY: prod-deploy
prod-deploy: ## 本番環境をデプロイ（ビルド→再作成→マイグレーション→シード）
	docker compose -f compose.production.yaml --env-file .env.production build --no-cache
	docker compose -f compose.production.yaml --env-file .env.production down
	docker compose -f compose.production.yaml --env-file .env.production up -d
	docker compose -f compose.production.yaml --env-file .env.production exec app rails db:create db:migrate db:seed
	@echo "✅ デプロイが完了しました"

.PHONY: prod-logs
prod-logs: ## 本番環境のログを表示
	docker compose -f compose.production.yaml --env-file .env.production logs -f

.PHONY: prod-bash
prod-bash: ## 本番環境のappコンテナに入る
	docker compose -f compose.production.yaml --env-file .env.production exec app bash

.PHONY: prod-db-reset
prod-db-reset: ## 本番環境のデータベースをリセット（注意：全データ削除）
	@echo "⚠️  警告: 全てのデータが削除されます。続行しますか? [y/N]" && read ans && [ $${ans:-N} = y ]
	docker compose -f compose.production.yaml --env-file .env.production exec app rails db:reset
	@echo "✅ データベースをリセットしました"

.PHONY: prod-ps
prod-ps: ## 本番環境のコンテナ状態を表示
	docker compose -f compose.production.yaml --env-file .env.production ps

# ==============================================
# バックアップ用コマンド
# ==============================================

PROD_COMPOSE := docker compose -f compose.production.yaml --env-file .env.production
BACKUP_DIR := backups
BACKUP_RETENTION_DAYS ?= 7
BACKUP_CRON_SCHEDULE ?= 0 2 * * *
BACKUP_POSTGRES_USER := $(shell grep '^POSTGRES_USER=' .env.production 2>/dev/null | cut -d= -f2)
BACKUP_POSTGRES_DB := $(shell grep '^POSTGRES_DB=' .env.production 2>/dev/null | cut -d= -f2)

.PHONY: prod-backup
prod-backup: ## 本番DBをバックアップ（即時実行）
	@mkdir -p $(BACKUP_DIR)
	@FILE=$(BACKUP_DIR)/$$(date +%Y%m%d_%H%M%S).sql.gz; \
	$(PROD_COMPOSE) exec -T db pg_dump --clean --if-exists -U $(BACKUP_POSTGRES_USER) $(BACKUP_POSTGRES_DB) | gzip > $$FILE && \
	echo "✅ バックアップを作成しました: $$FILE" || { echo "❌ バックアップに失敗しました"; rm -f $$FILE; exit 1; }
	@find $(BACKUP_DIR) -name "*.sql.gz" -mtime +$(BACKUP_RETENTION_DAYS) -delete && \
	echo "🗑️  $(BACKUP_RETENTION_DAYS)日以上前のバックアップを削除しました"

.PHONY: prod-backup-list
prod-backup-list: ## バックアップ一覧をサイズ付きで表示
	@ls -lh $(BACKUP_DIR)/*.sql.gz 2>/dev/null || echo "バックアップファイルがありません"

.PHONY: prod-backup-restore
prod-backup-restore: ## 指定ファイルからDBをリストア（例: make prod-backup-restore FILE=backups/20240101_020000.sql.gz）
	@test -n "$(FILE)" || { echo "エラー: FILE=<バックアップファイルパス> を指定してください"; exit 1; }
	@test -f "$(FILE)" || { echo "エラー: ファイルが見つかりません: $(FILE)"; exit 1; }
	@echo "⚠️  警告: $(FILE) からリストアします。現在のデータが上書きされます。続行しますか? [y/N]" && read ans && [ $${ans:-N} = y ]
	@gunzip -c $(FILE) | $(PROD_COMPOSE) exec -T db psql -U $(BACKUP_POSTGRES_USER) $(BACKUP_POSTGRES_DB)
	@echo "✅ リストアが完了しました"

.PHONY: prod-backup-cron
prod-backup-cron: ## cronにバックアップジョブを登録（デフォルト: 毎日2時）
	@CRON_CMD="$(BACKUP_CRON_SCHEDULE) cd $$(pwd) && make prod-backup >> /var/log/backup.log 2>&1"; \
	( crontab -l 2>/dev/null | grep -v "make prod-backup"; echo "$$CRON_CMD" ) | crontab -
	@echo "✅ cronジョブを登録しました: $(BACKUP_CRON_SCHEDULE)"

.PHONY: prod-backup-cron-remove
prod-backup-cron-remove: ## cronからバックアップジョブを削除
	@crontab -l 2>/dev/null | grep -v "make prod-backup" | crontab -
	@echo "✅ cronジョブを削除しました"

.PHONY: prod-backup-cron-status
prod-backup-cron-status: ## cronジョブの状態と最新ログを表示
	@echo "=== 登録済みcronジョブ ==="
	@crontab -l 2>/dev/null | grep "make prod-backup" || echo "バックアップcronジョブは登録されていません"
	@echo ""
	@echo "=== 最新のcronログ (直近20行) ==="
	@tail -n 20 /var/log/backup.log 2>/dev/null || echo "ログファイルがありません"
