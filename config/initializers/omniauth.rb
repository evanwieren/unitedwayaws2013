Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, $app_yml["TWITTER_KEY"], $app_yml["TWITTER_SECRET"]
  provider :facebook, $app_yml["FACEBOOK_KEY"], $app_yml["FACEBOOK_SECRET"], { :scope => 'publish_stream' }
end