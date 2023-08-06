Rails.application.config.importmap.draw do
  # Directories
  pin_all_from "app/javascript/controllers", under: "controllers"
  pin_all_from "app/javascript/channels", under: "channels", to: "channels/*.js"
  pin_all_from "app/javascript/images", under: "images"
  pin_all_from "app/javascript/stylesheets", under: "stylesheets"

  # Files
  pin "application"
  pin "cable", to: "channels/cable.js"
  pin "rails-ujs", to: "rails-ujs.js"
  # Pin npm packages by adding the package names from your package.json
  # pin_npm_package "alpinejs", "axios", "local-time", "md5", "trix", "turbo-rails"

  # Use the public/assets directory for images and other non-JavaScript assets
  pin_all_from "public/assets", to: "assets"
end
