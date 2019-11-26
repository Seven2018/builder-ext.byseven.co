LinkedIn.configure do |config|
  config.client_id     = Rails.application.credentials.linkedin_client_id
  config.client_secret = Rails.application.credentials.linkedin_client_secret

  # This must exactly match the redirect URI you set on your application's
  # settings page. If your redirect_uri is dynamic, pass it into
  # `auth_code_url` instead.
  config.redirect_uri  = "http://localhost:3000/linkedin_scrape_callback"
  config.scope = 'r_liteprofile'
end
