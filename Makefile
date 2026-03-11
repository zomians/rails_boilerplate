SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -c

.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ==============================================
# 初期セットアップ用（実行後はこのセクションを削除してください）
# ==============================================

.PHONY: init
init: ## 【削除予定】定番gemを含むRailsアプリケーションを作成（通常開発用）
	@echo "📦 Railsアプリケーションを作成します..."
	@[ -f README.md ] && cp README.md README.md.bak || true
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app railsapp \
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
	docker compose -f compose.development.yaml --env-file .env.development run --rm --workdir /app railsapp \
	bash -c "bundle add square.rb devise kaminari rack-cors && \
	bundle add pry-rails --group development && \
	bundle add rspec-rails factory_bot_rails faker --group 'development,test'"
	@echo "✅ 定番gemを追加しました"
	@echo "📄 Square initializerを作成します..."
	@mkdir -p config/initializers
	@printf '%s\n' \
		'require "square"' \
		'' \
		'SQUARE_CLIENT = if ENV["SQUARE_ACCESS_TOKEN"].present?' \
		'  Square::Client.new(' \
		'    token: ENV.fetch("SQUARE_ACCESS_TOKEN"),' \
		'    base_url: ENV.fetch("SQUARE_ENVIRONMENT", "sandbox") == "production" ? Square::Environment::PRODUCTION : Square::Environment::SANDBOX' \
		'  )' \
		'end' \
		'' \
		'SQUARE_LOCATION_ID = ENV["SQUARE_LOCATION_ID"]' \
		> config/initializers/square.rb
	@echo "✅ Square initializerを作成しました"
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

# ==============================================
# 開発用コマンド
# ==============================================

.PHONY: up
up: ## コンテナを起動
	docker compose -f compose.development.yaml --env-file .env.development up -d
	@echo "アプリケーションが起動しました: http://localhost:3000"

.PHONY: down
down: ## コンテナを停止
	docker compose -f compose.development.yaml --env-file .env.development down --remove-orphans
	@echo "✅ コンテナを停止しました"

.PHONY: bash
bash: ## railsapp コンテナに入る
	docker compose -f compose.development.yaml --env-file .env.development exec railsapp bash

.PHONY: test
test: ## RSpecテストを実行
	docker compose -f compose.development.yaml --env-file .env.development exec \
		-e DATABASE_URL=postgres://postgres-user:postgres-password@postgresdb:5432/railsapp-test \
		railsapp bundle exec rspec

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
	docker compose -f compose.production.yaml --env-file .env.production exec railsapp rails db:create db:migrate db:seed
	@echo "✅ デプロイが完了しました"

.PHONY: prod-logs
prod-logs: ## 本番環境のログを表示
	docker compose -f compose.production.yaml --env-file .env.production logs -f

.PHONY: prod-bash
prod-bash: ## 本番環境のrailsappコンテナに入る
	docker compose -f compose.production.yaml --env-file .env.production exec railsapp bash

.PHONY: prod-db-reset
prod-db-reset: ## 本番環境のデータベースをリセット（注意：全データ削除）
	@echo "⚠️  警告: 全てのデータが削除されます。続行しますか? [y/N]" && read ans && [ $${ans:-N} = y ]
	docker compose -f compose.production.yaml --env-file .env.production exec railsapp rails db:reset
	@echo "✅ データベースをリセットしました"

.PHONY: prod-secret
prod-secret: ## SECRET_KEY_BASEを生成して表示
	docker compose -f compose.production.yaml --env-file .env.production run --rm railsapp bundle exec rails secret

.PHONY: prod-ps
prod-ps: ## 本番環境のコンテナ状態を表示
	docker compose -f compose.production.yaml --env-file .env.production ps

# ==============================================
# バックアップ用コマンド（本番環境）
# ==============================================

BACKUP_DIR := backups
BACKUP_RETENTION_DAYS ?= 7
BACKUP_CRON_SCHEDULE ?= 0 2 * * *
PROD_COMPOSE := docker compose -f compose.production.yaml --env-file .env.production

.PHONY: prod-backup
prod-backup: ## 本番DBのバックアップを作成（BACKUP_RETENTION_DAYS=7で世代管理）
	@mkdir -p $(BACKUP_DIR)
	@FILENAME=$(BACKUP_DIR)/$$(date +%Y%m%d_%H%M%S).sql.gz; \
	$(PROD_COMPOSE) exec -T postgresdb \
		bash -c 'pg_dump --clean --if-exists -U $$POSTGRES_USER $$POSTGRES_DB' | gzip > "$$FILENAME"; \
	RESULT=$$?; \
	FILESIZE=$$(wc -c < "$$FILENAME" 2>/dev/null | tr -d ' '); \
	if [ "$$RESULT" -ne 0 ] || [ "$${FILESIZE:-0}" -lt 100 ]; then \
		echo "❌ バックアップに失敗しました（終了コード: $$RESULT, ファイルサイズ: $${FILESIZE:-0}B）"; \
		rm -f "$$FILENAME"; \
		exit 1; \
	fi; \
	echo "✅ バックアップを作成しました: $$FILENAME ($$(du -h "$$FILENAME" | cut -f1))"
	@find $(BACKUP_DIR) -name "*.sql.gz" -mtime +$(BACKUP_RETENTION_DAYS) -delete 2>/dev/null; \
	echo "🗑️  $(BACKUP_RETENTION_DAYS)日以上前のバックアップを削除しました"

.PHONY: prod-backup-list
prod-backup-list: ## バックアップ一覧を表示
	@if [ -d $(BACKUP_DIR) ] && ls $(BACKUP_DIR)/*.sql.gz 1>/dev/null 2>&1; then \
		echo "📋 バックアップ一覧:"; \
		ls -lh $(BACKUP_DIR)/*.sql.gz; \
	else \
		echo "バックアップがありません"; \
	fi

.PHONY: prod-backup-restore
prod-backup-restore: ## バックアップからリストア（FILE=backups/YYYYMMDD_HHMMSS.sql.gz）
	@if [ -z "$(FILE)" ]; then \
		echo "❌ FILEを指定してください: make prod-backup-restore FILE=backups/YYYYMMDD_HHMMSS.sql.gz"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "❌ ファイルが見つかりません: $(FILE)"; \
		exit 1; \
	fi
	@echo "⚠️  警告: データベースを $(FILE) から復元します。既存のデータは上書きされます。続行しますか? [y/N]" && read ans && [ $${ans:-N} = y ]
	gunzip -c $(FILE) | $(PROD_COMPOSE) exec -T postgresdb \
		bash -c 'psql -U $$POSTGRES_USER $$POSTGRES_DB'
	@echo "✅ リストアが完了しました: $(FILE)"

.PHONY: prod-backup-cron
prod-backup-cron: ## pg_dumpのcronジョブを設定（デフォルト: 毎日2:00、7日間保持）
	@mkdir -p $(BACKUP_DIR)
	@CRON_CMD="$(BACKUP_CRON_SCHEDULE) PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; cd $(CURDIR) && make prod-backup >> $(CURDIR)/$(BACKUP_DIR)/cron.log 2>&1"; \
	(crontab -l 2>/dev/null | grep -v "make prod-backup"; echo "$$CRON_CMD") | crontab -
	@echo "✅ cronジョブを設定しました"
	@echo "   スケジュール: $(BACKUP_CRON_SCHEDULE)"
	@echo "   保持日数: $(BACKUP_RETENTION_DAYS)日"
	@echo "   ログ: $(CURDIR)/$(BACKUP_DIR)/cron.log"
	@crontab -l | grep "prod-backup"

.PHONY: prod-backup-cron-remove
prod-backup-cron-remove: ## pg_dumpのcronジョブを削除
	@(crontab -l 2>/dev/null | grep -v "make prod-backup") | crontab -
	@echo "✅ cronジョブを削除しました"

.PHONY: prod-backup-cron-status
prod-backup-cron-status: ## cronジョブの状態を表示
	@echo "📋 現在のcronジョブ:"
	@crontab -l 2>/dev/null | grep "prod-backup" || echo "   設定されていません"
	@echo ""
	@echo "📋 最新のcronログ:"
	@if [ -f $(BACKUP_DIR)/cron.log ]; then tail -5 $(BACKUP_DIR)/cron.log; else echo "   ログがありません"; fi
