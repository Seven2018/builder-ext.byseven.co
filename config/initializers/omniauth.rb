Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, Rails.application.credentials.linkedin_client_id, Rails.application.credentials.linkedin_client_secret
end
