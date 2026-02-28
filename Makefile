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
	bash -c "bundle add mini_racer devise kaminari rack-cors && \
	bundle add pry-rails --group development && \
	bundle add rspec-rails factory_bot_rails faker --group 'development,test'"
	@echo "✅ 定番gemを追加しました"
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
		-e DATABASE_URL=postgres://postgres-user:postgres-password@db:5432/railsapp-test \
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
