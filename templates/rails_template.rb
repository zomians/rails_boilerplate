# Rails Application Template for Boilerplate
# This template sets up a Rails application with common gems and i18n configuration

# Add common gems
gem "mini_racer"
gem "stripe"
gem "rails-i18n"

gem_group :development do
  gem "pry-rails"
end

gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

after_bundle do
  # Configure Procfile.dev for Docker environment (bind to 0.0.0.0)
  if File.exist?("Procfile.dev")
    gsub_file "Procfile.dev", "bin/rails server", "bin/rails server -b 0.0.0.0"
    say "✅ Procfile.dev configured for Docker environment", :green
  end

  # Create Stripe initializer
  create_file "config/initializers/stripe.rb", <<~RUBY
    # Stripe configuration
    # API keys are loaded from environment variables

    Rails.configuration.stripe = {
      publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
      secret_key: ENV['STRIPE_SECRET_KEY']
    }

    Stripe.api_key = Rails.configuration.stripe[:secret_key]
  RUBY
  say "✅ Stripe initializer created", :green

  # Configure i18n settings
  inject_into_file "config/application.rb", after: /config\.load_defaults.*\n/ do
    <<~RUBY

      # Set default locale to Japanese
      config.i18n.default_locale = :ja
      # Set available locales
      config.i18n.available_locales = [:ja, :en]
      # Set timezone to Tokyo
      config.time_zone = "Tokyo"
      # Set Active Record timezone to local
      config.active_record.default_timezone = :local
    RUBY
  end
  say "✅ i18n settings configured in config/application.rb", :green

  # Create Japanese locale file
  create_file "config/locales/ja.yml", <<~YAML
    # config/localesディレクトリ内のファイルは国際化に使用され、
    # Railsによって自動的に読み込まれます。英語以外のロケールを使用する場合は、
    # このディレクトリに必要なファイルを追加してください。
    #
    # ロケールを使用するには、`I18n.t`を使用します：
    #
    #     I18n.t "hello"
    #
    # ビューでは、これは単に`t`としてエイリアスされています：
    #
    #     <%= t("hello") %>
    #
    # 異なるロケールを使用するには、`I18n.locale`で設定します：
    #
    #     I18n.locale = :ja
    #
    # これにより、config/locales/ja.ymlの情報が使用されます。
    #
    # APIの詳細については、Rails国際化ガイドをお読みください：
    # https://guides.rubyonrails.org/i18n.html
    #
    # YAMLは以下の大文字小文字を区別しない文字列をブール値として解釈することに注意してください：
    # `true`, `false`, `on`, `off`, `yes`, `no`。したがって、これらの文字列は
    # 文字列として解釈されるために引用符で囲む必要があります。例：
    #
    #     ja:
    #       "yes": はい
    #       enabled: "ON"

    ja:
      hello: "こんにちは"

      # アプリケーション共通の翻訳
      common:
        created: "作成されました"
        updated: "更新されました"
        deleted: "削除されました"
        save: "保存"
        edit: "編集"
        delete: "削除"
        cancel: "キャンセル"
        back: "戻る"
        confirm: "確認"
        search: "検索"
        submit: "送信"
        show: "表示"
        new: "新規作成"
        back_to: "%{name}一覧に戻る"
        are_you_sure: "本当に削除しますか？"
        no_records_found: "%{name}が見つかりません"

      # 日時フォーマット
      time:
        formats:
          default: "%Y年%m月%d日 %H:%M:%S"
          short: "%m月%d日 %H:%M"
          long: "%Y年%m月%d日(%a) %H時%M分%S秒"

      date:
        formats:
          default: "%Y年%m月%d日"
          short: "%m月%d日"
          long: "%Y年%m月%d日(%a)"

      # Posts関連の翻訳
      posts:
        title: "投稿"
        title_singular: "投稿"
        index:
          title: "投稿一覧"
          new_post: "新規投稿"
          no_posts: "投稿が見つかりません"
        show:
          title: "投稿詳細"
          edit: "この投稿を編集"
          back: "投稿一覧に戻る"
          destroy: "この投稿を削除"
        new:
          title: "新規投稿"
          back: "投稿一覧に戻る"
        edit:
          title: "投稿を編集"
          show: "この投稿を表示"
          back: "投稿一覧に戻る"
        form:
          error_message: "%{count}個のエラーがあります"
        messages:
          created: "投稿が正常に作成されました"
          updated: "投稿が正常に更新されました"
          destroyed: "投稿が正常に削除されました"

      # ActiveRecord属性名
      activerecord:
        models:
          post: "投稿"
        attributes:
          post:
            content: "内容"
  YAML
  say "✅ Japanese locale file created", :green

  # Note: Scaffold templates will be copied separately via Makefile
  # The templates directory is not available inside the Docker container during rails new

  say "🎉 Setup complete! Your Rails application is ready with i18n support.", :green
  say "Next step: Start the application with 'make up'", :blue
end
