require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AssetExplorer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.hosts << "ohmiris.space"

    # OAuth configuration
    config.x.oauth.client_id = "CLIENT_ID"
    config.x.oauth.client_secret = "CLIENT_SECRET"
    config.x.oauth.idp_url = "https://login.eveonline.com/"
    config.x.oauth.redirect_uri = "https://ohmiris.space/eve_callback"
    config.x.oauth.scopes = "publicData esi-wallet.read_character_wallet.v1 esi-universe.read_structures.v1 esi-assets.read_assets.v1 esi-ui.open_window.v1 esi-ui.write_waypoint.v1 esi-markets.structure_markets.v1 esi-characters.read_loyalty.v1 esi-markets.read_character_orders.v1 esi-characters.read_blueprints.v1"
    config.sass.preferred_syntax = :scss
  end
end
