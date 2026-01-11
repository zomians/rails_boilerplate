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

  # Copy Japanese locale file
  if File.exist?("templates/locales/ja.yml")
    copy_file "templates/locales/ja.yml", "config/locales/ja.yml"
    say "✅ Japanese locale file created", :green
  else
    say "⚠️  Warning: templates/locales/ja.yml not found, skipping", :yellow
  end

  # Copy scaffold templates for i18n
  if Dir.exist?("templates/scaffold")
    directory "templates/scaffold", "lib/templates"
    say "✅ Scaffold templates for i18n copied to lib/templates", :green
  else
    say "⚠️  Warning: templates/scaffold directory not found, skipping", :yellow
  end

  say "🎉 Setup complete! Your Rails application is ready with i18n support.", :green
  say "Next step: Start the application with 'make up'", :blue
end
