# Load environment variables from .env.development
include .env.development
export

.PHONY: help
help: ## ヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: init
init: ## Rails new を実行（初回のみ）
	docker compose --env-file .env.development run --rm --workdir /app app rails new . --name ${APP_NAME} --database=postgresql --css=tailwind --javascript=importmap --skip-test --force
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
clean: ## Docker関連を全てクリーン（全プロジェクト対象）
	docker compose --env-file .env.development down -v --rmi all
	docker system prune -a --force
