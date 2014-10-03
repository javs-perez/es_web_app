require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EsWeb1
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  

    # config.message = { 
    #   header: {
    #     ref_id:       Time.now.to_i, 
    #     client_id:    "es_web",
    #     timestamp:    Time.now.utc,
    #     priority:     "normal",
    #     auth_token:   ENV["RABBITMQ_AUTH_TOKEN"] || "test_auth_token",
    #     event_type:   "project_status_update"
    #     }, 
    #     body: {
    #       user_id:      @id    || "id",
    #       channel:      "email",
    #       email:        @email || "email",
    #       user_name:    @name  || "name", 
    #       user_mobile:  @phone || "phone"
    #     } 
    #   }
  end
end
