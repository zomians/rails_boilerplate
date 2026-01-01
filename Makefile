# Load environment variables from .env
include .env
export

.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## Rails new を実行（初回のみ）
	docker compose --env-file .env run --rm --workdir /app app rails new . --name ${APP_NAME} --database=postgresql --css=tailwind --javascript=importmap --skip-test --force
	@echo "Rails アプリケーションを作成しました"

.PHONY: up
up: ## コンテナを起動
	docker compose up -d
	@echo "アプリケーションが起動しました: http://localhost:3000"

.PHONY: bash
bash: ## app コンテナに入る
	docker compose exec app bash

.PHONY: clean
clean: ## Docker関連を全てクリーン（全プロジェクト対象）
	docker compose down -v --rmi all
	docker system prune -a --force
