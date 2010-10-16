
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,  *TheDailyMo::AuthKeys.network_keys_and_secret(:twitter)
  provider :facebook, *TheDailyMo::AuthKeys.network_keys_and_secret(:facebook)
end
