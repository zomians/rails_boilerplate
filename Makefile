.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## Rails new を実行（初回のみ）
	@set -a && . ./.env.development && set +a && \
	docker compose --env-file .env.development run --rm --workdir /app app \
	rails new . --name $$APP_NAME --database=postgresql --css=tailwind --javascript=importmap --skip-test --force
	@echo "✅ Rails アプリケーションを作成しました"
	@if [ -f Procfile.dev ]; then \
		if ! grep -q "\-b 0.0.0.0" Procfile.dev; then \
			perl -i -pe 's/bin\/rails server/bin\/rails server -b 0.0.0.0/' Procfile.dev; \
			echo "✅ Procfile.dev を Docker 環境用に編集しました"; \
		fi \
	fi

.PHONY: up
up: ## コンテナを起動
	docker compose --env-file .env.development up -d
	@echo "アプリケーションが起動しました: http://localhost:3000"

.PHONY: bash
bash: ## app コンテナに入る
	docker compose --env-file .env.development exec app bash

.PHONY: clean
clean: ## このプロジェクトのDocker関連をクリーン（公式イメージは保持）
	docker compose --env-file .env.development down -v --rmi local

# ==============================================
# 本番環境用コマンド
# ==============================================

.PHONY: prod-up
prod-up: ## 本番環境を起動
	docker compose -f compose.production.yaml --env-file .env.production up -d
	@echo "✅ 本番環境が起動しました"

.PHONY: prod-down
prod-down: ## 本番環境を停止
	docker compose -f compose.production.yaml --env-file .env.production down
	@echo "✅ 本番環境を停止しました"

.PHONY: prod-build
prod-build: ## 本番環境のイメージをビルド
	docker compose -f compose.production.yaml --env-file .env.production build --no-cache
	@echo "✅ 本番環境のイメージをビルドしました"

.PHONY: prod-logs
prod-logs: ## 本番環境のログを表示
	docker compose -f compose.production.yaml --env-file .env.production logs -f

.PHONY: prod-bash
prod-bash: ## 本番環境のappコンテナに入る
	docker compose -f compose.production.yaml --env-file .env.production exec app bash

.PHONY: prod-db-setup
prod-db-setup: ## 本番環境のデータベースをセットアップ
	docker compose -f compose.production.yaml --env-file .env.production exec app rails db:create db:migrate
	@echo "✅ データベースをセットアップしました"

.PHONY: prod-db-reset
prod-db-reset: ## 本番環境のデータベースをリセット（注意：全データ削除）
	@echo "⚠️  警告: 全てのデータが削除されます。続行しますか? [y/N]" && read ans && [ $${ans:-N} = y ]
	docker compose -f compose.production.yaml --env-file .env.production exec app rails db:reset
	@echo "✅ データベースをリセットしました"

.PHONY: prod-restart
prod-restart: ## 本番環境を再起動
	docker compose -f compose.production.yaml --env-file .env.production restart
	@echo "✅ 本番環境を再起動しました"

.PHONY: prod-ps
prod-ps: ## 本番環境のコンテナ状態を表示
	docker compose -f compose.production.yaml --env-file .env.production ps
